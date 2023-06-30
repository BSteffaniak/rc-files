#!/bin/bash

# History control

# initialization
if ((HISTINIT > 0)); then
    return 0
fi

export HISTINIT=0
export NO_LOG_COMMAND='true'

# avoid duplicates..
export HISTCONTROL=ignoredups:erasedups

HISTS_DIR=$HOME/.bash_history.d
mkdir -p "${HISTS_DIR}"

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$CURRENT_DIR/history_helpers.sh"

function initHist() {
    echo "" >"$(getCmdFile "$TMUX_PANE")"

    HISTFILE=$(getHistFile "$TMUX_PANE")
    # Only load history on the second call of this function (first time HISTINIT should be 0)
    if ((HISTINIT == 1)); then
        echo "Restoring history from histfile $HISTFILE"
        # Write out any initial command given before we load the histfile
        history -a
        # Clear and read the history from disk
        history -c
        history -r
        HISTFILE_LOADED=$HISTFILE
    fi
    if [[ -n "${HISTFILE_LOADED}" && "$HISTFILE" != "$HISTFILE_LOADED" ]]; then
        echo "histfile changed to $HISTFILE"
        # History file changed (pane/window moved), write out history to new file
        history -w
        HISTFILE_LOADED=$HISTFILE
    fi
    if ((HISTINIT <= 1)); then
        ((HISTINIT += 1))
    fi
}

initHist

function process_command() {
    if [ -n "$NO_LOG_COMMAND" ] || [ "$BASH_COMMAND" == "export NO_LOG_COMMAND='true'" ]; then
        return
    fi

    echo "$BASH_COMMAND" >"$(getCmdFile "$TMUX_PANE")"
}
trap process_command DEBUG

# After each command, save history
PROMPT_COMMAND="export NO_LOG_COMMAND='true'; initHist; history -a; unset NO_LOG_COMMAND; $PROMPT_COMMAND"
