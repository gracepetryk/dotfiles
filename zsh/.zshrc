# vim:ft=zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

export DISABLE_UNTRACKED_FILES_DIRTY="true"

# Add brew sbin to path
export PATH="$PATH:/usr/local/sbin"

# add firefox to path
export PATH="$PATH:/Applications/Firefox.app/Contents/MacOS"
export PATH="$HOME/bin:$PATH:$HOME/.local/bin"
export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46"


(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"


# zmodload zsh/zprof
# vim:ft=bash


if [ -f "$HOME"/.env ]; then
  source "$HOME"/.env
fi

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

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath+=/Users/GPetryk/.docker/completions
fpath+=/Users/GPetryk/.zfunc
autoload -Uz compinit
# End of Docker CLI completions

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


# set up fzf

FD="fd"
if ! which fd &>/dev/null; then
  alias fd=fdfind
  FD=fdfind
fi

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
  -E '**/apps/edde/*' "

export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

export VIRTUAL_ENV_DISABLE_PROMPT=1

jwt-decode() {
  jq -R 'split(".") |.[0:2] | map(gsub("-"; "+") | gsub("_"; "/") | gsub("%3D"; "=") | @base64d) | map(fromjson)' <<< $1
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [ -d "$HOME/profile.d" ]; then
  for RC_FILE in "$HOME"/profile.d/*.rc; do
    source "$RC_FILE"
  done
fi

existing_ls='ls'
if [[ ! -z "$(alias ls)" ]]; then
  existing_ls="$(alias ls | cut -d= -f2- | tr -d "'")"
fi

alias ls="$existing_ls \$LS_FLAGS "
if which nvim &>/dev/null; then
  alias vim=nvim
fi

bindkey "\e[1;3D" backward-word # ⌥←
bindkey "\e[1;3C" forward-word # ⌥→


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


alias flake_branch='flake8 $(git diff develop.. --name-only)'

eval "$(fnm env --use-on-cd)"

[[ -d ~/.cargo ]] && export PATH="$PATH:$HOME/.cargo/bin"

if which uv > /dev/null; then
  eval "$(uv generate-shell-completion zsh)"
fi


return 0
