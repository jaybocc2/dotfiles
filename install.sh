#!/bin/bash
# install for jaybocc2@'s dotfiles
DOT_FILES=$(git ls-tree @{u}|awk '{print $4}' |egrep -v '(/|LICENSE|README|install.sh)')
OS=$(uname |tr '[:upper:]' '[:lower:]')
DEB_DEPS="curl exuberant-ctags wget tmux zsh vim git xclip zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
libncurses5-dev libssl-dev build-essential htop hub libffi-dev libffi7 libffi6 xz-utils"
DEB_BACKPORTS_DEPS=""
DEB_BACKPORTS_REPO="buster"
DEB_TESTING_DEPS="neovim"
OSX_DEPS="ctags wget neovim tmux zsh vim git hub readline xz"
GO_VERSION=1.15.3
ARCH=amd64
PY3_VERSION=3.8.5
PY2_VERSION=2.7.18
NODE_VERSION=14.15.0
FLUTTER_VERSION=1.22.3
NEOVIM_PYENV_PACKAGES="pip pynvim flake8 pylint"
NEOVIM_UNINSTALL_PYENV_PACKAGES="pynvim neovim"
GLOBAL_PYENV_PACKAGES="pip glances"
CFLAGS='-O2'
TFENV_VERSIONS="0.11.10 latest"

# backup dotfiles
backup_dotfiles() {
  echo ""
  echo "backing up existing dotfiles. . . ."

  bdir=$(date +%Y-%m-%d_%H:%M)
  mkdir -p ~/dotfiles-backup/${bdir}/

  for file in $(echo ${DOT_FILES});do
    if [[ -e ~/.${file} ]]; then
      mv ~/.${file} ~/dotfiles-backup/${bdir}/.${file}
    fi
  done
}

upstall_repo() {
 test -d $2 && {
   echo "Updating ${2} . . ."
   pushd $2
   git checkout master
   git pull
   popd
 } || {
   echo "Installing $1 to $2 . . ."
   git clone $1 $2
 }
}

install_pyenv() {
  upstall_repo https://github.com/pyenv/pyenv.git ~/.pyenv
  upstall_repo https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv

  PYENV_ROOT="${HOME}/.pyenv"
  PATH=${PYENV_ROOT}/bin:${PATH}
  eval "$(pyenv init -)"

  pyenv versions |grep ${PY3_VERSION} || pyenv install ${PY3_VERSION}
  pyenv versions |grep ${PY2_VERSION} || pyenv install ${PY2_VERSION}
  pyenv versions |grep 3global || pyenv virtualenv ${PY3_VERSION} 3global
  pyenv versions |grep 2global || pyenv virtualenv ${PY2_VERSION} 2global
  pyenv global 3global
  pyenv versions |grep neovim3 || pyenv virtualenv ${PY3_VERSION} neovim3
  pyenv versions |grep neovim || pyenv virtualenv ${PY2_VERSION} neovim

  for package in $(echo $GLOBAL_PYENV_PACKAGES);do
    export PYENV_VERSION='3global'
    pip list |grep ${package} || pip install ${package}
    pip list --outdated |grep ${package} && pip install ${package} -U
    export PYENV_VERSION='2global'
    pip list |grep ${package} || pip install ${package}
    pip list --outdated |grep ${package} && pip install ${package} -U
  done

  for package in $(echo $NEOVIM_PYENV_PACKAGES);do
    export PYENV_VERSION='neovim3'
    pip list |grep ${package} || pip install ${package}
    pip list --outdated |grep ${package} && pip install ${package} -U
    export PYENV_VERSION='neovim'
    pip list |grep ${package} || pip install ${package}
    pip list --outdated |grep ${package} && pip install ${package} -U
  done

  unset PYENV_VERSION

}

install_rbenv() {
  upstall_repo https://github.com/rbenv/rbenv.git ~/.rbenv
  upstall_repo https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
}

install_nodenv() {
  upstall_repo https://github.com/nodenv/nodenv.git ~/.nodenv
  upstall_repo https://github.com/nodenv/node-build.git ~/.nodenv/plugins/node-build
  upstall_repo https://github.com/nodenv/node-build-update-defs.git ~/.nodenv/plugins/node-build-update-defs

  NODENV_ROOT="${HOME}/.nodenv"
  PATH="${NODENV_ROOT}/bin:${PATH}"
  eval "$(nodenv init -)"

  nodenv versions |grep ${NODE_VERSION} || nodenv install ${NODE_VERSION}
  nodenv global ${NODE_VERSION}
  npm install -g tern
}

install_tfenv() {
  upstall_repo https://github.com/tfutils/tfenv.git ~/.tfenv

  TFENV_ROOT="${HOME}/.tfenv"
  PATH="${TFENV_ROOT}/bin:${PATH}"

  tfenv use latest
  for v in $(echo ${TFENV_VERSIONS});do
    tfenv list |grep ${v} || tfenv install ${v}
  done
}

install_golang() {
  GOROOT="${home}/go"

  if [ -d ${GOROOT} ]; then
    if [ "$(${GOROOT}/bin/go version |cut -f3 -d' ')" != "go${GO_VERSION}" ]; then
      rm -rf ${HOME}/go
    else
      return
    fi
  fi

  curl https://storage.googleapis.com/golang/go${GO_VERSION}.${OS}-${ARCH}.tar.gz \
    | tar -C ${HOME} -xz
}

install_flutter() {
  export FLUTTER_PATH=${HOME}/.flutter.d

  if [ -d ${FLUTTER_PATH} ]; then
    if [ "$(${FLUTTER_PATH}/bin/flutter --version |grep Flutter |cut -f2 -d' ')" != "${FLUTTER_VERSION}" ]; then
      rm -rf ${HOME}/flutter
      rm -rf ${FLUTTER_PATH}
    else
      return
    fi
  fi

  curl https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz |tar x -J -C ${HOME}
}

install_deps() {
  echo ""
  echo "installing deps. . . ."

  if [[ "${OS}" == "darwin" ]];then
    xcode-select --install
    # sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /
    which brew
    if [ "$?" -gt 0 ]; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    else
      brew update
    fi
    brew install ${OSX_DEPS}
    brew upgrade ${OSX_DEPS}
  elif [[ "${OS}" == "linux" ]];then
    source /etc/*-release
    if [[ "${ID}" == "debian" ]];then
      sudo apt-get install ${DEB_DEPS}
      sudo apt-get -t ${DEB_BACKPORTS_REPO}-backports install ${DEB_BACKPORTS_DEPS}
      sudo apt-get -t testing install ${DEB_TESTING_DEPS}
    fi
  fi

  install_golang
  install_pyenv
  install_rbenv
  install_nodenv
  install_tfenv
  install_flutter
}

make_dirs() {
  echo ""
  echo "creating directories. . . ."

  for dir in {.ssh/keys,.tmux,.zsh,.vim/autoload,.local/share/nvim,.config/nvim}; do
    echo creating directory ~/${dir}
    mkdir -p ~/${dir}
  done

  chmod 700 ~/.ssh
}

install_configs() {
  echo ""
  echo "installing configurations. . . ."

  for file in $(echo ${DOT_FILES});do
    if [[ -f ${file} ]];then
      cp ${file} ~/.${file}
    elif [[ -d ${file} ]];then
      for sub_file in $(ls -1 ${file});do
        cp -r ${file}/${sub_file} ~/.${file}/${sub_file}
      done
    fi
  done

  ln -s ~/.vimrc ~/.config/nvim/init.vim
  ln -s ~/.vim ~/.local/share/nvim/site
}

install_vim_plugins() {
  echo ""
  echo "installing vim plugins. . . ."

  curl -fLo ~/.vim/autoload/plug.vim \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  PYENV_ROOT="${HOME}/.pyenv"
  PATH=${PYENV_ROOT}/bin:${PATH}
  eval "$(pyenv init -)"

  NODENV_ROOT="${HOME}/.nodenv"
  PATH=${NODENV_ROOT}/bin:${PATH}
  eval "$(nodenv init -)"

  export GOROOT=${HOME}/go
  export GOPATH=${HOME}/go-workspace
  mkdir -p ${GOPATH}
  export PATH=${PATH}:${GOPATH}/bin:${GOROOT}/bin
  
  nvim \
    +PlugInstall \
    +qall
  nvim \
    +PlugUpgrade \
    +qall
  nvim \
    +PlugUpdate \
    +qall
  nvim \
    +GoInstallBinaries \
    +qall
  nvim \
    +GoUpdateBinaries \
    +qall
  nvim \
    +'CocInstall -sync coc-flutter-tools' \
    +qall
  nvim \
    +'CocInstall -sync coc-python coc-snippets coc-go' \
    +qall
}

install() {
  # echo "  ++  NOTICE  ++"
  # echo "Please install ctags, and go.  Also be sure to run :GoInstallBinaries in vim on first run, or some functionality will be missing."
  # echo "Press [Enter] to continue..."
  # read

  # install_dependencies
  install_deps

  # backup existing dotfiles
  backup_dotfiles

  # remove conflicting dotfiles
  purge_all

  # make directories
  make_dirs

  # install configs
  install_configs

  # install vim plugins
  install_vim_plugins
}

purge_all() {
  echo "  ++  NOTICE  ++"
  echo "This will potentially remove all dotfiles checked into this repository from your home dir."
  echo "Press [Enter] to continue..."
  read
  for file in $(echo ${DOT_FILES});do
    if [[ -e ~/.${file} ]] || [[ -h ~/.${file} ]]; then
      rm -rf ~/.${file}
    fi
  done
  rm -rf ~/.local/share/nvim/site
  rm -rf ~/.config/nvim
}

#parameter handling here
case "$1" in
  install)
    install
    ;;
  plugins)
    install_vim_plugins
    ;;
  purge)
    ;;
  install_deps)
    install_deps
    ;;
  config)
    install_configs
    ;;
  *)
    echo "Usage: $0 {install|purge}"
    exit 1
    ;;
esac
