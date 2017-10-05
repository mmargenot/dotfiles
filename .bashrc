# show git branch
export TERM='xterm-256color'
export PS1="\u@\h \w \$(git branch 2>/dev/null | grep '^*' | colrm 1 2)\$ "

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
