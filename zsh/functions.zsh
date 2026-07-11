#!/usr/bin/env zsh

tmux_load_avg () {
  cat /proc/loadavg || uptime |awk '{print $10, $11, $12}'
}

nvimvenv () {
  if [ -e /usr/libexec/java_home ];then
    export JAVA_HOME=$(/usr/libexec/java_home -v 17)
  fi

  if [[ -e "${VIRTUAL_ENV}" && -f "${VIRTUAL_ENV}/bin/activate" ]]; then
    source "${VIRTUAL_ENV}/bin/activate"
    command nvim $@
    deactivate
  else
    command nvim $@
  fi
}

tmuxsession () {
  name='main'
  if [ -n "${1}" ]; then
    name=${1}
  fi

  if tmux list-sessions -F '#S' -f "#{m:${name},#S}" 2>&1| grep -q "${name}"; then
    echo "trying to attach to ${name}..."
    tmux attach -t ${name}
  else
    echo "trying to create session ${name}..."
    tmux new-session -d -n "htop" -s "${name}" htop
    echo "trying to attach to ${name}..."
    tmux attach -t ${name}
  fi
}

tokb() {
  echo $(( ${1:-0}.0 / 1024 ))
}

tomb() {
  echo $(( ${1:-0}.0 / (1024 * 1024) ))
}

togb() {
  echo $(( ${1:-0}.0 / (1024 * 1024 * 1024) ))
}

totb() {
  echo $(( ${1:-0}.0 / (1024 * 1024 * 1024 * 1024) ))
}

rmkhkey() {
  if [[ "$(uname)" == "Darwin" ]]; then
    sed -i '' "${1}d" ~/.ssh/known_hosts
  else
    sed -i "${1}d" ~/.ssh/known_hosts
  fi
}

gowt() {
  local branch="${1}"
  if [[ -z "${branch}" ]]; then
    echo "Usage: gowt <branch-name>" >&2
    return 1
  fi

  local worktree_path
  worktree_path=$(git worktree list | awk -v br="[${branch}]" 'index($0, br) {print $1}')

  if [[ -n "${worktree_path}" ]]; then
    cd "${worktree_path}"
  else
    git worktree add -B "${branch}" "${branch}"
    cd "${branch}"
    git fetch origin
    local remote_head
    remote_head=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null)
    local default_branch=${remote_head#refs/remotes/origin/}
    default_branch=${default_branch:-main}
    git reset --hard "origin/${default_branch}"
  fi
}

agy () {
  local dir="$PWD"
  local unresolved_git_root=""
  while [[ "$dir" != "/" ]]; do
    if [[ -e "$dir/.git" ]]; then
      unresolved_git_root="$dir"
      break
    fi
    dir=$(dirname "$dir")
  done

  local target_dir="${unresolved_git_root:-$PWD}"
  local resolved_dir
  resolved_dir=$(realpath "${target_dir}" 2>/dev/null || readlink -f "${target_dir}" 2>/dev/null || echo "${target_dir}")

  local paths_to_trust=()
  if [[ "${target_dir}" == "${HOME}/repos/"* ]]; then
    paths_to_trust+=("${target_dir}")
  fi
  if [[ "${resolved_dir}" == "${HOME}/repos/"* ]]; then
    paths_to_trust+=("${resolved_dir}")
  fi

  if (( ${#paths_to_trust[@]} > 0 )); then
    local settings_file="${HOME}/.gemini/antigravity-cli/settings.json"
    if [[ -f "${settings_file}" ]]; then
      local tmp_file
      tmp_file=$(mktemp)
      if jq 'if .trustedWorkspaces then .trustedWorkspaces = (.trustedWorkspaces + $ARGS.positional | unique) else . + {trustedWorkspaces: $ARGS.positional} end' "${settings_file}" --args "${paths_to_trust[@]}" > "${tmp_file}" 2>/dev/null; then
        cat "${tmp_file}" > "${settings_file}"
      fi
      rm -f "${tmp_file}"
    fi
  fi
  command agy "$@"
}

