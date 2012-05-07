# rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

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
export LS_OPTIONS='--color=auto'
export CLICOLOR='Yes'
export LSCOLORS=''

# Homebrew added to my path
PATH=/usr/local/bin:/usr/local/share/python:$PATH

# tmux aliases
alias attach='tmux attach-session -t'
alias switch='tmux switch-session -t'
alias tmk='tmux kill-session -t'

# Django aliases
alias pm='python manage.py'

# Allow for case insensitive terminal (for cd, ls, etc)
bind "set completion-ignore-case on"

# Segment customizing the look and feel of the prompt
# This first block sets up custom colors that can be used
txtblu='\e[0;34m' # Blue
txtcyn='\e[0;36m' # Cyan
txtrst='\e[0m'    # Text Reset

# Set up prompt format and git awareness
print_before_the_prompt () {
  printf "\n$txtblu%s: $txtcyn%s\n$txtrst" "$USER" "$PWD"
}
parse_git_dirty () {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
parse_git_branch () {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}
PROMPT_COMMAND=print_before_the_prompt
PS1="\$([[ -n \$(git branch 2> /dev/null) ]] && echo \"[\")\[$txtblu\]\$(parse_git_branch)\[$txtrst\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \"]\")-> "
