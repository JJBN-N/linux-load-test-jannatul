#!/bin/bash
if [ -z "$SVC_NAME" ]; then
    echo "Error: SVC_NAME is not set."
    exit 1
fi

MOUNT_DIR="/mnt/${SVC_NAME}_tmp"
LOG_DIR="/var/log/${SVC_NAME}"

echo "--- Starting Cleanup for $SVC_NAME ---"

# 1. Kill processes
echo "Killing processes..."
sudo pkill -u "$SVC_NAME" 2>/dev/null || true

# 2. Remove automation
echo "Removing cron jobs and scripts..."
sudo crontab -r -u "$SVC_NAME" 2>/dev/null || true
sudo rm -f /etc/logrotate.d/"$SVC_NAME"
sudo rm -f /usr/local/bin/"${SVC_NAME}_monitor.sh"
sudo rm -f /usr/local/bin/"${SVC_NAME}_cleanup_old_files.sh"

# 3. Unmount storage
echo "Unmounting tmpfs..."
if mount | grep -q "$MOUNT_DIR"; then
    sudo umount "$MOUNT_DIR" || sudo umount -l "$MOUNT_DIR"
fi
sudo rmdir "$MOUNT_DIR" 2>/dev/null || true

# 4. Remove logs
echo "Removing log directory..."
sudo rm -rf "$LOG_DIR"

# 5. Remove user
echo "Removing user $SVC_NAME..."
sudo userdel -r "$SVC_NAME" 2>/dev/null || true

echo "--- Verification ---"
echo "1. id $SVC_NAME (should fail):"
id "$SVC_NAME" 2>&1 || echo "  ✅ User $SVC_NAME does not exist. (PASS)"
echo "2. mount | grep $SVC_NAME (should return nothing):"
mount | grep "$SVC_NAME" || echo "  ✅ No mount found. (PASS)"
echo "3. ps -u $SVC_NAME (should be empty):"
ps -u "$SVC_NAME" || echo "  ✅ No processes found. (PASS)"
