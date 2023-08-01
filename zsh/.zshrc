if ! which gdate >/dev/null; then
  alias gdate=date
fi

local total=0
local start=$(gdate +%s.%N)

if [ -f "$HOME"/.env ]; then
  source "$HOME"/.env
fi

function print_ts() {
  if [[ ! ($log_zsh_start_perf -eq 1) ]] ; then
    return 0
  fi

  local t=$(gdate +%s.%N)
  local t_diff=$(( $t - $start ))

  start=$t
  total=$(( $total + $t_diff ))

  printf "%-16s\tdiff: %.3f\ttotal: %.3f\n" $1 $t_diff $total
}

export PATH=$HOME/bin:/usr/local/bin:$PATH
export DISABLE_UNTRACKED_FILES_DIRTY="true"

if [ -f /etc/zshrc ]; then
  source /etc/zshrc
fi

if which nvim &>/dev/null; then
  alias vim=nvim
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

plugins=(evalcache git-prompt zsh-nvm)
source "$ZSH"/oh-my-zsh.sh

print_ts oh-my-zsh

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

export FZF_DEFAULT_COMMAND="fd --hidden --no-ignore \
  -E '**/Library/*' \
  -E '**/node_modules/*' \
  -E '**/.docker/*' \
  -E '**/.cargo/*' \
  -E '**/.cache/*' \
  -E '**/.gem/*' \
  -E '**/.npm/*' \
  -E '**/.nvm/*' \
  -E '**/.pyenv/*' \
  -E '**/.rbenv/*' \
  -E '**/.rustup/*' \
  -E '**/.solargraph/*' \
  -E '**/.git/*' \
  -E '**/.deps/*' \
  -E '**/.vscode/*' \
  -E '.local/share/nvim/lazy' \
  -E 'pyright/*' \
  -E 'neovim/*' \
  -E 'typeshed/*' \
  -E 'mysterysci/*' \
  -E 'de-sandbox/apps/*/*'"

export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

print_ts 'done'


