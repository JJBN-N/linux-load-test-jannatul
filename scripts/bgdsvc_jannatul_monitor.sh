#!/bin/bash
SVC_NAME="bgdsvc_jannatul"
LOG_FILE="/var/log/${SVC_NAME}/monitor.log"

mkdir -p "$(dirname "$LOG_FILE")"
echo "--- $(date) ---" >> "$LOG_FILE"
free -h >> "$LOG_FILE"
df -h "/mnt/${SVC_NAME}_tmp" >> "$LOG_FILE" 2>&1
ps -u "$SVC_NAME" >> "$LOG_FILE" 2>&1
