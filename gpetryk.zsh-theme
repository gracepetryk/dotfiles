# vim:ft=zsh ts=2 sw=2 sts=2

# Must use Powerline font, for \uE0A0 to render.
ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}\uE0A0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{${reset_color}%}"
ZSH_THEME_GIT_PROMPT_CACHE=true

ZSH_THEME_RUBY_PROMPT_PREFIX="%{$fg_bold[red]%}‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"

PROMPT='
%{$fg_bold[green]%}%~%{$reset_color%}$(git_super_status)
%{$fg_bold[blue]%}%n%{$reset_color%}@%{$fg[blue]%}%m %(?::%{$fg[red]%}[%?] )%{$reset_color%}$ '

RPROMPT=""
