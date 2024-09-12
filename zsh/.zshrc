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

if [ -f /etc/zshrc ]; then
  source /etc/zshrc
fi

# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# -----------------
# Zim configuration
# -----------------

# Use degit instead of git as the default tool to install and update modules.
#zstyle ':zim:zmodule' use 'degit'

# --------------------
# Module configuration
# --------------------

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
#zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

export PATH=$HOME/bin:/usr/local/bin:/snap/bin:$PATH
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key
# }}} End configuration added by Zim install

export DISABLE_UNTRACKED_FILES_DIRTY="true"

existing_ls='ls'
if [[ ! -z "$(alias ls)" ]]; then
  existing_ls="$(alias ls | cut -d= -f2- | tr -d "'")"
fi

alias ls="$existing_ls \$LS_FLAGS "
if which nvim &>/dev/null; then
  alias vim=nvim
fi

FD="fd"
if ! which fd &>/dev/null; then
  alias fd=fdfind
  FD=fdfind
fi

print_ts oh-my-zsh

print_ts profile

bindkey "\e[1;3D" backward-word # ⌥←
bindkey "\e[1;3C" forward-word # ⌥→

# Add brew sbin to path
export PATH="$PATH:/usr/local/sbin"

# add firefox to path
export PATH="$PATH:/Applications/Firefox.app/Contents/MacOS"
export PATH="$HOME/bin:$PATH:$HOME/.local/bin"
export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46"

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
  -E 'mysterysci/*' "

export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

_fzf_compgen_path() {
  eval $FZF_CTRL_T_COMMAND . $1
}

_fzf_compgen_dir() {
  eval $FZF_ALT_C_COMMAND . $1
}

print_ts 'done'

if [[ -d "$HOME/.nvm" ]]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

zvm_after_init_commands+=('[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh')

if [ -d "$HOME/profile.d" ]; then
  for RC_FILE in "$HOME"/profile.d/*.rc; do
    source "$RC_FILE"
    print_ts $(basename $RC_FILE)
  done
fi
