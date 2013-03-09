# ENVIRONMENT VARIABLES #
#########################

# No brainer, default to Vim
export EDITOR="vim"

# Color LS output to differentiate between directories and files
export LS_OPTIONS="--color=auto"
export CLICOLOR="Yes"
export LSCOLOR=""

# Speed up the rubies
export RUBY_GC_MALLOC_LIMIT=60000000
export RUBY_FREE_MIN=200000

# Setup PATH
export PATH=$HOME/.rbenv/bin:$HOME/bin:$PATH
export PATH=/usr/local/bin:/usr/local/share/python:$PATH

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
alias grpr='git remote prune origin'

# tmux
alias start='tmuxinator start'
alias attach='tmux attach-session -t'
alias switch='tmux switch-session -t'
alias tmk='tmux kill-session -t'
alias tls='tmux ls'

# Django
alias pm='python manage.py'

# Server fanciness with python
alias server='open http://localhost:1337/ && python -m SimpleHTTPServer 1337'

# Ruby REPLs & Pry for Rails
alias pryr='pry --simple-prompt -r ./config/environment'

# Xcode
alias pngcrush='/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/pngcrush -q -revert-iphone-optimizations -d'

# Quick way to rebuild the Launch Services database and get rid
# of duplicates in the Open With submenu.
alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'

# ZSH CONFIGURATION #
#####################

# Turn off Vi mode
bindkey -e

# Source zsh syntax highlighting
source $HOME/bin/zsh-syntax-highlighting.zsh

# Source Tmuxinator if installed
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

# Virtualenv & Virtualenvwrapper setup if installed
VIRTUAL_ENV_DISABLE_PROMPT=1
if which virtualenv > /dev/null;
then
  VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
  export WORKON_HOME=$HOME/.virtualenvs
  source /usr/local/share/python/virtualenvwrapper.sh
  export PIP_VIRTUALENV_BASE=$WORKON_HOME
fi

# Load completions for Ruby, Git, etc.
autoload compinit && compinit -C

# Case insensitive auto-complete
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# PROMPT FUNCTIONS AND SETTINGS #
#################################

# Colors
autoload -U colors && colors
setopt prompt_subst

# Allow rbenv if it's installed (which it should be!)
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Display Virtualenv cleanly in right column
function virtualenv_info {
  [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

# Display wheather you are in a Git or Mercurial repo
function prompt_char {
  git branch >/dev/null 2>/dev/null && echo ' ±' && return
  hg root >/dev/null 2>/dev/null && echo ' ☿' && return
  echo ' ○'
}

# Display Rbenv cleanly if Rbenv is installed
function rbenv_info {
  if which rbenv > /dev/null; then echo "$(rbenv version-name)"; fi
}

# Show previous command status
local command_status="%(?,%{$fg[green]%}✔%{$reset_color%},%{$fg[red]%}✘%{$reset_colors%})"

# Show relative path on one line, then command status
PROMPT='
%{$fg[cyan]%}%n@%m %{$fg[white]%}: %{$fg[cyan]%}%~ %{$fg[white]%}
${command_status} %{$reset_color%} '

# Show virtualenv, rbenv, branch, sha, and repo dirty status on right side
RPROMPT='%{$fg[cyan]%}$(virtualenv_info)%{$fg[white]%}$(rbenv_info)$(prompt_char)$(~/bin/git-cwd-info.sh)%{$reset_colors%}'

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
