#!/bin/bash
if [ -z "$SVC_NAME" ]; then
    echo "Error: SVC_NAME is not set. Run: export SVC_NAME=bgdsvc_<nickname>"
    exit 1
fi

echo "--- Creating service account: $SVC_NAME ---"

if id "$SVC_NAME" &>/dev/null; then
    echo "User $SVC_NAME already exists. Skipping."
else
    sudo useradd -r -m -s /usr/sbin/nologin "$SVC_NAME"
    echo "User created."
fi

echo "--- ID Verification ---"
id "$SVC_NAME"
echo "--- Password Entry ---"
getent passwd "$SVC_NAME"
