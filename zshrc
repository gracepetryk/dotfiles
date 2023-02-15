export PATH=$HOME/bin:/usr/local/bin:$PATH

if [ -f $HOME/.env ]; then
  source ~/.env
fi

if [ -f /etc/zshrc ]; then
  source /etc/zshrc
fi

if [ $(which nvim) ]; then
  alias vim=nvim
fi

if [ -z "$IS_DOCKER_SANDBOX" ]; then
    ZSH_THEME="gpetryk"
else
    ZSH_THEME="gpetryk-docker"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

plugins=(evalcache git-prompt)
source $ZSH/oh-my-zsh.sh

if [ -d "$HOME/profile.d" ]; then
  for RC_FILE in $HOME/profile.d/*.rc; do source $RC_FILE; done
fi

# homebrew completions
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

# Add brew sbin to path
export PATH="$PATH:/usr/local/sbin"

# add firefox to path
export PATH="$PATH:/Applications/Firefox.app/Contents/MacOS"

export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46"

# render git prompt if starting in a git directory
cd .
