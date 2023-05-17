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

function getCmdFile() {
  if [ -n "${TMUX_PANE}" ]; then
    echo "${HISTS_DIR}/bash_cmd_tmux_$(tmux display-message -t $TMUX_PANE -p '#S:#I:#P')"
  else
    echo "${HISTS_DIR}/bash_cmd_no_tmux"
  fi
}

function initHist() {
  echo "" > $(getCmdFile)

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
export NO_LOG_COMMAND='true'

initHist

function process_command() {
  if [ ! -z "$NO_LOG_COMMAND" ] || [ "$BASH_COMMAND" == "export NO_LOG_COMMAND='true'" ]; then
    return
  fi

  echo "$BASH_COMMAND" > $(getCmdFile)
}
trap process_command DEBUG

# After each command, save history
PROMPT_COMMAND="export NO_LOG_COMMAND='true'; initHist; history -a; unset NO_LOG_COMMAND; $PROMPT_COMMAND"
