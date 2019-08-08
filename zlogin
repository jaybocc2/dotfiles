tmux_setup () {
  tmux has -t $1 2>/dev/null
  if [[ $? -gt 0 ]]; then
    while read line;do
      eval tmux "${line}"
    done < $2
    tmux source-file ${HOME}/.tmux/$(uname).conf
  fi
}

tmux_setup main ~/.tmux/$(uname).init
tmux_setup sideprojects ~/.tmux/sideprojects.init
