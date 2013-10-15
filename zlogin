tmux_setup () {
  while read line;do
    eval tmux $line
  done < $1
}

if [[ $(hostname) == 'ua41f726ec3bf51b0fc71' ]]; then
  tmux_setup ~/.tmux/ubuntu.amz.conf
else
  tmux_setup ~/.tmux/main.conf
fi
