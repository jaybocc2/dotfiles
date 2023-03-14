tmux_setup () {
  if ! tmux has -t $1; then
    echo "Initializing $1 session with $2"
    while read line;do
      eval tmux "${line}"
    done < $2
    tmux source-file ${HOME}/.tmux/$(uname).conf
  fi
}

if [ "${TMUX}" != "X" ]; then
  tmux_setup main ~/.tmux/$(uname).init
  tmux_setup sideprojects ~/.tmux/sideprojects.init
fi
