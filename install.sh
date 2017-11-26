#!/bin/bash
# install for jaybocc2@'s dotfiles
DOT_FILES=$(git ls-tree @{u}|awk '{print $4}' |egrep -v '(/|LICENSE|README|install.sh)')
OS=$(uname |tr '[:upper:]' '[:lower:]')
DEB_DEPS="exuberant-ctags wget neovim tmux zsh vim git xclip zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncurses5-dev libssl-dev build-essential"
OSX_DEPS="ctags wget neovim tmux zsh vim git hub"
GO_VERSION=1.8.3
ARCH=amd64
PY3_VERSION=3.6.2
PY2_VERSION=2.7.13
NODE_VERSION=6.11.2
PYENV_PACKAGES="neovim flake8 pylint"

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

  for package in $(echo $PYENV_PACKAGES);do
    PYENV_VERSION='neovim3' pip install ${package}
    PYENV_VERSION='neovim' pip install ${package}
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

  NODENV_ROOT="${HOME}/.nodenv"
  PATH=${NODENV_ROOT}/bin:${PATH}
  eval "$(nodenv init -)"

  nodenv install ${NODE_VERSION}
  nodenv global ${NODE_VERSION}
  npm install -g tern
}

install_golang() {
  wget -O /tmp/go${GO_VERSION}.${OS}-${ARCH}.tar.gz https://storage.googleapis.com/golang/go${GO_VERSION}.${OS}-${ARCH}.tar.gz
  tar -C ${HOME} -xzf /tmp/go${GO_VERSION}.${OS}-${ARCH}.tar.gz
}

install_deps() {
  echo ""
  echo "installing deps. . . ."

  if [[ "${OS}" == "darwin" ]];then
    xcode-select --install
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install macvim --with-cscope --with-lua --HEAD --override-system-vim
    brew install ${OSX_DEPS}
  elif [[ "${OS}" == "linux" ]];then
    source /etc/*-release
    if [[ "${ID}" == "debian" ]];then
      sudo apt-get install ${DEB_DEPS}
    fi
  fi

  install_golang
  install_pyenv
  install_rbenv
  install_nodenv
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
  export PATH=${PATH}:${GOPATH}/bin:${GOROOT}/bin
  
  nvim +GoInstallBinaries +qall
  nvim +PlugInstall +qall
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
    purge_all
    ;;
  *)
    echo "Usage: $0 {install|purge}"
    exit 1
    ;;
esac
