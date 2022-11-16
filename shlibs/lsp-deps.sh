#!/bin/bash
source shlibs/os.sh # OS && ARCH
source shlibs/logging.sh # ERROR
source shlibs/common.sh # mktmp and rmtmp

USER_BIN_DIR=${USER_BIN_DIR:="~/bin"}

lua_lsp() {
  local version="3.6.3"
  mktmp

  local arch=$(ARCH)
  if [[ "${arch}" == "unknown" ]]; then
    TRACE "failed to install lua lsp - unknown arch : $(ARCH)" 99
  elif [[ "$(ARCH)" == "amd64" ]]; then
    arch=x64
  fi

  local fname="lua-language-server-${version}-${OS}-${arch}.tar.gz"
  local url="https://github.com/sumneko/lua-language-server/releases/download/${version}/${fname}"
  local install_dir="${USER_BIN_DIR}/lua-language-server.d"

  mkdir -p ${install_dir}
  curl -L -o $(pwd)/${fname} ${url} || TRACE "failed to download lua-language-server"
  tar xvzf $(pwd)/${fname} -C ${install_dir} || TRACE "failed to install lua-language-server to ${install_dir}"

  rmtmp
}

install_lsp_binaries() {
  # lua_lsp
}
