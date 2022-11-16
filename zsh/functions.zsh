prompt_git_info () {
  git_repo_path=$(git rev-parse --git-dir 2>/dev/null)

  if [[ $git_repo_path != '' && $git_repo_path != '~' && $git_repo_path != "~/.git" ]]; then
    git_branch=" $(git symbolic-ref -q HEAD |sed 's/refs\/heads\///')"
    git_commit_id=" $(git rev-parse --short HEAD 2>/dev/null)"

    git_status=""
    if [[ $git_repo_path != '.' && $(git ls-files -m) != "" ]]; then
      git_status=" $FG[001]$FX[bold]✗$FX[no-bold]"
    else
      git_status=" $FG[035]✓"
    fi
    echo "$FG[006]${git_branch}$FG[003]${git_commit_id}${git_status} $FG[016]→"
  fi
}

tmux_load_avg () {
  cat /proc/loadavg || uptime |awk '{print $10, $11, $12}'
}

nvimvenv () {
  if [[ -e "${VIRTUAL_ENV}" && -f "${VIRTUAL_ENV}/bin/activate" ]]; then
    source "${VIRTUAL_ENV}/bin/activate"
    command nvim $@
    deactivate
  else
    command nvim $@
  fi
}
