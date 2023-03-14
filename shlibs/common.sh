#!/bin/bash
source shlibs/logging.sh

mktmp() {
  local tdir=/tmp/${FUNCNAME[1]}
  mkdir -p ${tdir} && add_tmpfile "${tdir}"
  pushd ${tdir} || TRACE "unable to pushd ${tdir}"
}

rmtmp() {
  local tdir=/tmp/${FUNCNAME[1]}
  popd
  rm -rf ${tdir}
}

rmlink() {
  local file=${1}
  if [ -e ${file} -o -h ${file} ]; then
    echo "uninstalling link for ${file}"
    rm -rf ${file}
  fi
}

upstall_repo() {
  test -d $2 && {
    echo "Updating ${2} ($3) . . ."
    pushd $2
    git checkout $3 || TRACE "checking out $3 in $2"
    git pull --ff-only || TRACE "pulling branch in $2"
    popd
  } || {
    echo "Installing $1 to $2 . . ."
    git clone $1 $2 || TRACE "cloning repo $1"
    pushd $2
    git checkout $3 || TRACE "checking out $3 in $2"
    if [ "$(git status |grep -o detached)" != "detached" ];then
      echo "========= was not detached ==========="
      git status
      echo " ======== "
      git pull --ff-only || TRACE "pulling branch in $2"
    fi
    popd
  }
}

fixenv() {
  source zshenv
}
