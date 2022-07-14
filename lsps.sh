#!/bin/bash
source utils.sh

lua_lsp() {
  local arch=$(ARCH)
  if [[ "${arch}" == "unknown" ]]; then
    echo "failed to install lua lsp - unknown arch : $(ARCH)"
    exit 99
  elif [[ "$(ARCH)" == "amd64" ]]; then
    arch=x64
  fi

  mkdir -p ~/bin/lua-language-server.d
  pushd /tmp
  local version="2.6.6"
  local fname="lua-language-server-${version}-${OS}-${arch}.tar.gz"
  local url="https://github.com/sumneko/lua-language-server/releases/download/${version}/${fname}"
  curl -L -o /tmp/${fname} ${url} && tar xvzf /tmp/${fname} -C ~/bin/lua-language-server.d
  popd
}

install_lsps() {
  lua_lsp
  echo "pass"
}
