#!/bin/zsh
# install for jaybocc2@'s dotfiles

for file in $(git ls-files |egrep -v '(/|LICENSE|README|install.sh)');do
  mv ~/.${file} ~/.${file}.old
  ln -s ${file} ~/.${file}
done
