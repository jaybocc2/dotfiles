#!/bin/zsh
# install for jaybocc2@'s dotfiles
files=$(git ls-tree master |awk '{print $4}' |egrep -v '(/|LICENSE|README|install.sh)')

install() {
  echo "  ++  NOTICE  ++"
  echo "Please install ctags, and go.  Also be sure to run :GoInstallBinaries in vim on first run, or some functionality will be missing."
  echo "Press [Enter] to continue..."
  read
  git submodule update --init --recursive
  git submodule sync --recursive
  bdir=$(date +%Y-%m-%d_%H:%M)
  mkdir -p ~/dotfiles-backup/${bdir}/
  for file in $(echo $files);do
    if [[ -e ~/.${file} ]]; then
      mv ~/.${file} ~/dotfiles-backup/${bdir}/.${file}
    fi
    rm -rf ~/.${file}
    ln -s $(pwd)/${file} ~/.${file}
  done
  pushd vim/bundle/YouCompleteMe/
  git submodule update --init --recursive
  git submodule sync --recursive
  # /usr/bin/python install.py --gocode-completer --tern-completer
  PYENV_VERSION=2.7.10 python install.py --gocode-completer --tern-completer
  popd
}

purge-all() {
  echo "  ++  NOTICE  ++"
  echo "This will potentially remove all dotfiles checked into this repository from your home dir."
  echo "Press [Enter] to continue..."
  read
  for file in $(echo $files);do
    if [[ -e ~/.${file} ]] || [[ -h ~/.${file} ]]; then
      rm -rf ~/.${file}
    fi
  done
}

#parameter handling here
case "$1" in
  install)
    install
    ;;
  purge-all)
    purge-all
    ;;
  *)
    echo "Usage: $0 {install|purge-all}"
    exit 1
    ;;
esac
