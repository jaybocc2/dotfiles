#!/bin/zsh

local sep=""
local alt_sep=""

local sep_prefix() {
  printf "%s" "${2}${sep}${1}${2}"
}

local username() {
  local fg="%F{220}"
  local bg="%K{166}"
  local sep_fg="%F{166}"
  local sep_fg="%F{166}"
  local prefix="${fg}${bg} "
  local affix="${sep_fg}"

  printf "%s" "${prefix}${USER} ${affix}"
}

local prompt_cwd() {
  local fg="%F{231}"
  local bg="%K{31}"
  local sep_fg="%F{31}"
  local prefix=$(sep_prefix ${fg} ${bg})
  local affix="${sep_fg}"
  local dir_limit="4"
  local truncation="⋯"
  local formatted_cwd=""
  # local tilde="" # \ueb06
  local tilde="~"
  local _cwd="${PWD/#$HOME/$tilde}"

  # get first char
  local first_char=$_cwd[1,1]
  # remove leading ~
  _cwd="${_cwd/#$tilde}"
  while [[ "$_cwd" == */* && "$_cwd" != "/" ]]; do
    local part="${_cwd##*/}"
    _cwd="${_cwd%/*}"
    formatted_cwd=" ${alt_sep} ${part}$formatted_cwd"
    part_count=$((part_count+1))
    [[ $part_count -eq $dir_limit ]] && first_char="$truncation" && break
  done


  echo "${prefix} ${first_char}${formatted_cwd} ${affix}"
}

local git_changes() {
  local fg="%F{250}"
  local bg="%K{236}"
  local sep_fg="%F{236}"
  local prefix=$(sep_prefix ${fg} ${bg})
  local affix="${sep_fg}"
  local green_fg="%F{64}"
  local yellow_fg="%F{220}"
  local red_fg="%F{52}"
  local added_symbol="${yellow_fg}●${fg}"
  local unmerged_symbol="${red_fg}✗${fg}"
  local modified_symbol="${red_fg}${fg}"
  local clean_symbol="${green_fg}✔${fg}"
  local has_untracked_files_symbol="${yellow_fg}…${fg}"

  local ahead_symbol="↑"
  local behind_symbol="↓"

  local unmerged_count=0 modified_count=0 has_untracked_files=0 added_count=0 is_clean=0

  local behind_count=0
  local ahead_count=0
  git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null
  if [ $? -eq 0 ];then
    local behind_count=$(git rev-list --left-right --count @{upstream}...HEAD|awk '{print $1}')
    local ahead_count=$(git rev-list --left-right --count @{upstream}...HEAD|awk '{print $2}')
  fi

  while read line; do
    case "$line" in
      M*) modified_count=$(($modified_count+1));;
      U*) unmerged_count=$(($unmerged_count+1));;
    esac
  done < <(git diff --name-status)

  while read line; do
    case "$line" in
      *) added_count=$(($added_count+1));;
    esac
  done < <(git diff --name-status --cached)

  if [ -n "$(git ls-files --others --exclude-standard)" ];then
    has_untracked_files=1
  fi

  if [ $(( unmerged_count + modified_count + has_untracked_files + added_count )) -eq 0 ];then
    is_clean=1
  fi

  prompt_string=''
  test $ahead_count -gt 0 && prompt_string+=" ${ahead_symbol}${ahead_count}"
  test $behind_count -gt 0 && prompt_string+=" ${behind_symbol}${behind_count}"
  test $modified_count -gt 0 && prompt_string+=" ${modified_symbol}${modified_count}"
  test $unmerged_count -gt 0 && prompt_string+=" ${unmerged_symbol}${unmerged_count}"
  test $added_count -gt 0 && prompt_string+=" ${added_symbol}${added_count}"
  test $has_untracked_files -gt 0 && prompt_string+=" ${has_untracked_files_symbol}"
  test $is_clean -gt 0 && prompt_string+=" ${clean_symbol}"
  echo "${prefix}${prompt_string} ${affix}"
}

local prompt_git() {
  git status &>/dev/null
  test $? -ne 0 && echo "" && return 1;

  local git_rev=$(git rev-parse --short HEAD 2>/dev/null)
  local git_branch=$(git branch --show-current)

  local fg="%F{250}"
  local bg="%K{240}"
  local sep_fg="%F{240}"
  local prefix=$(sep_prefix ${fg} ${bg})
  local affix="${sep_fg}"

  git_string="${prefix} ${git_branch} ${alt_sep} ${git_rev} ${affix}"
  git_string+="$(git_changes)"
  
  echo "${git_string}"
}

local prompt_last_exit_code() {
  test ${last_exit_code} -eq 0 && return 1;
  local fg="%F{250}"
  local bg="%K{52}"
  local sep_fg="%F{52}"
  local prefix=$(sep_prefix ${fg} ${bg})
  local affix="${sep_fg}"

  echo "${prefix} ${last_exit_code} ${affix}"
}

__build_prompt() {
  local last_exit_code="$?"
  PROMPT=''
  PROMPT+="$(username)"
  PROMPT+="$(prompt_cwd)"
  PROMPT+="$(prompt_git)"
  PROMPT+="$(prompt_last_exit_code)"
  PROMPT+="$(sep_prefix %f %k)"
}

if [[ ! ${precmd_functions[(r)__build_prompt]} == __build_prompt ]]; then
  precmd_functions+=(__build_prompt)
  setopt promptsubst
fi
