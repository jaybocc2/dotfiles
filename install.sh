#!/bin/zsh
# install for jaybocc2@'s dotfiles
files=$(git ls-tree master |awk '{print $4}' |egrep -v '(/|LICENSE|README|install.sh)')

install() {
  echo "  ++  NOTICE  ++"
  echo "Please install ctags, and go.  Also be sure to run :GoInstallBinaries in vim on first run, or some functionality will be missing."
  echo "[Enter]"
  read
  git submodule update --init --recursive
  git submodule sync --recursive
  bdir=$(date +%Y-%m-%d_%H:%M)
  mkdir -p ~/dotfiles-backup/${bdir}/
  for file in $(echo $files);do
    if [[ -e ~/.${file} ]]; then
      mv ~/.${file} ~/dotfiles-backup/${bdir}/.${file}
    fi
    ln -s $(pwd)/${file} ~/.${file}
  done
  pushd vim/bundle/YouCompleteMe/
  ./install.sh --gocode-completer
  popd
}

purge-all() {
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
