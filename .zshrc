# rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator_completion ]] && source $HOME/.tmuxinator/scripts/tmuxinator_completion

# Virtualenv & Virtualenvwrapper setup
VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/share/python/virtualenvwrapper.sh
export PIP_VIRTUALENV_BASE=$WORKON_HOME

# Set default Variables
export EDITOR=vim

# Homebrew added to my path
PATH=/usr/local/bin:/usr/local/share/python:$PATH

# tmux aliases
alias attach='tmux attach-session -t'
alias switch='tmux switch-session -t'
alias tmk='tmux kill-session -t'

# Django aliases
alias pm='python manage.py'

# Show completion on first TAB
setopt menucomplete

# Load completions for Ruby, Git, etc.
autoload compinit
compinit -C

# PROMPT FUNCTIONS AND SETTINGS #
#################################

# Case insensitive auto complete
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Colors
autoload -U colors && colors
setopt prompt_subst

# Display Virtualenv cleanly in right column
function virtualenv_info {
  [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`')'
}

# Display Rbenv cleanly if Rbenv is istalled
function rbenv_info {
  if which rbenv > /dev/null; then echo "$(rbenv version-name)"; fi
}

# Command Status
local command_status="%(?,%{$fg[green]%}✔%{$reset_color%},%{$fg[red]%}✘%{$reset_colors%})"

# Show relative path on one line, then command status
PROMPT='
%{$fg[cyan]%}%n %{$fg[white]%}: %{$fg[cyan]%}%~
${command_status} %{$reset_color%} '

# Add $(~/.rbenv/bin/rbenv version-name) to show rbenv version
RPROMPT='%{$fg[cyan]%}$(virtualenv_info)%{$fg[white]%}$(rbenv_info)$(~/bin/git-cwd-info.sh)%{$reset_colors%}'
