#!/bin/bash
SVC_NAME="bgdsvc_jannatul"
TMPDIR="/mnt/${SVC_NAME}_tmp"
LOG_FILE="/var/log/${SVC_NAME}/monitor.log"

mkdir -p "$(dirname "$LOG_FILE")"
find "$TMPDIR" -type f -mtime +1 -delete
echo "$(date): cleanup run - removed old files from $TMPDIR" >> "$LOG_FILE"
