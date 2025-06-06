source $HOME/.shell_defaults

# ZSH CONFIGURATION #
#####################

# Turn off Vi mode
bindkey -e

# Load completions for Ruby, Git, etc.
autoload compinit && compinit -C

# Make git completions not be ridiculously slow
__git_files () {
  _wanted files expl 'local files' _files
}

# Case insensitive auto-complete
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# PROMPT FUNCTIONS AND SETTINGS #
#################################

# Colors
autoload -U colors && colors
setopt prompt_subst

# Display wheather you are in a Git or Mercurial repo
function prompt_char {
  git branch >/dev/null 2>/dev/null && echo ' ±' && return
  hg root >/dev/null 2>/dev/null && echo ' ☿' && return
  echo ' ○'
}

# Display current ruby version
function ruby_info {
  if command -v ruby &> /dev/null; then
    echo "$(ruby -v | sed 's/.* \([0-9p\.]*\) .*/\1/')"
  else
    echo ""
  fi
}

# Show previous command status
local command_status="%(?,%{$fg[green]%}✔%{$reset_color%},%{$fg[red]%}✘%{$reset_colors%})"

# Show relative path on one line, then command status
PROMPT='
%{$fg[cyan]%}%n@%m %{$fg[white]%}: %{$fg[cyan]%}%~ %{$fg[white]%}
${command_status} %{$reset_color%} '

# Show ruby, branch, sha, and repo dirty status on right side
RPROMPT='%{$fg[white]%}$(ruby_info)$(prompt_char)$(git-cwd-info.sh)%{$reset_colors%}'

if [ -e /Users/keith/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/keith/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

[[ -x /usr/local/bin/brew ]] && eval $(/usr/local/bin/brew shellenv)

[[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)

[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh

[[ -f /opt/dev/sh/chruby/chruby.sh ]] && { type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; } }

# pnpm
export PNPM_HOME="/var/home/keith/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Task Master aliases added on 4/14/2025
alias tm='task-master'
alias taskmaster='task-master'

# cloudplatform: add Shopify clusters to your local kubernetes config
export KUBECONFIG=${KUBECONFIG:+$KUBECONFIG:}/Users/keith/.kube/config:/Users/keith/.kube/config.shopify.cloudplatform
