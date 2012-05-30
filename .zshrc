# rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# Alias hub
eval "$(hub alias -s)"

# tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

# Virtualenv & Virtualenvwrapper setup
VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/share/python/virtualenvwrapper.sh
export PIP_VIRTUALENV_BASE=$WORKON_HOME

# Set default Variables
export EDITOR=vim

# Set directory and file colors for ls
# export LS_OPTIONS='--color=auto'
# export CLICOLOR='Yes'
# export LSCOLORS=''

# Homebrew added to my path
PATH=/usr/local/bin:/usr/local/share/python:$PATH

# tmux aliases
alias attach='tmux attach-session -t'
alias switch='tmux switch-session -t'
alias tmk='tmux kill-session -t'

# Django aliases
alias pm='python manage.py'

# Colors
autoload -U colors
colors
setopt prompt_subst

# Smiley
local smiley="%(?,%{$fg[green]%}✔%{$reset_color%},%{$fg[red]%}✘%{$reset_colors%})"

# Show relative path on one line, then smiley
PROMPT='
%{$fg[cyan]%}%n %{$fg[white]%}: %{$fg[cyan]%}%~
${smiley} %{$reset_color%} '

RPROMPT='%{$fg[white]%} $(~/bin/git-cwd-info.sh)%{$reset_colors%}'

# Show completion on first TAB
setopt menucomplete

# Load completions for Ruby, Git, etc.
autoload compinit
compinit
