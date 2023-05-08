# History control

# avoid duplicates..
export HISTCONTROL=ignoredups:erasedups

HISTS_DIR=$HOME/.bash_history.d
mkdir -p "${HISTS_DIR}"

function getHistFile() {
        if [ -n "${TMUX_PANE}" ]; then
                echo "${HISTS_DIR}/bash_history_tmux_$(tmux display-message -t $TMUX_PANE -p '#S:#I:#P')"
        else
                echo "${HISTS_DIR}/bash_history_no_tmux"
        fi
}

function initHist() {
        HISTFILE=$(getHistFile)
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

# initialization
HISTINIT=0

initHist

# After each command, save history
PROMPT_COMMAND="initHist; history -a; $PROMPT_COMMAND"
