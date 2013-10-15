tmux_setup () {
  for line in $(cat $1);do
    tmux $line
  done
}

if [[ hostname == 'ua41f726ec3bf51b0fc71' ]]; then
  tmux_setup ~/.tmux/ubuntu.amz.conf
else
  tmux_setup ~/.tmux/main.conf
fi
