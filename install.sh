#!/bin/bash
# install for jaybocc2@'s dotfiles
source shlibs/os.sh # OS && ARCH
source shlibs/logging.sh # ERROR
source shlibs/common.sh # mktmp and rmtmp

git rev-parse --abbrev-ref --symbolic-full-name @{u} || {
  echo "Missing upstream branch -- config install will fail"
  exit 1
}

DOT_FILES=$(git ls-tree @{u}|awk '{print $4}' |egrep -v '(/|LICENSE|README|install.sh|shlibs|test.sh|.gitignore|.gitmodules|bashrc|^vim|vimrc|screenrc)')
# OS=$(uname |tr '[:upper:]' '[:lower:]') # comes from utils.sh now
DEB_DEPS="curl exuberant-ctags wget tmux zsh zsh-common vim git xclip zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
libncurses5-dev libssl-dev build-essential htop libffi-dev libffi7 xz-utils"
DEB_BACKPORTS_DEPS=""
DEB_BACKPORTS_REPO=""
DEB_TESTING_DEPS=""
OSX_DEPS="ctags wget tmux zsh vim git gh readline xz htop"
GO_VERSION=1.18.4
PY3_VERSION=3.11.0
RUBY_VERSION=3.1.2 # update in nvim/lua/options.lua
NODE_VERSION=18.12.1 # update in nvim/lua/options.lua
NEOVIM_VERSION="v0.8.1"
FLUTTER_VERSION=2.0.2
FLUTTER_CHANNEL=stable
GHCLI_VERSION=2.20.2
NEOVIM_VERSION=v0.8.1
NEOVIM_PYENV_PACKAGES="pip pynvim flake8 pylint"
GLOBAL_PYENV_PACKAGES="pip"
CFLAGS='-O2' # what is this used for
TFENV_VERSIONS="latest"

source shlibs/lsp-deps.sh # install all LSP's
source shlibs/fonts.sh # install fonts

install_pyenv() {
  upstall_repo https://github.com/pyenv/pyenv.git ~/.pyenv master
  upstall_repo https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv master

  # PYENV_ROOT="${HOME}/.pyenv"
  # PATH=${PYENV_ROOT}/bin:${PATH}
  # eval "$(pyenv init --path)"
  # eval "$(pyenv init -)"
  # eval "$(pyenv virtualenv-init -)"
  fixenv


  pyenv versions |grep ${PY3_VERSION} || pyenv install ${PY3_VERSION}
  pyenv versions |grep ${PY3_VERSION}/envs/3global || pyenv virtualenv-delete -f 3global
  pyenv versions |grep 3global || pyenv virtualenv ${PY3_VERSION} 3global
  pyenv global 3global # set 3global to global python version
  pyenv versions |grep ${PY3_VERSION}/envs/neovim|| pyenv virtualenv-delete -f neovim 
  pyenv versions |grep neovim || pyenv virtualenv ${PY3_VERSION} neovim

  for package in $(echo $GLOBAL_PYENV_PACKAGES);do
    export PYENV_VERSION='3global'
    pyenv exec pip list |grep ${package} || pyenv exec pip install ${package}
    pyenv exec pip list --outdated |grep ${package} && pyenv exec pip install ${package} -U
  done

  for package in $(echo $NEOVIM_PYENV_PACKAGES);do
    export PYENV_VERSION='neovim'
    pyenv exec pip list |grep ${package} || pyenv exec pip install ${package}
    pyenv exec pip list --outdated |grep ${package} && pyenv exec pip install ${package} -U
  done

  unset PYENV_VERSION
}

install_rbenv() {
  upstall_repo https://github.com/rbenv/rbenv.git ~/.rbenv master
  upstall_repo https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build master

  fixenv

  rbenv versions |grep ${RUBY_VERSION} || rbenv install ${RUBY_VERSION}
  rbenv global ${RUBY_VERSION}
  gem install neovim
}

install_nodenv() {
  upstall_repo https://github.com/nodenv/nodenv.git ~/.nodenv master
  upstall_repo https://github.com/nodenv/node-build.git ~/.nodenv/plugins/node-build master
  upstall_repo https://github.com/nodenv/node-build-update-defs.git ~/.nodenv/plugins/node-build-update-defs master

  fixenv

  nodenv versions |grep ${NODE_VERSION} || nodenv install ${NODE_VERSION}
  nodenv global ${NODE_VERSION}
  npm install -g neovim
  # npm install -g tern # not sure what this is for
}

install_tfenv() {
  upstall_repo https://github.com/tfutils/tfenv.git ~/.tfenv master

  fixenv

  tfenv use latest
  for v in $(echo ${TFENV_VERSIONS});do
    tfenv list |grep ${v} || tfenv install ${v}
  done
}

install_golang() {
  return # go setup seem a bit broken currently
  GOROOT="${home}/go"

  if [ -d ${GOROOT} ]; then
    if [ "$(${GOROOT}/bin/go version |cut -f3 -d' ')" != "go${GO_VERSION}" ]; then
      rm -rf ${HOME}/go
    else
      return
    fi
  fi

  curl https://storage.googleapis.com/golang/go${GO_VERSION}.${OS}-$(ARCH).tar.gz \
    | tar -C ${HOME} -xz
}

install_rust() {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile default -y
  fixenv
}

install_flutter() {
  return # disable flutter for now
  export FLUTTER_PATH=${HOME}/.flutter.d

  if [ -d ${FLUTTER_PATH} ]; then
    flutter upgrade --verify-only
    if [ $? -gt 0 ]; then
      flutter channel ${FLUTTER_CHANNEL}
      flutter upgrade
    else
      return
    fi
  fi

  if [ ${OS} == 'darwin' ]; then
    FL_OS='macos'
  else
    FL_OS='linux'
  fi

  flutter_url="https://storage.googleapis.com/flutter_infra/releases/${FLUTTER_CHANNEL}/${FL_OS}/flutter_${FL_OS}_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz"
  curl ${flutter_url} |tar x -J -C ${HOME}
}

install_ghcli() {
  if [[ "${OS}" == "darwin" ]]; then
    return
  fi

  mktmp
  curl -LO "https://github.com/cli/cli/releases/download/v${GHCLI_VERSION}/gh_${GHCLI_VERSION}_linux_$(ARCH).deb" || TRACE "ghcli deb download failed"
  sudo dpkg -i gh_${GHCLI_VERSION}_linux_$(ARCH).deb || TRACE "ghcli deb install failed"
  rmtmp
}

install_fdfind() {
  # if [[ "${OS}" == "darwin" ]]; then
  #   brew install fd
  #   return
  # fi
  # # install fdfind
  # local version="v8.5.2"
  # mktmp
  # wget https://github.com/sharkdp/fd/releases/download/${version}/fd-${version}-arm-unknown-linux-musleabihf.tar.gz
  # tar xvzf fd-v8.5.2-arm-unknown-linux-musleabihf.tar.gz
  # mv fd-v8.5.2-arm-unknown-linux-musleabihf/fd ${HOME}/bin/
  # rmtmp
  cargo install fd-find
}

install_ripgrep() {
  cargo install ripgrep
}

compile_neovim() {
  mktmp

  # install nvim build deps
  sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen git build-essential
  upstall_repo https://github.com/neovim/neovim.git neovim ${NEOVIM_VERSION}
  pushd neovim
  git checkout ${NEOVIM_VERSION}
  make CMAKE_BUILD_TYPE=RelWithDebInfo
  sudo make install

  popd
  rmtmp
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
      eval "$(/opt/homebrew/bin/brew shellenv)"
    else
      brew update
    fi
    brew install ${OSX_DEPS}
    brew upgrade ${OSX_DEPS}
  elif [[ "${OS}" == "linux" ]];then
    if [[ "${ID}" == "debian" ]];then
      sudo apt-get -t ${VERSION_CODENAME} install ${DEB_DEPS}

      if [ "$(nvim -v|head -n 1)" != "NVIM ${NEOVIM_VERSION}" ]; then
        compile_neovim
      fi
    fi
  fi

  install_flutter
  install_ghcli
  install_golang
  install_nodenv
  install_pyenv
  install_rbenv
  install_rust
  install_tfenv

  install_fdfind
  install_ripgrep

  install_lsp_binaries
}

make_dirs() {
  echo ""
  echo "creating directories. . . ."

  for dir in {.ssh/keys,.config}; do
    echo creating directory ~/${dir}
    mkdir -p ~/${dir}
  done

  chmod 700 ~/.ssh
}

install_configs() {
  # remove conflicting dotfiles
  purge_dotfiles

  # make directories
  make_dirs

  echo ""
  echo "installing configurations. . . ."

  for file in $(echo ${DOT_FILES});do
    if [ -f ${file} ];then
      echo "linking ~/.${file}"
      ln -s $(pwd)/${file} ~/.${file}
    elif [ -d ${file} ];then
      prefix='.'
      if [[ ${file} = "bin" ]];then
        prefix=''
      fi
      if [ ! -d ~/${prefix}${file} ];then
        echo "linking directory ~/${prefix}${file}"
        ln -s $(pwd)/${file} ~/${prefix}${file}
        if [ "${file}" == "nvim" ]; then
          echo "linking directory ~/.config/${prefix}${file}"
          ln -s $(pwd)/${file} ~/.config/nvim
        fi
      fi
    fi
  done
}

install() {
  # echo "  ++  NOTICE  ++"
  # echo "Please install ctags, and go.  Also be sure to run :GoInstallBinaries in vim on first run, or some functionality will be missing."
  # echo "Press [Enter] to continue..."
  # read

  # install_dependencies
  install_deps

  install_fonts

  echo "cwd is $(pwd)"

  # install configs
  install_configs
}

purge_dotfiles() {
  echo "  ++  NOTICE  ++"
  echo "This will remove all matching dotfiles checked into this repository from your home dir."
  if [[ "X${FAST}" != "Xfast" ]]; then
    echo "Press [Enter] to continue..."
    read
  fi

  echo -e "\nlooking for  $(echo ${DOT_FILES}|wc -w) dotfiles to uninstall ..."
  for file in $(echo ${DOT_FILES});do
    rmlink ~/.${file}
    if [ "${file}" == "nvim" ]; then
      rmlink ~/.config/nvim
    fi
  done

  if [[ "X${CLEAN}" == "Xclean" ]]; then
    echo -e "\ncleaning nvim"
    rm -rf ~/.local/share/nvim/site
  fi
}

#parameter handling here
case "$1" in
  fast-install)
    export FAST=${FAST:="fast"}
    install
    ;;
  fast-clean-install)
    export CLEAN=${CLEAN:="clean"}
    export FAST=${FAST:="fast"}
    install
    ;;
  clean-install)
    export CLEAN=${CLEAN:="clean"}
    install
    ;;
  install)
    install
    ;;
  purge)
    purge_dotfiles
    ;;
  install-deps)
    install_deps
    install_fonts
    ;;
  fast-config)
    export FAST=${FAST:="fast"}
    # install configs
    install_configs
    ;;
  fast-clean-config)
    export CLEAN=${CLEAN:="clean"}
    export FAST=${FAST:="fast"}
    # install configs
    install_configs
    ;;
  clean-config)
    export CLEAN=${CLEAN:="clean"}
    # install configs
    install_configs
    ;;
  config)
    # install configs
    install_configs
    ;;
  *)
    echo "Usage: $0 {install|fast-install|fast-clean-install|clean-install|config|fast-config|fast-clean-config|clean-config|purge|install-deps}"
    exit 1
    ;;
esac
