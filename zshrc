export PATH=$HOME/bin:/usr/local/bin:$PATH

if [ -f "$HOME"/.env ]; then
  source "$HOME"/.env
fi

if [ -f /etc/zshrc ]; then
  source /etc/zshrc
fi

if which nvim &>/dev/null; then
  alias vim=nvim
fi

plugins=()
if [ "$IS_DOCKER_SANDBOX" = "" ]; then
    ZSH_THEME="gpetryk"
    export NVM_AUTO_USE=true
    export NVM_LAZY_LOAD=true
    export NVM_COMPLETION=true
    plugins+=(zsh-nvm)
else
    ZSH_THEME="gpetryk-docker"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

plugins+=(evalcache git-prompt)
source "$ZSH"/oh-my-zsh.sh

if [ -d "$HOME/profile.d" ]; then
  for RC_FILE in "$HOME"/profile.d/*.rc; do source "$RC_FILE"; done
fi

source "$ZSH_CUSTOM/themes/$ZSH_THEME".zsh-theme # ensure prompt is not overwritten by profile

# homebrew completions
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

bindkey "\e[1;3D" backward-word # ⌥←
bindkey "\e[1;3C" forward-word # ⌥→

# Add brew sbin to path
export PATH="$PATH:/usr/local/sbin"

# add firefox to path
export PATH="$PATH:/Applications/Firefox.app/Contents/MacOS"

export PATH="$HOME/bin:$PATH"

export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46"

# render git prompt if starting in a git directory
cd .

timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}
