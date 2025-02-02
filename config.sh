#!/bin/bash

# tmux-bash-history
if [[ -n "$TMUX" ]]; then
    # Optionally set a custom bash history home directory:
    # tmux set -g @bash-history-home "~/path/to/custom/dir"
    [ -f "$HOME/.config/tmux/plugins/tmux-bash-history/scripts/restore_history.sh" ] && . "$HOME/.config/tmux/plugins/tmux-bash-history/scripts/restore_history.sh"
fi

shopt -u progcomp

PS1="\[\033[01;33m\]\w\[\033[00m\] \$ "
