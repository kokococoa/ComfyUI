#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PID_FILE="$SCRIPT_DIR/.comfyui.pid"

if [[ ! -f "$PID_FILE" ]]; then
    echo "ComfyUI is not running."
    exit 0
fi

pid="$(<"$PID_FILE")"
if [[ ! "$pid" =~ ^[0-9]+$ ]] || ! kill -0 "$pid" 2>/dev/null; then
    rm -f "$PID_FILE"
    echo "ComfyUI is not running; removed stale PID file."
    exit 0
fi

kill "$pid"
for _ in {1..50}; do
    if ! kill -0 "$pid" 2>/dev/null; then
        rm -f "$PID_FILE"
        echo "ComfyUI stopped."
        exit 0
    fi
    sleep 0.1
done

kill -KILL "$pid"
rm -f "$PID_FILE"
echo "ComfyUI stopped."
