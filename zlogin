tmux_setup () {
  tmux has -t $1 2>/dev/null
  if [[ $? -gt 0 ]]; then
    while read line;do
      eval tmux "${line}"
    done < $2
  fi
}

if [[ $(uname) == 'Darwin' ]]; then
  tmux_setup main ~/.tmux/osx.init
elif [[ $(uname) == 'Linux' ]]; then
  tmux_setup main ~/.tmux/main.init
else
  tmux_setup main ~/.tmux/main.init
fi
