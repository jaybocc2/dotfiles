# -----------------------------------------------
# Set up the Environment
# -----------------------------------------------
export PATH=${PATH}

if [ -e ${GOROOT} -a -e ${GOPATH} ];then
  if [ "$(echo ${PATH} |grep -o "${GOROOT}"|head -n 1)" != "${GOROOT}" ]; then
    export PATH=${GOPATH}/bin:${GOROOT}/bin:${PATH}
  fi
fi

if [ -d ~/.rbenv ]; then
  if [ "$(echo ${PATH} |grep -o '.rbenv/bin')" != '.rbenv/bin' ];then
    export PATH=${RBENV_ROOT}/bin:${PATH}
  fi
  if [ "$(echo ${PATH} |grep -o '.rbenv/shims')" != '.rbenv/shims' ];then
    eval "$(rbenv init -)"
  fi
fi

if [ -d ~/.pyenv ]; then
  if [ "$(echo ${PATH} |grep -o '.pyenv/bin')" != '.pyenv/bin' ]; then
    export PATH=${PYENV_ROOT}/bin:${PATH}
  fi
  if [ "$(echo ${PATH} |grep -o '.pyenv/shims')" != '.pyenv/shims' ]; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
  fi
fi

if [ -d ~/.nodenv ]; then
  if [ "$(echo ${PATH} |grep -o '.nodenv/bin')" != '.nodenv/bin' ]; then
    export PATH=${NODENV_ROOT}/bin:${PATH}
  fi

  if [ "$(echo ${PATH} |grep -o '.nodenv/shims')" != '.nodenv/shims' ]; then
    eval "$(nodenv init -)"
  fi
fi

if [ -d ~/.tfenv ]; then
  if [ "$(echo ${PATH} |grep -o '.tfenv/bin')" != '.tfenv/bin' ]; then
    export PATH=${TFENV_ROOT}/bin:${PATH}
  fi
fi
