export PS1="\u@\h \w \$(git branch 2>/dev/null | grep '^*' | colrm 1 2) \$ "
