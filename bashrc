# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# erase duplicate commands, skip history if command has leading space.
export HISTCONTROL=erasedups:ignorespace

export HISTSIZE=40000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Append history of all shells, update history when new prompt is shown.
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
# make less more friendly for non-text input files, see lesspipe(1) [ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
#case "$TERM" in
#xterm-color)
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#    ;;
#*)
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#    ;;
#esac

# Comment in the above and uncomment this below for a color prompt
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00;31m\]@\[\033[01;33m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias dir='ls --color=auto --format=vertical'
    alias vdir='ls --color=auto --format=long'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

SSHAGENT=/usr/bin/ssh-agent
SSHAGENTARGS="-s"

if [[ $(ps --no-heading -C ssh-agent |awk '{ print $4 }') == 'ssh-agent' ]]; then
  . .ssh/agent.$HOSTNAME.$USER
else
  eval `$SSHAGENT $SSHAGENTARGS > .ssh/agent.$HOSTNAME.$USER`
  . .ssh/agent.$HOSTNAME.$USER
fi

#if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
#  echo "should be evaluating the agent now..."
#  eval `$SSHAGENT $SSHAGENTARGS > .ssh/agent.$HOSTNAME.$USER`
#  . .ssh/agent.$HOSTNAME.$USER
#fi

NUMKEYS=$(ls ~/.ssh/keys/ |grep -v '.pub' |wc -l)
NUMIDENTITIES=$(ssh-add -l |grep -v "The agent has no identities." |wc -l)
if [[ ${NUMIDENTITIES} -lt ${NUMKEYS} ]]; then
  echo "adding agent identities"
  for i in $(ls ~/.ssh/keys/ |grep -v '.pub'); do
    ssh-add ~/.ssh/keys/${i}
  done
fi

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/bin/go/bin
export GOROOT=/usr/bin/go

export ARDUINO=/usr/bin/arduino
export ARDUINO_DIR=/usr/share/arduino
export ARDMK_DIR=/usr
export AVR_TOOLS_DIR=/usr
. "$HOME/.cargo/env"
