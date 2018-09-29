# check current system
is_linux=false
[[ "$(uname -s)" =~ Linux|GNU|GNU/* ]] && is_linux=true

is_mac=false
[[ "$(uname -s)" =~ Darwin ]] && is_mac=true

# show git branch
export TERM='xterm-256color'
export PS1="\u@\h \W \$(git branch 2>/dev/null | grep '^*' | colrm 1 2)\$ "
# git autocomplete (some linux distros)
$is_linux && source /usr/share/bash-completion/completions/git

# history settings
shopt -s histappend
export HISTCONTROL=ignoreboth
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
export HISTSIZE=100000
export SAVEHIST=100000
export HISTTIMEFORMAT="%d/%m/%y %T "
export HISTFILE=~/.bash_history

# conveniences
  # autocolor {{{
    alias ls='ls -G'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
  # }}}
  # modified commands {{{
    alias ..='cd ..'
    alias ping='ping -c 10'
  # }}}
  # ls {{{
    alias lr='ls -R'
    alias ll='ls -alh'
    alias la='ls -Alh'
    alias lr='ls -R'
  # }}}

  # extra goodies
    alias vim-find='vim -o $(find . -iname "$@")' # open all files matching pattern in split 
