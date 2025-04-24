#!/usr/bin/env bash

source shlibs/os.sh      # OS && ARCH
source shlibs/logging.sh # ERROR
source shlibs/common.sh  # mktmp and rmtmp

install_fonts() {
  local version="v3.3.0"
  mktmp

  local fontdir=~/.fonts
  if [[ ${OS} == "darwin" ]]; then
    local fontdir=~/Library/Fonts
  fi

  mkdir -p ${fontdir}
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/${version}/Hasklig.zip
  unzip -o Hasklig.zip -d ${fontdir}

  rmtmp
}
