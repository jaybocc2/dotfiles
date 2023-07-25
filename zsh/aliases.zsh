#!/bin/zsh

# -----------------------------------------------
# Shell Aliases
# -----------------------------------------------

## Command Aliases
alias x=exit
alias c=clear
alias ls='ls --color=auto -F'
alias ll='ls -lAFh --color=auto'
alias ld='ls -ltr --color=auto'
alias dv='dirs -v'
alias hist='history -rd'
alias zc='zcalc'
alias grep='grep --color'
alias tmuxmain='tmux -2 attach -t main'
alias tmuxside='tmux -2 attach -t sideprojects'
alias vim="nvimvenv"
alias nvim="nvimvenv"
alias vi='vim'

alias editzshrc='vim ~/.zshrc'
alias editlocalizedzsh='vim ~/.localized.zsh'
alias reloadzshrc="source ${HOME}/.zshrc"
alias reloadlocalizedzsh="source ${HOME}/.localized.zsh"
alias reloadaliases="source $ZSH_CUSTOM/aliases.zsh"
alias reloadsshagent="source $ZSH_CUSTOM/ssh-agent.zsh"
alias killsshagent="pkill ssh-agent"
