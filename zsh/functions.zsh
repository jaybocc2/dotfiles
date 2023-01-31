tmux_load_avg () {
  cat /proc/loadavg || uptime |awk '{print $10, $11, $12}'
}

nvimvenv () {
  export JAVA_HOME=$(/usr/libexec/java_home -v 17)

  if [[ -e "${VIRTUAL_ENV}" && -f "${VIRTUAL_ENV}/bin/activate" ]]; then
    source "${VIRTUAL_ENV}/bin/activate"
    command nvim $@
    deactivate
  else
    command nvim $@
  fi

}
