#!/bin/bash
if [ -z "$SVC_NAME" ]; then
    echo "Error: SVC_NAME is not set."
    exit 1
fi

MOUNT_DIR="/mnt/${SVC_NAME}_tmp"

echo "--- Setting up tmpfs at $MOUNT_DIR ---"

if mount | grep -q "$MOUNT_DIR"; then
    echo "tmpfs already mounted. Skipping."
else
    sudo mkdir -p "$MOUNT_DIR"
    sudo mount -t tmpfs -o size=256M tmpfs "$MOUNT_DIR"
    echo "tmpfs mounted."
fi

sudo chown "$SVC_NAME:$SVC_NAME" "$MOUNT_DIR"
echo "Ownership set."

df -h "$MOUNT_DIR"
