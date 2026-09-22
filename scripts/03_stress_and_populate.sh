#!/bin/bash
if [ -z "$SVC_NAME" ]; then
    echo "Error: SVC_NAME is not set."
    exit 1
fi

MOUNT_DIR="/mnt/${SVC_NAME}_tmp"

# --- 3.1 Fill the disk ---
echo "=== 3.1 Filling the disk ==="
echo "--- BEFORE ---"
df -h "$MOUNT_DIR"

for i in $(seq 1 30); do
    sudo dd if=/dev/urandom of="$MOUNT_DIR/file_$i.dat" bs=1M count=10 status=none
done

echo "--- AFTER ---"
df -h "$MOUNT_DIR"

# --- 3.2 CPU Stress ---
echo "=== 3.2 CPU Stress ==="
sudo -u "$SVC_NAME" stress-ng --cpu 2 --timeout 30s

# --- 3.3 Memory Stress ---
echo "=== 3.3 Memory Stress ==="
echo "--- free -h BEFORE memory stress ---"
free -h
sudo -u "$SVC_NAME" stress-ng --vm 1 --vm-bytes 200M --timeout 30s
echo "--- free -h AFTER memory stress ---"
free -h

# --- 3.4 Combined Stress ---
echo "=== 3.4 Combined Stress ==="
echo "--- free -h DURING combined stress ---"
sudo -u "$SVC_NAME" stress-ng --cpu 2 --vm 1 --vm-bytes 200M --hdd 1 --timeout 30s &
STRESS_PID=$!
sleep 5
free -h
echo "--- Waiting for stress to finish ---"
wait $STRESS_PID

echo "--- free -h AFTER combined stress ---"
free -h

echo "=== Checking for OOM Killer ==="
sudo dmesg | grep -i oom || echo "No OOM events detected (empty result is valid)."
