#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PID_FILE="$SCRIPT_DIR/.comfyui.pid"
LOG_FILE="$SCRIPT_DIR/comfyui.log"

if [[ -f "$PID_FILE" ]]; then
    pid="$(<"$PID_FILE")"
    if [[ "$pid" =~ ^[0-9]+$ ]] && kill -0 "$pid" 2>/dev/null; then
        echo "ComfyUI is already running (PID $pid)."
        exit 1
    fi
    rm -f "$PID_FILE"
fi

cd "$SCRIPT_DIR" || exit 1
nohup "$SCRIPT_DIR/venv/bin/python3" main.py --listen 0.0.0.0 --port 8188 \
    >>"$LOG_FILE" 2>&1 </dev/null &
pid=$!
echo "$pid" >"$PID_FILE"

echo "ComfyUI started (PID $pid). Log: $LOG_FILE"
