tmux_load_avg () {
  cat /proc/loadavg || uptime |awk '{print $10, $11, $12}'
}

command pyenv rehash 2>/dev/null

pyenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  activate|deactivate|rehash|shell)
    eval "$(pyenv "sh-$command" "$@")"
    ;;
  *)
    command pyenv "$command" "$@"
    ;;
  esac
}

_pyenv_virtualenv_hook() {
  local ret=$?
  if [ -n "${VIRTUAL_ENV-}" ]; then
    eval "$(pyenv sh-activate --quiet || pyenv sh-deactivate --quiet || true)" || true
  else
    eval "$(pyenv sh-activate --quiet || true)" || true
  fi
  return $ret
};

typeset -g -a precmd_functions
if [[ -z $precmd_functions[(r)_pyenv_virtualenv_hook] ]]; then
  precmd_functions=(_pyenv_virtualenv_hook $precmd_functions);
fi

nvimvenv () {
  if [ -e /usr/libexec/java_home ];then
    export JAVA_HOME=$(/usr/libexec/java_home -v 17)
  fi

  if [[ -e "${VIRTUAL_ENV}" && -f "${VIRTUAL_ENV}/bin/activate" ]]; then
    source "${VIRTUAL_ENV}/bin/activate"
    command nvim $@
    deactivate
  else
    command nvim $@
  fi

}
