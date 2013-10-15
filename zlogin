work_ubuntu_setup () {
  tmux source ~/.tmux/ubuntu.amz.conf
}
main_setup () {
  tmux source ~/.tmux/main.conf
}
misc_setup () {
}

#start tmux server
tmux start

if [[ hostname == 'ua41f726ec3bf51b0fc71' ]]; then
  work_ubuntu_setup
else
  main_setup
fi
