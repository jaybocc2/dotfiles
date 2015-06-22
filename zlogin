tmux_setup () {
  tmux has -t $1 2>/dev/null
  if [[ $? -gt 0 ]]; then
    while read line;do
      eval tmux $line
    done < $2
  fi
}

if [[ $(uname -a |awk '{print $1}') == 'Darwin' ]]; then
  tmux_setup main ~/.tmux/osx.conf
elif [[ $(uname -a |awk '{print $1}') == 'Linux' ]]; then
  tmux_setup main ~/.tmux/main.conf
else
  tmux_setup main ~/.tmux/main.conf
fi
