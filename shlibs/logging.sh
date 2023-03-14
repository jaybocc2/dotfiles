#!/bin/bash

TEMPFILES=()
CLEANUP=""
TRACED=""
export LOG=${LOG:-"error"}

cleanup() {
  CLEANUP="true"
  rm -rf "${TEMPFILES[@]}"
}

add_tmpfile() {
  if [ -e "${1}" ]; then
    TEMPFILES+=("${1}")
  fi
}

int_err() {
  message=${1:-'unknown error'}
  if [ -n "${TRACED}" ] || [ -n "${CLEANUP}" ]; then
    echo "ERROR : ${message}" >&2
  else
    echo "ERROR ${BASH_SOURCE[$i + 1]}:${BASH_LINENO[$i]}:${FUNCNAME[$i + 1]}() : ${message}" >&2
  fi
}

TRACE() {
  # print a stacktrace
  local T="|  "
  local tab=""
  n=${#FUNCNAME[@]}
  ((--n))
  while [ "${n}" -gt 0 ]; do
    if [ -n "${BASH_SOURCE[$n + 1]}" ]; then
      echo "${tab}${BASH_SOURCE[$n + 1]}:${BASH_LINENO[$n]}:${FUNCNAME[$n + 1]}()" >&2
      tab="${tab}${T}"
    fi
    ((--n))
  done
  TRACED="true"
  ERROR "$1" "$2"
}

ERROR() {
  # print error message, cleanup tempfiles and exit w/ code
  message=${1:-'unknown error'}
  code=${2:-1}

  int_err "${message}"
  sleep 5
  cleanup || int_err "failed to cleanup TEMPFILES : ${TEMPFILES[*]}"
  exit "${code}"
}
