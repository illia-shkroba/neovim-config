#!/usr/bin/env sh

set -eu

SCRIPT_DIR=$(dirname "$(realpath -s "$0")")
SESSION_NAME=$(basename "$SCRIPT_DIR")

switch() {
  if [ "${TMUX:-}" ]; then
    tmux switch-client -t "$1"
  else
    tmux attach-session -t "$1"
  fi
}

if tmux has-session -t "$SESSION_NAME" 2> /dev/null; then
  switch "$SESSION_NAME"
  exit 0
fi

# Main Window
tmux new-session -d -c "$SCRIPT_DIR" -n 'main' -s "$SESSION_NAME"
tmux send-keys -t "$SESSION_NAME": ' nvim' 'C-m'

# Secondary Window
tmux new-window -a -d -c "$SCRIPT_DIR" -n 'secondary' -t "$SESSION_NAME":1
tmux send-keys -t "$SESSION_NAME":2.0 ' echo 1' 'C-m'

tmux split-window -d -c "$SCRIPT_DIR" -t "$SESSION_NAME":2.0
tmux send-keys -t "$SESSION_NAME":2.1 ' echo 2' 'C-m'

# Startup Window
tmux new-window -a -d -c "$SCRIPT_DIR" -n 'startup' -t "$SESSION_NAME":2 'sleep 3'

switch "$SESSION_NAME"
