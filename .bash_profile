source $HOME/.bashrc
if [ -e /Users/keith/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/keith/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
if [[ -f /opt/dev/dev.sh ]]; then source /opt/dev/dev.sh; fi
. "$HOME/.cargo/env"

# Added by tec agent
[[ -x /Users/keith/.local/state/tec/profiles/base/current/global/init ]] && eval "$(/Users/keith/.local/state/tec/profiles/base/current/global/init bash)"
