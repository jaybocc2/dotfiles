#!/usr/bin/env bash

# install for jaybocc2@'s dotfiles
source shlibs/os.sh      # OS && ARCH
source shlibs/logging.sh # ERROR
source shlibs/common.sh  # mktmp and rmtmp

# Check for upstream branch, but don't exit if it fails (first install might not have it)
UPSTREAM=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || echo "master")

DOT_FILES=$(git ls-tree "${UPSTREAM}" 2>/dev/null | awk '{print $4}' | grep -Ev '(/|LICENSE|README|install.sh|shlibs|test.sh|.gitignore|.gitmodules|bashrc|^vim|vimrc|screenrc)')
if [[ -z "${DOT_FILES}" ]]; then
  # Fallback if git is missing or upstream fails
  DOT_FILES="gitconfig gitignore_global tmux.conf zlogin zshrc"
fi
DEB_DEPS="zip unzip curl exuberant-ctags wget tmux zsh zsh-common vim git xclip zlib1g zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
libncurses5-dev libssl-dev build-essential htop libffi-dev libffi7 xz-utils"
# DEB_BACKPORTS_DEPS=""
# DEB_BACKPORTS_REPO=""
# DEB_TESTING_DEPS=""
OSX_DEPS="ctags wget tmux zsh vim git gh readline xz htop grep fzf colima docker yq jq libpq pre-commit direnv"
GO_VERSION=1.18.4
PY3_VERSION=3.13.7
RUBY_VERSION=3.1.2   # update in nvim/lua/options.lua
NODE_VERSION=22.17.1 # update in nvim/lua/options.lua
FLUTTER_VERSION=2.0.2
FLUTTER_CHANNEL=stable
GHCLI_VERSION=2.92.0
NEOVIM_VERSION=v0.11.4
NEOVIM_PYENV_PACKAGES="pip pynvim flake8 pylint"
GLOBAL_PYENV_PACKAGES="pip"
TFENV_VERSIONS="latest"

source shlibs/lsp-deps.sh # source install methods for all LSP's
source shlibs/fonts.sh    # source install fonts methods

install_goenv() {
  upstall_repo https://github.com/syndbg/goenv ~/.goenv master

  fixenv
}

install_pyenv() {
  upstall_repo https://github.com/pyenv/pyenv.git ~/.pyenv master
  upstall_repo https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv master

  fixenv

  pyenv versions | grep ${PY3_VERSION} || pyenv install ${PY3_VERSION}
  pyenv versions | grep ${PY3_VERSION}/envs/3global || pyenv virtualenv-delete -f 3global
  pyenv versions | grep 3global || pyenv virtualenv ${PY3_VERSION} 3global
  pyenv global 3global # set 3global to global python version
  pyenv versions | grep ${PY3_VERSION}/envs/neovim || pyenv virtualenv-delete -f neovim
  pyenv versions | grep neovim || pyenv virtualenv ${PY3_VERSION} neovim

  for package in ${GLOBAL_PYENV_PACKAGES}; do
    export PYENV_VERSION='3global'
    pyenv exec pip list | grep "${package}" || pyenv exec pip install "${package}"
    pyenv exec pip list --outdated | grep "${package}" && pyenv exec pip install "${package}" -U
  done

  for package in ${NEOVIM_PYENV_PACKAGES}; do
    export PYENV_VERSION='neovim'
    pyenv exec pip list | grep "${package}" || pyenv exec pip install "${package}"
    pyenv exec pip list --outdated | grep "${package}" && pyenv exec pip install "${package}" -U
  done

  unset PYENV_VERSION
}

install_rbenv() {
  upstall_repo https://github.com/rbenv/rbenv.git ~/.rbenv master
  upstall_repo https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build master

  fixenv

  rbenv versions | grep ${RUBY_VERSION} || rbenv install ${RUBY_VERSION}
  rbenv global ${RUBY_VERSION}
  gem install neovim
}

install_nodenv() {
  upstall_repo https://github.com/nodenv/nodenv.git ~/.nodenv master
  upstall_repo https://github.com/nodenv/node-build.git ~/.nodenv/plugins/node-build master
  upstall_repo https://github.com/nodenv/node-build-update-defs.git ~/.nodenv/plugins/node-build-update-defs master

  fixenv

  nodenv versions | grep ${NODE_VERSION} || nodenv install ${NODE_VERSION}
  nodenv global ${NODE_VERSION}
  npm install -g neovim
  # npm install -g tern # not sure what this is for
}

install_tfenv() {
  upstall_repo https://github.com/tfutils/tfenv.git ~/.tfenv master

  fixenv

  tfenv use latest
  for v in ${TFENV_VERSIONS}; do
    tfenv list | grep "${v}" || tfenv install "${v}"
  done
}

install_rust() {
  if command -v rustup >/dev/null; then
    echo "Updating Rust..."
    rustup update
  else
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile default -y
  fi
  fixenv
}

install_antigravity() {
  if command -v agy >/dev/null; then
    echo "antigravity-cli already installed, skipping..."
    return
  fi
  curl -fsSL https://antigravity.google/cli/install.sh | bash
}

install_flutter() {
  export FLUTTER_PATH=${HOME}/.flutter.d

  if [ -d "${FLUTTER_PATH}" ]; then
    flutter upgrade --verify-only
    if ! flutter upgrade --verify-only; then
      flutter channel ${FLUTTER_CHANNEL}
      flutter upgrade
    else
      return
    fi
  fi

  if [ "${OS}" == 'darwin' ]; then
    FL_OS='macos'
  else
    FL_OS='linux'
  fi

  flutter_url="https://storage.googleapis.com/flutter_infra/releases/${FLUTTER_CHANNEL}/${FL_OS}/flutter_${FL_OS}_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz"
  curl ${flutter_url} | tar x -J -C "${HOME}"
}

install_ghcli() {
  if [[ "${OS}" == "darwin" ]]; then
    return
  fi

  if ! command -v dpkg >/dev/null; then
    echo "Skipping gh cli install: dpkg not found (only Debian/Ubuntu supported for now)"
    return
  fi

  mktmp
  curl -LO "https://github.com/cli/cli/releases/download/v${GHCLI_VERSION}/gh_${GHCLI_VERSION}_linux_$(ARCH).deb" || TRACE "ghcli deb download failed"
  sudo dpkg -i "gh_${GHCLI_VERSION}_linux_$(ARCH).deb" || TRACE "ghcli deb install failed"
  rmtmp
}

install_cargo_bin() {
  local bin="${1}"
  local crate="${2:-${1}}"
  if command -v "${bin}" >/dev/null; then
    echo "${bin} already installed, skipping..."
  else
    echo "Installing ${crate} via cargo..."
    cargo install "${crate}"
  fi
}

install_fdfind() {
  install_cargo_bin fd fd-find
}

install_ripgrep() {
  install_cargo_bin rg ripgrep
}

install_ast_grep() {
  install_cargo_bin sg ast-grep
}

install_uv() {
  if command -v uv >/dev/null; then
    echo "uv already installed, skipping..."
  else
    cargo install --git https://github.com/astral-sh/uv uv
  fi
}

compile_neovim() {
  mktmp

  # install nvim build deps
  sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen git build-essential
  upstall_repo https://github.com/neovim/neovim.git neovim ${NEOVIM_VERSION}
  pushd neovim || TRACE "failed to pushd neovim"
  make CMAKE_BUILD_TYPE=RelWithDebInfo
  sudo make install

  popd || TRACE "failed to popd"
  rmtmp
}

install_neovim() {
  install_fdfind
  install_ripgrep
  install_lsp_binaries
  install_ast_grep
  install_uv

  if [[ "${OS}" == "darwin" ]]; then
    if which -a nvim | grep -v aliased >/dev/null; then
      brew upgrade neovim
    else
      # install development version to support plugins
      brew install neovim --HEAD
    fi
  else
    if [ "$(nvim -v | head -n 1)" != "NVIM ${NEOVIM_VERSION}" ]; then
      compile_neovim
    fi
  fi
}

install_zsh() {
  # install oh-my-zsh
  if [[ "${OS}" == "darwin" ]]; then
    # prefer homebrew zsh
    if [[ -x "/opt/homebrew/bin/zsh" ]]; then
      ZSH_PATH="/opt/homebrew/bin/zsh"
    elif [[ -x "/usr/local/bin/zsh" ]]; then
      ZSH_PATH="/usr/local/bin/zsh"
    else
      ZSH_PATH=$(which zsh)
    fi
  else
    ZSH_PATH=$(which zsh)
  fi

  if [[ -z "$ZSH_PATH" ]]; then
    ERROR "zsh not found"
    return 1
  fi

  if ! grep -q "$ZSH_PATH" /etc/shells; then
    echo "Adding $ZSH_PATH to /etc/shells"
    echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
  fi

  CURRENT_SHELL=""
  if [[ "${OS}" == "darwin" ]]; then
    CURRENT_SHELL=$(dscl . -read "/Users/$USER" UserShell 2>/dev/null | awk '{print $2}')
  else
    CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7 2>/dev/null || grep "^$USER:" /etc/passwd | cut -d: -f7)
  fi

  if [[ "$CURRENT_SHELL" != "$ZSH_PATH" ]]; then
    echo "Changing shell to $ZSH_PATH"
    chsh -s "$ZSH_PATH" "$USER"
  fi

  if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "oh-my-zsh already installed, skipping..."
  else
    export KEEP_ZSHRC="yes"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi
}

install_deps() {
  echo ""
  echo "installing deps. . . ."

  if [[ "${OS}" == "darwin" ]]; then
    # Check if Xcode Command Line Tools are installed
    if ! xcode-select -p >/dev/null 2>&1; then
      echo "Installing Xcode Command Line Tools..."
      xcode-select --install
      echo "Please complete the installation and run this script again."
      exit 0
    fi

    if ! which brew >/dev/null; then
      echo "Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    else
      echo "Updating Homebrew..."
      brew update
    fi

    if [[ -x "/opt/homebrew/bin/brew" ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x "/usr/local/bin/brew" ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi

    echo "Installing Homebrew dependencies..."
    brew install ${OSX_DEPS}

    if [[ "X${UPGRADE}" == "Xupgrade" ]]; then
      echo "Upgrading Homebrew dependencies..."
      brew upgrade ${OSX_DEPS}
    fi
  elif [[ "${OS}" == "linux" ]]; then
    if [ "${ID}" == "ubuntu" ] || [ "${ID}" == "debian" ] || [ "${ID}" == "raspbian" ] || [ "${ID}" == "armbian" ]; then
      for PKG in ${DEB_DEPS}; do
        sudo apt-get -t "${VERSION_CODENAME}" install "${PKG}" -f -y
      done
    fi
  fi

  install_zsh
  install_ghcli
  install_rust
  install_nodenv
  install_pyenv
  install_rbenv
  install_tfenv
  install_goenv
  install_antigravity
  # install_flutter # disable until i ever want to use flutter again

  install_neovim
}

make_dirs() {
  echo ""
  echo "creating directories. . . ."

  for dir in {.ssh/keys,.config}; do
    echo creating directory "${HOME}/${dir}"
    mkdir -p "${HOME}/${dir}"
  done

  chmod 700 ~/.ssh
}

safe_link() {
  local src="$1"
  local dst="$2"

  if [[ -L "${dst}" ]]; then
    local current_src
    current_src=$(readlink "${dst}")
    if [[ "${current_src}" == "${src}" ]]; then
      return
    fi
    echo "Updating link: ${dst} -> ${src} (was ${current_src})"
    rm "${dst}"
  elif [[ -e "${dst}" ]]; then
    if [[ "X${FAST}" == "Xfast" ]]; then
      echo "Warning: ${dst} exists and is not a symlink. Skipping in fast mode."
      return
    fi

    echo -n "File ${dst} already exists and is not a symlink. [B]ackup, [O]verwrite, [S]kip? (B/o/s) "
    local action
    read -n 1 -r action
    echo
    case "${action}" in
      [Bb]* | "")
        local bak="${dst}.bak.$(date +%Y%m%d%H%M%S)"
        echo "Backing up ${dst} to ${bak}"
        mv "${dst}" "${bak}"
        ;;
      [Oo]*)
        echo "Overwriting ${dst}"
        rm -rf "${dst}"
        ;;
      *)
        echo "Skipping ${dst}"
        return
        ;;
    esac
  fi

  echo "Linking ${dst} -> ${src}"
  ln -s "${src}" "${dst}"
}

install_configs() {
  # make directories
  make_dirs

  echo ""
  echo "installing configurations. . . ."

  for file in ${DOT_FILES}; do
    local src="$(pwd)/${file}"
    if [ -f "${file}" ]; then
      safe_link "${src}" "${HOME}/.${file}"
    elif [ -d "${file}" ]; then
      local prefix='.'
      if [[ "${file}" == "bin" ]]; then
        prefix=''
      fi

      local dst="${HOME}/${prefix}${file}"
      safe_link "${src}" "${dst}"

      if [ "${file}" == "nvim" ]; then
        safe_link "${src}" "${HOME}/.config/nvim"
      fi
    fi
  done
}

install() {
  install_deps
  install_configs
  install_fonts
}

purge_dotfiles() {
  echo "  ++  NOTICE  ++"
  echo "This will remove all matching dotfiles checked into this repository from your home dir."
  if [[ "X${FAST}" != "Xfast" ]]; then
    echo "Press [Enter] to continue..."
    read
  fi

  echo -e "\nlooking for  $(echo "${DOT_FILES}" | wc -w) dotfiles to uninstall ..."
  for file in ${DOT_FILES}; do
    rmlink "${HOME}/.${file}"
    if [ "${file}" == "nvim" ]; then
      rmlink ~/.config/nvim
    fi
  done

  if [[ "X${CLEAN}" == "Xclean" ]]; then
    echo -e "\ncleaning nvim"
    rm -rf ~/.local/share/nvim/site
  fi
}

purge_shada() {
  # https://github.com/neovim/neovim/issues/6875
  local shada_path=~/.local/state/nvim/shada
  echo "purging ${shada_path} to fix shada errors"
  rm -rf "${shada_path}"
}

#parameter handling here
case "$1" in
  fast-install)
    export FAST="fast"
    install
    ;;
  fast-clean-install)
    export CLEAN="clean"
    export FAST="fast"
    install
    ;;
  clean-install)
    export CLEAN="clean"
    install
    ;;
  install)
    install
    ;;
  upgrade-install)
    export UPGRADE="upgrade"
    install
    ;;
  purge)
    purge_dotfiles
    ;;
  install-deps)
    install_deps
    install_fonts
    ;;
  upgrade-deps)
    export UPGRADE="upgrade"
    install_deps
    install_fonts
    ;;
  install-neovim)
    install_neovim
    ;;
  installx)
    if echo "${2}" | grep -q -E '(ghcli)'; then
      eval "install_${2}"
    fi
    ;;
  fast-config)
    export FAST="fast"
    # install configs
    install_configs
    ;;
  fast-clean-config)
    export CLEAN="clean"
    export FAST="fast"
    # install configs
    install_configs
    ;;
  clean-config)
    export CLEAN="clean"
    # install configs
    install_configs
    ;;
  config)
    # install configs
    install_configs
    ;;
  purge-shada)
    purge_shada
    ;;
  *)
    echo "Usage: $0 {install|upgrade-install|fast-install|fast-clean-install|clean-install|config|fast-config|fast-clean-config|clean-config|purge|install-deps|upgrade-deps}"
    exit 1
    ;;
esac
