# -----------------------------------------------
# Set up the Environment
# -----------------------------------------------
export PATH=${PATH}
if [ -d ${HOME}/bin ]; then
  if [ "$(echo ${PATH} |grep -o \"${HOME}/bin\")" != "${HOME}/bin" ];then
    export PATH=${HOME}/bin:${PATH}
  fi
fi

export PATH=${PATH}
if [ -d /opt/homebrew/bin ]; then
  if [ "$(echo ${PATH} |grep -o "/opt/homebrew/bin")" != "/opt/homebrew/bin" ];then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

if [ -e ${GOROOT} -a -e ${GOPATH} ];then
  if [ "$(echo ${PATH} |grep -o "${GOROOT}"|head -n 1)" != "${GOROOT}" ]; then
    export PATH=${GOPATH}/bin:${GOROOT}/bin:${PATH}
  fi
fi

if [ -d ${HOME}/.rbenv ]; then
  if [ "$(echo ${PATH} |grep -o '.rbenv/bin')" != '.rbenv/bin' ];then
    export PATH=${RBENV_ROOT}/bin:${PATH}
  fi
  if [ "$(echo ${PATH} |grep -o '.rbenv/shims')" != '.rbenv/shims' ];then
    eval "$(rbenv init -)"
  fi
fi

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

if [ -d ${HOME}/.nodenv ]; then
  if [ "$(echo ${PATH} |grep -o '.nodenv/bin')" != '.nodenv/bin' ]; then
    export PATH=${NODENV_ROOT}/bin:${PATH}
  fi

  if [ "$(echo ${PATH} |grep -o '.nodenv/shims')" != '.nodenv/shims' ]; then
    eval "$(nodenv init -)"
  fi
fi

if [ -d ${HOME}/.tfenv ]; then
  if [ "$(echo ${PATH} |grep -o '.tfenv/bin')" != '.tfenv/bin' ]; then
    export PATH=${TFENV_ROOT}/bin:${PATH}
  fi
fi

#OktaAWSCLI
if [ -f ${HOME}/.okta/bash_functions ]; then
    source "${HOME}/.okta/bash_functions"
fi

if [ -d ${HOME}/.okta/bin ]; then
  if [ "$(echo ${PATH} |grep -o '.okta/bin')" != '.okta/bin' ]; then
    export PATH="${HOME}/.okta/bin:${PATH}"
  fi
fi

if [ -d "${FLUTTER_PATH}" ]; then
  if [ "$(echo ${PATH} |grep -o \"${FLUTTER_PATH}/bin\")" != "${FLUTTER_PATH}/bin" ]; then
    export PATH="${FLUTTER_PATH}/bin:${PATH}"
  fi
fi

if [ -d "${ANDROID_PATH}" ]; then
  if [ "$(echo ${PATH} |grep -o \"${ANDROID_PATH}/bin\")" != "${ANDROID_PATH}/bin" ]; then
    export PATH="${ANDROID_PATH}/bin:${PATH}"
  fi
fi

if [ -d "${ANDROID_HOME}/Sdk/platform-tools" ]; then
  if [ "$(echo ${PATH} |grep -o \"${ANDROID_HOME}/Sdk/platform-tools\")" != "${ANDROID_HOME}/Sdk/platform-tools" ]; then
    export PATH="${ANDROID_HOME}/Sdk/platform-tools:${PATH}"
    export PATH="${ANDROID_HOME}/Sdk/build-tools:${PATH}"
    export PATH="${ANDROID_HOME}/Sdk/cmdline-tools:${PATH}"
  fi
fi
