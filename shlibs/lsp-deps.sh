#!/bin/bash
source shlibs/os.sh # OS && ARCH
source shlibs/logging.sh # ERROR
source shlibs/common.sh # mktmp and rmtmp

USER_BIN_DIR=${USER_BIN_DIR:="${HOME}/bin"}
USER_LIBS_DIR=${USER_LIBS_DIR:="${HOME}/.local/libs"}

lua_lsp() {
  local version="3.6.3"
  mktmp

  local arch="unknown"
  arch=$(ARCH)

  if [[ "${arch}" == "unknown" ]]; then
    TRACE "failed to install lua lsp - unknown arch : ${arch}" 99
  elif [[ "${arch}" == "amd64" ]]; then
    arch=x64
  fi

  local fname="lua-language-server-${version}-${OS}-${arch}.tar.gz"
  local url="https://github.com/sumneko/lua-language-server/releases/download/${version}/${fname}"
  local install_dir="${USER_BIN_DIR}/lua-language-server.d"

  mkdir -p ${install_dir}
  curl -L -o "$(pwd)/${fname}" "${url}" || TRACE "failed to download lua-language-server"
  tar xvzf "$(pwd)/${fname}" -C "${install_dir}" || TRACE "failed to install lua-language-server to ${install_dir}"

  rmtmp
}

java_lsp() {
  # local repo="https://github.com/georgewfraser/java-language-server.git"
  # use my patch until upstream accepts it
  local repo="https://github.com/jaybocc2/java-language-server.git"
  local branch="improve-local-installation"
  if ! which brew; then
    return
  fi
  if ! which mvn; then
    brew install maven
  fi
  if ! which protobuf; then
    brew install protobuf
  fi

 # shellcheck disable=SC2155 
  export JAVA_HOME=$(/usr/libexec/java_home -v 17)

  mktmp
  upstall_repo ${repo} java-language-server ${branch}
  pushd java-language-server || TRACE "failed to pushd java-language-server"
  scripts/install.sh install

  popd || TRACE "failed to popd"
  rmtmp
}

jdtls_bazel() {
  local version="1.5.2"
  local fname="bazel-eclipse-feature-${version}-release"
  local url="https://github.com/salesforce/bazel-eclipse/releases/download/${version}/${fname}.zip"
  local install_dir="${USER_LIBS_DIR}/jdtls/bazel-plugins"
  mktmp

  curl -L -o "$(pwd)/${fname}.zip" "${url}" || TRACE "failed to download jdtls bazel plugins"
  unzip ${fname}.zip
  mkdir -p "${install_dir}"
  cp "$(pwd)/${fname}/plugins/*.jar" "${install_dir}/"
  rmtmp
}

jdtls_lombok() {
  local url="https://projectlombok.org/downloads/lombok.jar"
  local install_dir="${USER_LIBS_DIR}/jdtls/lombok"
  mktmp
  mkdir -p ${install_dir}
  curl -L -o "${install_dir}/lombok.jar" "${url}" || TRACE "failed to download and install lombok.jar"
  rmtmp
}

jdtls_plugins() {
  jdtls_bazel
  jdtls_lombok
}

install_lsp_binaries() {
  # lua_lsp
  # java_lsp
  jdtls_plugins
  echo "install_lsp_deps complete"
}
