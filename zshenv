# -----------------------------------------------
# Set up the Environment
# -----------------------------------------------
export PATH=${PATH}
export PYENV_ROOT="${HOME}/.pyenv"
export RBENV_ROOT="${HOME}/.rbenv"
export NODENV_ROOT="${HOME}/.nodenv"
export GOROOT=${HOME}/go
export GOPATH=${HOME}/go-workspace

if [ -e ${GOROOT} -a -e ${GOPATH} ];then
  if [ "$(echo ${PATH} |grep -o \"${GOROOT}\")" = "${GOROOT}" ] && [ "$(echo ${PATH} |grep -o \"${GOROOT}\")" = "${GOROOT}" ]; then
    export PATH=${GOPATH}/bin:${GOROOT}/bin:${PATH}
  fi
fi

if [ -d ~/.rbenv ]; then
  which rbenv
  if [ $? -gt 0 ] && [ "$(echo ${PATH} |grep -o 'rbenv')" = 'rbenv' ];then
    export PATH=${RBENV_ROOT}/bin:${PATH}
  fi
  eval "$(rbenv init -)"
fi

if [ -d ~/.pyenv ]; then
  which pyenv
  if [ $? -gt 0 ] && [ "$(echo ${PATH} |grep -o 'pyenv')" = 'pyenv' ];then
    export PATH=${PYENV_ROOT}/bin:${PATH}
  fi
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

if [ -d ~/.nodenv ]; then
  which nodenv
  if [ $? -gt 0 ] && [ "$(echo ${PATH} |grep -o 'nodenv')" = 'nodenv' ];then
    export PATH=${NODENV_ROOT}/bin:${PATH}
  fi
  eval "$(nodenv init -)"
fi
