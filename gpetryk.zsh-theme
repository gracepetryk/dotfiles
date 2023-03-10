# vim:ft=zsh ts=2 sw=2 sts=2

# Must use Powerline font, for \uE0A0 to render.
ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}\uE0A0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{${reset_color}%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}%{<3%G%}"
ZSH_THEME_GIT_PROMPT_CACHE=true

ZSH_THEME_RUBY_PROMPT_PREFIX="%{$fg_bold[red]%}‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"

function pyenv_prefix() {
  if [[ -n $VIRTUAL_ENV ]]; then
    echo "($(basename $VIRTUAL_ENV)) "
  fi
}

PROMPT='
%{$fg_bold[cyan]%}%~%{$reset_color%}$(git_super_status)
$(pyenv_prefix)%{$fg_bold[blue]%}%n%{$reset_color%}@%F{166%}%m%f %(?::%{$fg[red]%}[%?] )%{$reset_color%}$ '

RPROMPT=""
