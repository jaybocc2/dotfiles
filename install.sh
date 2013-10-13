#!/bin/zsh
# install for jaybocc2@'s dotfiles

for file in $(git ls-files |egrep -v '(/|LICENSE|README|install.sh)');do
  if [[ -e ~/.${file} ]]; then
    mv ~/.${file} ~/.${file}.old
  fi
  ln -s ${file} ~/.${file}
done
