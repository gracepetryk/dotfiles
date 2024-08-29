# vim:ft=zsh ts=2 sw=2 sts=2
#
function preexec-git-info() {
  # refresh cache for common commands that change files
  case "$2" in
    git*|hub*|gh*|stg*|rm*|vim*|nvim*|touch*|*\>*|*tee*|*sed*|*gsed*|mv*|cp*)
      __EXECUTED_GIT_COMMAND=1
      ;;
  esac
}

function precmd-git-info() {
  # refresh cache for common commands that change files
  if [[ $__EXECUTED_GIT_COMMAND = 1 ]]; then
    __EXECUTED_GIT_COMMAND=0
    git-info
  fi
}

autoload -Uz add-zsh-hook
autoload colors && colors
# Depends on duration-info module to show last command duration
if (( ${+functions[duration-info-preexec]} && \
    ${+functions[duration-info-precmd]} )); then
    zstyle ':zim:duration-info' show-milliseconds yes
    zstyle ':zim:duration-info' format 'took %B%F{yellow}%d%b%f'
  add-zsh-hook preexec duration-info-preexec
  add-zsh-hook precmd duration-info-precmd
fi

# Depends on git-info module to show git information
typeset -gA git_info
if (( ${+functions[git-info]} )); then
  zstyle ':zim:git-info:clean' format '%{$fg[green]%}%{󰩖 %G%}'
  zstyle ':zim:git-info:branch' format '%b'
  zstyle ':zim:git-info:commit' format 'HEAD (%c)'
  zstyle ':zim:git-info:action' format '%F{yellow}(${(U):-%s})'
  zstyle ':zim:git-info:stashed' format '%{$fg_bold[blue]%}%{⚑%G%}%S'
  zstyle ':zim:git-info:unindexed' format '%{$fg[green]%}~'
  zstyle ':zim:git-info:indexed' format '%{$fg[yellow]%}●'
  zstyle ':zim:git-info:untracked' format '%{$fg[cyan]%}%{…%G%}%u'
  zstyle ':zim:git-info:ahead' format '%{${reset_color}%}%{↑%G%}%A'
  zstyle ':zim:git-info:behind' format '%{↓%G%}%B'
  zstyle ':zim:git-info:keys' format \
      'status' '%C%S%i%I%u' \
      'prompt' ' on %{$fg[magenta]%} %c%b%{${reset_color}%}%A%B%{${reset_color}%}|${(e)git_info[status]}%s%f'
  add-zsh-hook chpwd git-info
  add-zsh-hook preexec preexec-git-info
  add-zsh-hook precmd precmd-git-info
fi

git-info

function pyenv_prefix() {
  if [[ -n $VIRTUAL_ENV ]]; then
    echo "($(basename $VIRTUAL_ENV)) "
  fi
}

PROMPT='
%{$fg_bold[green]%}%~%{$reset_color%}${(e)git_info[prompt]} ${duration_info}
%{$reset_color%}$(pyenv_prefix)%{$fg_bold[blue]%}%n%{$reset_color%}@%F{166%}%m%{${reset_color}%} %(?::%{$fg[red]%}[%?] )%{$reset_color%}$ '

RPROMPT=''
