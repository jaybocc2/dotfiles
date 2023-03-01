# -----------------------------------------------
# Shell Aliases
# -----------------------------------------------

## Command Aliases
alias x=exit
alias c=clear
alias ls='ls --color=auto -F'
alias ll='ls -lAFh --color=auto'
alias ld='ls -ltr --color=auto'
alias zrc='vim ~/.zshrc'
alias lzrc='vim ~/.localized.zsh'
alias dv='dirs -v'
alias hist='history -rd'
alias zc='zcalc'
alias grep='grep --color'
alias tmuxmain='tmux -2 attach -t main'
alias tmuxside='tmux -2 attach -t sideprojects'
alias vim="nvimvenv"
alias nvim="nvimvenv"
alias vi='vim'

alias fixaliases="source $ZSH_CUSTOM/aliases.zsh"
alias fixsshagent="source $ZSH_CUSTOM/ssh-agent.zsh"
alias killsshagent="pkill ssh-agent"
