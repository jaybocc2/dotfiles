# -----------------------------------------------
# Set up the Environment
# -----------------------------------------------

# -----------------------------------------------
# Setup tool root paths
# -----------------------------------------------
export PYENV_ROOT="${HOME}/.pyenv"
export RBENV_ROOT="${HOME}/.rbenv"
export NODENV_ROOT="${HOME}/.nodenv"
export TFENV_ROOT="${HOME}/.tfenv"
export GOROOT=${HOME}/go
export GOPATH=${HOME}/go-workspace
export FLUTTER_PATH="${HOME}/flutter"
export ANDROID_PATH="${HOME}/android-studio"
export ANDROID_SDK_ROOT="${ANDROID_HOME}/Sdk"
export ANDROID_HOME="${HOME}/Android"

# -----------------------------------------------
# Set up the various dev tools && shims
# -----------------------------------------------
export PATH=${PATH}
if [ -d ${HOME}/bin ]; then
  if [ "$(echo ${PATH} |grep -o \"${HOME}/bin\")" != "${HOME}/bin" ];then
    export PATH=${HOME}/bin:${PATH}
  fi
fi

# homebrew
export PATH=${PATH}
if [ -d /opt/homebrew/bin ]; then
  if [ "$(echo ${PATH} |grep -o "/opt/homebrew/bin")" != "/opt/homebrew/bin" ];then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

# golang
if [ -e ${GOROOT} -a -e ${GOPATH} ];then
  if [ "$(echo ${PATH} |grep -o "${GOROOT}"|head -n 1)" != "${GOROOT}" ]; then
    export PATH=${GOPATH}/bin:${GOROOT}/bin:${PATH}
  fi
fi

# ruby / rbenv
if [ -d ${HOME}/.rbenv ]; then
  if [ "$(echo ${PATH} |grep -o '.rbenv/bin')" != '.rbenv/bin' ];then
    export PATH=${RBENV_ROOT}/bin:${PATH}
  fi
  if [ "$(echo ${PATH} |grep -o '.rbenv/shims')" != '.rbenv/shims' ];then
    eval "$(rbenv init -)"
  fi
fi

# python / pyenv / pyenv-virtualenv
if [ -d ${HOME}/.pyenv ]; then
  if [ "$(echo ${PATH} |grep -o '.pyenv/bin')" != '.pyenv/bin' ]; then
    export PATH=${PYENV_ROOT}/bin:${PATH}
  fi
  if [ "$(echo ${PATH} |grep -o '.pyenv/shims')" != '.pyenv/shims' ]; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
  fi
fi

# node / nodenv
if [ -d ${HOME}/.nodenv ]; then
  if [ "$(echo ${PATH} |grep -o '.nodenv/bin')" != '.nodenv/bin' ]; then
    export PATH=${NODENV_ROOT}/bin:${PATH}
  fi

  if [ "$(echo ${PATH} |grep -o '.nodenv/shims')" != '.nodenv/shims' ]; then
    eval "$(nodenv init -)"
  fi
fi

# terraform / tfenv
if [ -d ${HOME}/.tfenv ]; then
  if [ "$(echo ${PATH} |grep -o '.tfenv/bin')" != '.tfenv/bin' ]; then
    export PATH=${TFENV_ROOT}/bin:${PATH}
  fi
fi

# okta aws cli wrapper
if [ -f ${HOME}/.okta/bash_functions ]; then
    source "${HOME}/.okta/bash_functions"
fi

# okta bin dir
if [ -d ${HOME}/.okta/bin ]; then
  if [ "$(echo ${PATH} |grep -o '.okta/bin')" != '.okta/bin' ]; then
    export PATH="${HOME}/.okta/bin:${PATH}"
  fi
fi

# flutter
if [ -d "${FLUTTER_PATH}" ]; then
  if [ "$(echo ${PATH} |grep -o \"${FLUTTER_PATH}/bin\")" != "${FLUTTER_PATH}/bin" ]; then
    export PATH="${FLUTTER_PATH}/bin:${PATH}"
  fi
fi

# android sdk
if [ -d "${ANDROID_PATH}" ]; then
  if [ "$(echo ${PATH} |grep -o \"${ANDROID_PATH}/bin\")" != "${ANDROID_PATH}/bin" ]; then
    export PATH="${ANDROID_PATH}/bin:${PATH}"
  fi
fi

# android sdk platform tools
if [ -d "${ANDROID_HOME}/Sdk/platform-tools" ]; then
  if [ "$(echo ${PATH} |grep -o \"${ANDROID_HOME}/Sdk/platform-tools\")" != "${ANDROID_HOME}/Sdk/platform-tools" ]; then
    export PATH="${ANDROID_HOME}/Sdk/platform-tools:${PATH}"
    export PATH="${ANDROID_HOME}/Sdk/build-tools:${PATH}"
    export PATH="${ANDROID_HOME}/Sdk/cmdline-tools:${PATH}"
  fi
fi

# rust / cargo
if [ -e "${HOME}/.cargo/env" ];then
  source ${HOME}/.cargo/env
fi
. "$HOME/.cargo/env"
