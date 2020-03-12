#!/bin/bash
# install for jaybocc2@'s dotfiles
DOT_FILES=$(git ls-tree @{u}|awk '{print $4}' |egrep -v '(/|LICENSE|README|install.sh)')
OS=$(uname |tr '[:upper:]' '[:lower:]')
DEB_DEPS="exuberant-ctags wget tmux zsh vim git xclip zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncurses5-dev libssl-dev build-essential htop"
DEB_BACKPORTS_DEPS=""
DEB_TESTING_DEPS="neovim"
OSX_DEPS="ctags wget neovim tmux zsh vim git hub readline xz"
GO_VERSION=1.12.7
ARCH=amd64
PY3_VERSION=3.6.2
PY2_VERSION=2.7.13
NODE_VERSION=10.16.2
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

update_repo() {
 pushd $1
 git checkout master
 git pull
 popd
}

install_pyenv() {
  git clone https://github.com/pyenv/pyenv.git ~/.pyenv \
    || update_repo ~/.pyenv
  git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv \
    || update_repo ~/.pyenv/plugins/pyenv-virtualenv

  PYENV_ROOT="${HOME}/.pyenv"
  PATH=${PYENV_ROOT}/bin:${PATH}
  eval "$(pyenv init -)"
  pyenv install ${PY3_VERSION}
  pyenv install ${PY2_VERSION}
  pyenv virtualenv ${PY3_VERSION} 3global
  pyenv virtualenv ${PY2_VERSION} 2global
  pyenv global 2global
  pyenv virtualenv ${PY3_VERSION} neovim3
  pyenv virtualenv ${PY2_VERSION} neovim

  for package in $(echo $NEOVIM_UNINSTALL_PYENV_PACKAGES);do
    PYENV_VERSION='neovim3' pip3 uninstall ${package}
    PYENV_VERSION='neovim' pip uninstall ${package}
  done

  for package in $(echo $GLOBAL_PYENV_PACKAGES);do
    PYENV_VERSION='3global' pip3 install ${package} -U
    PYENV_VERSION='2global' pip install ${package} -U
  done

  for package in $(echo $NEOVIM_PYENV_PACKAGES);do
    PYENV_VERSION='neovim3' pip3 install ${package} -U
    PYENV_VERSION='neovim' pip install ${package} -U
  done
}

install_rbenv() {
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv \
    || update_repo ~/.rbenv
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build \
    || update_repo ~/.rbenv/plugins/ruby-build
}

install_nodenv() {
  git clone https://github.com/nodenv/nodenv.git ~/.nodenv \
    || update_repo ~/.nodenv
  git clone https://github.com/nodenv/node-build.git ~/.nodenv/plugins/node-build \
    || update_repo ~/.nodenv/plugins/node-build
  git clone https://github.com/nodenv/node-build-update-defs.git ~/.nodenv/plugins/node-build-update-defs \
    || update_repo ~/.nodenv/plugins/node-build-update-defs

  NODENV_ROOT="${HOME}/.nodenv"
  PATH="${NODENV_ROOT}/bin:${PATH}"
  eval "$(nodenv init -)"

  nodenv install ${NODE_VERSION}
  nodenv global ${NODE_VERSION}
  npm install -g tern
}

install_tfenv() {
  git clone https://github.com/tfutils/tfenv.git ~/.tfenv \
    || update_rrepo ~/.tfenv

  TFENV_ROOT="${HOME}/.tfenv"
  PATH="${TFENV_ROOT}/bin:${PATH}"

  for v in $(echo ${TFENV_VERSIONS});do
    tfenv install ${v}
  done
}

install_golang() {
  if [ $(command -v go -a $(go version |egrep -o 'go\d+\.\d+\.\d+') != "go${GO_VERSION}" ) ]; then
    rm -rf ${HOME}/go
  elif [ $(command -v go -a $(go version |egrep -o 'go\d+\.\d+\.\d+') == "go${GO_VERSION}" )]; then
    return
  fi

  wget -O /tmp/go${GO_VERSION}.${OS}-${ARCH}.tar.gz https://storage.googleapis.com/golang/go${GO_VERSION}.${OS}-${ARCH}.tar.gz
  tar -C ${HOME} -xzf /tmp/go${GO_VERSION}.${OS}-${ARCH}.tar.gz
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
      sudo apt-get -t stretch-backports install ${DEB_BACKPORTS_DEPS}
      sudo apt-get -t testing install ${DEB_BACKPORTS_DEPS}
    fi
  fi

  install_golang
  install_pyenv
  install_rbenv
  install_nodenv
  install_tfenv
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
  
  nvim +PlugInstall +qall
  nvim +PlugUpgrade +qall
  nvim +PlugUpdate +qall
  nvim +GoInstallBinaries +qall
  nvim +GoUpdateBinaries +qall
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
  purge)
    ;;
  install_deps)
    install_deps
    ;;
  *)
    echo "Usage: $0 {install|purge}"
    exit 1
    ;;
esac
