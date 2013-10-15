tmux_setup () {
  tmux has -t $1 2>/dev/null
  if [[ $? -gt 0 ]]; then
    while read line;do
      eval tmux $line
    done < $2
  fi
}

if [[ $(hostname) == 'ua41f726ec3bf51b0fc71' ]]; then
  tmux_setup work ~/.tmux/ubuntu.amz.conf
else
  tmux_setup main ~/.tmux/main.conf
fi
