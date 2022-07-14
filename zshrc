# -----------------------------------------------
# Set up the Environment
# -----------------------------------------------
source ~/.zsh/env.zsh
source ~/.zsh/colors.zsh
source ~/.zsh/functions.zsh


EDITOR="nvim"
PAGER=less
RSYNC_RSH=/usr/bin/ssh
FIGNORE='.o:.out:~'
DISPLAY=:0.0


ARDUINO_DIR=/usr/share/arduino
ARDMK_DIR=/usr/local
AVR_TOOLS_DIR=/usr


# colored filename/directory completion
# Attribute codes:
# 00 none 01 bold 04 underscore 05 blink 07 reverse 08 concealed
# Text color codes:
# 30 black 31 red 32 green 33 yellow 34 blue 35 magenta 36 cyan 37 white
# Background color codes:
# 40 black 41 red 42 green 43 yellow 44 blue 45 magenta 46 cyan 47 white
LS_COLORS='no=0:fi=0:di=1;34:ln=1;36:pi=40;33:so=1;35:do=1;35:bd=40;33;1:cd=40;33;1:or=40;31;1:ex=1;32:*.tar=1;31:*.tgz=1;31:*.arj=1;31:*.taz=1;31:*.lzh=1;31:*.zip=1;31:*.rar=1;31:*.z=1;31:*.Z=1;31:*.gz=1;31:*.bz2=1;31:*.tbz2=1;31:*.deb=1;31:*.pdf=1;31:*.jpg=1;35:*.jpeg=1;35:*.gif=1;35:*.bmp=1;35:*.pbm=1;35:*.pgm=1;35:*.ppm=1;35:*.pnm=1;35:*.tga=1;35:*.xbm=1;35:*.xpm=1;35:*.tif=1;35:*.tiff=1;35:*.png=1;35:*.mpg=1;35:*.mpeg=1;35:*.mov=1;35:*.avi=1;35:*.wmv=1;35:*.ogg=1;35:*.mp3=1;35:*.mpc=1;35:*.wav=1;35:*.au=1;35:*.swp=1;30:*.pl=36:*.c=36:*.cc=36:*.h=36:*.core=1;33;41:*.gpg=1;33:'

ZLS_COLORS="$LS_COLORS" COLORTERM=truecolor
case $TERM in
  iterm            |\
  linux-truecolor  |\
  screen-truecolor |\
  tmux-truecolor   |\
  xterm-truecolor  )    export COLORTERM=truecolor ;;
  vte*)
esac

# history saves 50,000 in it if we want to open it
# only the last 1000 are part of backward searching
HISTFILE=~/.zshhistory
HISTSIZE=100000
SAVEHIST=100000

# share history across terminal sessions
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

# ignore dupes
setopt HIST_IGNORE_ALL_DUPS
setopt HISTVERIFY


# we like the calculator built into the shell
autoload -U zcalc

export TERM EDITOR PAGER RSYNC_RSH CVSROOT FIGNORE DISPLAY NNTPSERVER COLORTERM PATH HISTFILE HISTSIZE SAVEHIST

# -----------------------------------------------
# Prompt Setup
# -----------------------------------------------
setopt promptsubst
autoload -U promptinit && promptinit

# source airline style zsh prompt
source ~/.zsh/prompt.zsh

autoload -U zrecompile

# case-insensitive tab completion for filenames (useful on Mac OS X)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '-- %B%d%b --'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# -----------------------------------------------
# Setup
# -----------------------------------------------
setopt \
    no_beep \
    correct \
    auto_list \
    complete_in_word \
    auto_pushd \
    pushd_ignoredups \
    complete_aliases \
    extended_glob \
    zle

# -----------------------------------------------
# Keybindings
# -----------------------------------------------
[[ -n "${key[Delete]}" ]] && bindkey "${key[Delete]}" delete-char

bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\ee[C" forward-word
bindkey "\ee[D" backward-word
bindkey "^H" backward-delete-word
# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# for non RH/Debian xterm, can't hurt for RH/DEbian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix
bindkey '^R' history-incremental-search-backward
# complete on a space character
bindkey ' ' magic-space

# allow editing of the text on the current command line with v (cmd mode)
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# map jj as the esc key for vim mode
bindkey "jj" vi-cmd-mode

# auto pushd setopt autocd autopushd pushdignoredups
bindkey -v

# -----------------------------------------------
# SSH AGENT SETUP
# -----------------------------------------------
HOSTNAME=$(hostname -s)
SSHAGENT=/usr/bin/ssh-agent
SSHAGENTARGS=""

SSHEC=$(ps ax|grep -c "[s]sh-agent")

if [ ${SSHEC} -eq 0 ]; then
  eval $(${SSHAGENT} ${SSHAGENTARGS} > ~/.ssh/agent.${HOSTNAME}.${USER})
  source ~/.ssh/agent.${HOSTNAME}.${USER}
  for i in $(ls ~/.ssh/keys/ |grep -v '.pub'); do
    ssh-add ~/.ssh/keys/${i}
  done
  # ssh-add -s libeToken.so.8 -t 28800
else
  source ~/.ssh/agent.${HOSTNAME}.${USER}
fi

# -----------------------------------------------
# Shell Aliases
# -----------------------------------------------

## Command Aliases
alias x=exit
alias c=clear
alias b=byobu
alias s=screen
alias r='screen -R'
alias ls='ls --color=auto -F'
alias ll='ls -lAFh --color=auto'
alias ld='ls -ltr --color=auto'
alias sls='screen -ls'
alias zrc='vim ~/.zshrc'
alias dv='dirs -v'
alias hist='history -rd'
alias zc='zcalc'
alias grep='grep --color'
# alias bjs='ssh-add -s libeToken.so.8 -t 28800'
alias ka='pkill ssh-agent'
alias fa='source ~/.zshrc'
alias fnv="nvimvenv --headless -u NONE -c 'lua require(\"bootstrap\").bootstrap_paq()'"
alias tmuxmain='tmux -2 attach -t main'
alias tmuxside='tmux -2 attach -t sideprojects'
alias gows="cd ${GOPATH}/src/github.com/jaybocc2"
alias vim="nvimvenv"
alias nvim="nvimvenv"
alias vi='vim'
eval "$(hub alias -s)"

## Pipe Aliases (Global)
#alias -g L='|less'
#alias -g G='|grep'
#alias -g T='|tail'
#alias -g H='|head'
#alias -g W='|wc -l'
#alias -g S='|sort'

# directory aliases
# use like: ls ~src OR ~src OR du -h ~src
# src=~/src

if [ -e ~/.localized.zsh ]; then
  source ~/.localized.zsh
fi
