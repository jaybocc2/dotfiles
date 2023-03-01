check_in_path() {
  test "$(echo ${PATH} |grep -o $1)" != $1 
}

check_if_dir_exists() {
  test -d $1
}

# -----------------------------------------------
# Set up the Environment
# -----------------------------------------------

# -----------------------------------------------
# Setup tool root paths
# -----------------------------------------------
export ANDROID_HOME="${HOME}/Android"
export ANDROID_PATH="${HOME}/android-studio"
export ANDROID_SDK_ROOT="${ANDROID_HOME}/Sdk"
export FLUTTER_PATH="${HOME}/flutter"
export GOPATH=${HOME}/go-workspace
export GOROOT=${HOME}/go
export NODENV_ROOT="${HOME}/.nodenv"
export PYENV_ROOT="${HOME}/.pyenv"
export RBENV_ROOT="${HOME}/.rbenv"
export TFENV_ROOT="${HOME}/.tfenv"
export HOME_BIN="${HOME}/bin"
export HOMEBREW_BIN="/opt/homebrew/bin"

# -----------------------------------------------
# Set up the various dev tools && shims
# -----------------------------------------------
export PATH=${PATH}
if check_if_dir_exists ${HOME_BIN}; then
  if ! check_in_path ${HOME_BIN}; then
    export PATH=${HOME_BIN}:${PATH}
  fi
fi

# homebrew
if check_if_dir_exists ${HOMEBREW_BIN}; then
  if ! check_in_path ${HOMEBREW_BIN}; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

# golang
if [ -e ${GOROOT}/bin -a -e ${GOPATH}/bin ];then
  if ! check_in_path "${GOPATH}/bin:${GOROOT}/bin"; then
    export PATH=${GOPATH}/bin:${GOROOT}/bin:${PATH}
  fi
fi

# ruby / rbenv
if check_if_dir_exists ${RBENV_ROOT}; then
  if ! check_in_path "${RBENV_ROOT}/bin";then
    export PATH=${RBENV_ROOT}/bin:${PATH}
  fi

  if ! check_in_path "${RBENV_ROOT}/shims";then
    eval "$(rbenv init -)"
  fi
fi

# python / pyenv / pyenv-virtualenv
if check_if_dir_exists ${PYENV_ROOT}; then
  if ! check_in_path "${PYENV_ROOT}/bin"; then
    export PATH=${PYENV_ROOT}/bin:${PATH}
  fi

  if ! check_in_path "${PYENV_ROOT}/shims"; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
  fi
fi

# node / nodenv
if check_if_dir_exists ${NODENV_ROOT}; then
  if ! check_in_path "${NODENV_ROOT}/bin"; then
    export PATH=${NODENV_ROOT}/bin:${PATH}
  fi

  if ! check_in_path "${NODENV_ROOT}/shims"; then
    eval "$(nodenv init -)"
  fi
fi

# terraform / tfenv
if check_if_dir_exists ${TFENV_ROOT}; then
  if ! check_in_path "${TFENV_ROOT}/bin"; then
    export PATH=${TFENV_ROOT}/bin:${PATH}
  fi
fi

# okta aws cli wrapper
if [ -f ${HOME}/.okta/bash_functions ]; then
    source "${HOME}/.okta/bash_functions"
fi

# okta bin dir
if [ -d ${HOME}/.okta/bin ]; then
  if ! check_in_path "${HOME}/.okta/bin"; then
    export PATH="${HOME}/.okta/bin:${PATH}"
  fi
fi

# flutter
if check_if_dir_exists "${FLUTTER_PATH}"; then
  if ! check_in_path "${FLUTTER_PATH}/bin"; then
    export PATH="${FLUTTER_PATH}/bin:${PATH}"
  fi
fi

# android sdk
if check_if_dir_exists "${ANDROID_PATH}"; then
  if ! check_in_path "${ANDROID_PATH}/bin"; then
    export PATH="${ANDROID_PATH}/bin:${PATH}"
  fi
fi

# android sdk platform tools
if [ -d "${ANDROID_HOME}/Sdk/platform-tools" ]; then
  if ! check_in_path "${ANDROID_HOME}/Sdk/platform-tools"; then
    export PATH="${ANDROID_HOME}/Sdk/platform-tools:${PATH}"
  fi
  if ! check_in_path "${ANDROID_HOME}/Sdk/build-tools"; then
    export PATH="${ANDROID_HOME}/Sdk/build-tools:${PATH}"
  fi
  if ! check_in_path "${ANDROID_HOME}/Sdk/cmdline-tools"; then
    export PATH="${ANDROID_HOME}/Sdk/cmdline-tools:${PATH}"
  fi
fi

# rust / cargo
if ! check_in_path "${HOME}/.cargo/bin";then
  export PATH="${HOME}/.cargo/bin:${PATH}"
  # this does the same thing as above
  # source ${HOME}/.cargo/env
fi
