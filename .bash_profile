source $HOME/.bashrc
if [ -e /Users/keith/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/keith/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
if [[ -f /opt/dev/dev.sh ]]; then source /opt/dev/dev.sh; fi
