# ENVIRONMENT VARIABLES #
########################

# This file only exists so that Vim can read it and know my aliases

# Setup PATH to use /usr/local first so Homebrew installs
# are used instead of system installs
export PATH=$HOME/bin:/usr/local/bin:/usr/local/share/python:$PATH

# ALIASES #
###########

# Standard Shell
alias c='clear'
alias l='ls -l'
alias la='ls -al'

# Bundle Exec
alias be="bundle exec"

# Git
alias g='git status -s'
alias gb='git branch'
alias gba='git branch -a'
alias gc='git commit -m'
alias gca='git commit -am'
alias gco='git checkout'
alias gcob='git checkout -b'

# tmux
alias start='tmuxinator start'
alias attach='tmux attach-session -t'
alias switch='tmux switch-session -t'
alias tmk='tmux kill-session -t'

# Django
alias pm='python manage.py'

# Server fanciness with python
alias server='open http://localhost:1337/ && python -m SimpleHTTPServer 1337'

# Ruby REPLs & Pry for Rails
alias pryr='pry --simple-prompt -r ./config/environment'
