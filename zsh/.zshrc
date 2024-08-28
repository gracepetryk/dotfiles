# vim:ft=bash

if ! which gdate >/dev/null; then
  alias gdate=date
fi

local total=0
local start=$(gdate +%s.%N)

if [ -f "$HOME"/.env ]; then
  source "$HOME"/.env
fi

log_zsh_start_perf=0
function print_ts() {
  if [[ ! ($log_zsh_start_perf -eq 1) ]] ; then
    return 0
  fi

  if [[ $2 ]]; then
    total=0
    start=$(gdate +%s.%N)
  fi

  local t=$(gdate +%s.%N)
  local t_diff=$(( $t - $start ))

  start=$t
  total=$(( $total + $t_diff ))

  printf "%-16s\tdiff: %.3f\ttotal: %.3f\n" $1 $t_diff $total
}

print_ts start

export PATH=$HOME/bin:/usr/local/bin:/snap/bin:$PATH
export DISABLE_UNTRACKED_FILES_DIRTY="true"

if [ -f /etc/zshrc ]; then
  source /etc/zshrc
fi

if which nvim &>/dev/null; then
  alias vim=nvim
fi

FD="fd"
if ! which fd &>/dev/null; then
  alias fd=fdfind
  FD=fdfind
fi

if [ "$IS_DOCKER_SANDBOX" = "" ]; then
    ZSH_THEME="gpetryk"
else
    ZSH_THEME="gpetryk-docker"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

export NVM_LAZY_LOAD=true
export NVM_LAZY_LOAD_EXTRA_COMMANDS=('nvim')

plugins=(evalcache git-prompt)
source "$ZSH"/oh-my-zsh.sh

print_ts oh-my-zsh


# speed up cd when not in a git directory
add-zsh-hook -D chpwd chpwd_update_git_vars

local git_dir
gpetryk_chpwd_udpate_git_vars() {
  print_ts git_vars

  new_git_dir="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [[ "$git_dir" != "$new_git_dir" ]]; then
    git_dir=$new_git_dir
    chpwd_update_git_vars
  fi

  print_ts git_vars_done
}

add-zsh-hook precmd gpetryk_chpwd_udpate_git_vars

if [ -d "$HOME/profile.d" ]; then
  for RC_FILE in "$HOME"/profile.d/*.rc; do
    source "$RC_FILE"
    print_ts $(basename $RC_FILE)
  done
fi

print_ts profile

source "$ZSH_CUSTOM/themes/$ZSH_THEME".zsh-theme # ensure prompt is not overwritten by profile

print_ts theme

bindkey "\e[1;3D" backward-word # ⌥←
bindkey "\e[1;3C" forward-word # ⌥→

# Add brew sbin to path
export PATH="$PATH:/usr/local/sbin"

# add firefox to path
export PATH="$PATH:/Applications/Firefox.app/Contents/MacOS"
export PATH="$HOME/bin:$PATH:$HOME/.local/bin"
export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46"

# render git prompt if starting in a git directory
if [[ -d ./.git ]]; then
  cd .
fi

print_ts chpwd

bat="bat"
if which batcat > /dev/null; then
  alias bat=batcat
  bat="batcat"
fi

if which bat > /dev/null; then
  alias cat=bat
  export BAT_THEME="TwoDark"
  export MANPAGER="sh -c 'col -bx | $bat -plman'"

  help() {
    "$@" --help 2>&1 | bat -plhelp
  }
fi


timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do time $shell -i -c exit; done
}

alias flake_branch='flake8 $(git diff develop.. --name-only)'

# set up fzf

export PATH=$PATH:$HOME/.fzf/bin
source <(fzf --zsh)

export FZF_COMPLETION_TRIGGER='!!'
export FZF_DEFAULT_COMMAND="$FD --hidden --no-ignore \
  -E '**/Library/*' \
  -E '**/node_modules/*' \
  -E '**/.docker/*' \
  -E '**/.cargo/*' \
  -E '**/.cache/*' \
  -E '**/.gem/*' \
  -E '**/.npm/*' \
  -E '**/.pyenv/*' \
  -E '**/.rbenv/*' \
  -E '**/.rustup/*' \
  -E '**/.solargraph/*' \
  -E '**/.git/*' \
  -E '**/.deps/*' \
  -E '**/.vscode/*' \
  -E '**/.local/share/nvim/lazy/*' \
  -E '**/httpd-venvs/*' \
"

export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d \
  -E 'pyright/*' \
  -E 'neovim/*' \
  -E 'typeshed/*' \
  -E 'mysterysci/*' \
  -E 'de-sandbox/apps/*/*'
"

export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

_fzf_compgen_path() {
  eval $FZF_DEFAULT_COMMAND . "$1"
}

_fzf_compgen_dir() {
  eval $FZF_DEFAULT_COMMAND --type "d" . "$1"
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

print_ts 'done'

if [[ -d "$HOME/.nvm" ]]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi
