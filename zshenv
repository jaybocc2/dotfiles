# -----------------------------------------------
# Set up the Environment
# -----------------------------------------------
export PATH=${PATH}
export PYENV_ROOT="${HOME}/.pyenv"
export RBENV_ROOT="${HOME}/.rbenv"
export NODENV_ROOT="${HOME}/.nodenv"
export GOROOT=${HOME}/go
export GOPATH=${HOME}/go-workspace
export PATH=${PATH}:${GOPATH}/bin:${GOROOT}/bin

if [ -d ~/.rbenv ]; then
  which rbenv
  if [ $? -gt 0 ];then
    export PATH=${RBENV_ROOT}/bin:${PATH}
  fi
  eval "$(rbenv init -)"
fi

if [ -d ~/.pyenv ]; then
  which pyenv
  if [ $? -gt 0 ];then
    export PATH=${PYENV_ROOT}/bin:${PATH}
  fi
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

if [ -d ~/.nodenv]; then
  which nodenv
  if [ $? -gt 0 ];then
    export PATH=${NODENV_ROOT}/bin:${PATH}
  fi
  eval "$(nodenv init -)"
fi
