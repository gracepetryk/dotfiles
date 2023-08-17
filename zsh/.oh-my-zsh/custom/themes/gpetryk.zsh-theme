# vim:ft=zsh ts=2 sw=2 sts=2
#
function preexec_update_git_vars() {
  # refresh cache for common commands that change files
  case "$2" in
    git*|hub*|gh*|stg*|rm*|vim*|nvim*|touch*|*\>*|*tee*|*sed*|*gsed*|mv*|cp*)
      __EXECUTED_GIT_COMMAND=1
      ;;
  esac
}

# Must use Powerline font, for \uE0A0 to render.
ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}\uE0A0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{${reset_color}%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}%{󰩖 %G%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}−"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[green]%}+"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[yellow]%}⏺"
ZSH_THEME_GIT_PROMPT_CACHE=true

ZSH_THEME_RUBY_PROMPT_PREFIX="%{$fg_bold[red]%}‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"

function pyenv_prefix() {
  if [[ -n $VIRTUAL_ENV ]]; then
    echo "($(basename $VIRTUAL_ENV)) "
  fi
}

PROMPT='
%{$fg_bold[green]%}%~%{$reset_color%}$(git_super_status)
$(pyenv_prefix)%{$fg_bold[blue]%}%n%{$reset_color%}@%F{166%}%m%f %(?::%{$fg[red]%}[%?] )%{$reset_color%}$ '

RPROMPT=""
