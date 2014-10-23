#!/bin/zsh
# install for jaybocc2@'s dotfiles
files=$(git ls-tree master |awk '{print $4}' |egrep -v '(/|LICENSE|README|install.sh|vim-colors-solarized)')

install() {
  mkdir -p ~/.old_shell_files
  for file in $(echo $files);do
    if [[ -e ~/.${file} ]]; then
      mv ~/.${file} ~/.old_shell_files/.${file}.old
    fi
    ln -s $(pwd)/${file} ~/.${file}
  done
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
