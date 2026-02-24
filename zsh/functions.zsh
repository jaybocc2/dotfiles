#!/usr/bin/env zsh

tmux_load_avg () {
  cat /proc/loadavg || uptime |awk '{print $10, $11, $12}'
}

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

tmuxsession () {
  name='main'
  if [ -n "${1}" ]; then
    name=${1}
  fi

  if tmux list-sessions -F '#S' -f "#{m:${name},#S}" 2>&1| grep -q "${name}"; then
    echo "trying to attach to ${name}..."
    tmux attach -t ${name}
  else
    echo "trying to create session ${name}..."
    tmux new-session -d -n "htop" -s "${name}" htop
    echo "trying to attach to ${name}..."
    tmux attach -t ${name}
  fi
}

tokb() {
  jq -n "$1 / 1024"
}

tomb() {
  jq -n "$(tokb $1) / 1024"
}

togb() {
  jq -n "$(tomb $1) / 1024"
}

totb() {
  jq -n "$(togb $1) / 1024"
}

rmkhkey() {
  sed -i '' "${1}d" ~/.ssh/known_hosts
}
