#!/bin/zsh
# install for jaybocc2@'s dotfiles

install() {
  for file in $(git ls-files |egrep -v '(/|LICENSE|README|install.sh)');do
    if [[ -e ~/.${file} ]]; then
      mv ~/.${file} ~/.${file}.old
    fi
    ln -s ./${file} ~/.${file}
  done
}

purge-all() {
  for file in $(git ls-files |egrep -v '(/|LICENSE|README|install.sh)');do
    if [[ -e ~/.${file} ]]; then
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
