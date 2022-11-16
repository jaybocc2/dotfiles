#!/bin/bash
OS=$(uname |tr '[:upper:]' '[:lower:]')

ARCH() {
  local arch=$(uname -m)
  if [[ "${arch}" == 'x86_64' ]]; then
    echo 'amd64'
  elif [[ "${arch}" == 'arm64' ]]; then
    echo 'arm64'
  elif [[ "${arch}" == 'aarch64' ]]; then
    echo 'arm64'
  else
    echo 'unknown'
  fi
}

if [[ -f /etc/os-release ]];then source /etc/os-release; fi
