#### Observations

**Assignment:** Linux Load Test — BongoDev
**Service Account:** `bgdsvc_jannatul`
**Environment:** Ubuntu, Linux

## 1. Environment Setup

Before running the tests, I exported my service name so every script could reference it:

```
export SVC_NAME=bgdsvc_jannatul
echo $SVC_NAME
# Output: bgdsvc_jannatul
The id output after user creation confirmed the account was a proper system account with a non-login shell. 

Key takeaway: The -r flag (system user) and /usr/sbin/nologin shell mean this account can never be used for interactive login — exactly what we want for a service account.

```


## 2. tmpfs

#Observation:

The dd loop (30 × 10 MB = 300 MB of random data) pushed the tmpfs to exactly 100% — but never beyond 256 MB. The kernel silently rejected writes past the cap.

The size=256M mount option worked as intended — a critical safety mechanism, because tmpfs lives in RAM. Without this cap, tmpfs could have consumed all available memory and triggered the OOM killer.

## 3. CPU Stress Test


#Observation from top:

Load average spiked to 2.0 (one per CPU worker)

Both cores showed ~100% utilization during the 30-second window

CPU returned to idle immediately when the test ended

The service account was able to launch CPU-intensive workloads without permission issues, confirming the user was created correctly and could fork processes.

## 4. Memory Stress Test

#Observation During combined stress :
During the combined stress (CPU + 200 MB VM + HDD), available memory dropped from 1.5 GiB → 688 MiB. Swap usage also grew (960 KiB → 449 MiB), meaning the kernel began paging out inactive memory to free up RAM for the stress-ng VM workers.

#Observation After combined stress :

After the test finished, available memory bounced back to 1.6 GiB — the kernel reclaimed the stress-ng pages cleanly. Swap usage remained slightly elevated (572 MiB) because Linux does not aggressively page swap back in unless there is memory pressure.

## 5. OOM (Out-Of-Memory) Killer Check

#Observation:

The only OOM-related line is from boot time (timestamp 12.208790) — it just records that systemd-oomd is listening. There were no OOM kill events during the stress test.

The system had enough RAM (3.3 GiB) to absorb the 200 MB allocation without forcing the kernel to terminate any process. This is the desired outcome — the tmpfs cap and the modest VM size kept the machine stable.

## 6. SSH Access & Hardening

#Observation:

SSH login succeeded using key-based authentication on the custom port 2222, without prompting for a password. The whoami output confirms the session runs as bgdsvc_jannatul.

The system is now hardened against:

- Brute-force attacks on port 22 (changed to 2222)

- Root SSH login attempts (PermitRootLogin no)

- Password-based attacks (PasswordAuthentication no)

- Any user other than bgdsvc_jannatul logging in (AllowUsers)

## 7. Cron Monitoring

#Observation:

Both cron jobs are registered under the service account:

- Monitor runs every 5 minutes — logs free -h, df -h, and ps -u output

- Cleanup runs daily at 2:00 AM — deletes files older than 1 day in tmpfs

Cron automation is properly installed and executing as the service user (not root), following the principle of least privilege.

## 8. Logrotate

#Observation :

 Logrotate successfully:

- Rotated the old log to monitor.log.1.gz

- Compressed it with gzip

- Created a fresh monitor.log

- Preserved correct ownership (bgdsvc_jannatul:bgdsvc_jannatul)

## 9. Cleanup Verification

#Observation:

All three verification checks passed:

✅ User removed from the system

✅ tmpfs unmounted and mount point removed

✅ No orphan processes left behind

The script is idempotent — running it a second time caused no errors

The cleanup script leaves no trace: no user, no mount, no cron, no logs, no scripts in /usr/local/bin/. This is what "leave no trace" means in production — any change you make must be fully reversible.

## 10. What I Learned
Idempotency is non-negotiable in production automation. Every script must be safe to re-run.

**tmpfs needs a size cap** — otherwise it can silently consume RAM.

**OOM killer detection** —  requires checking dmesg, not just free -h.

**SSH hardening is layered** — port, root login, password auth, and user allowlist all matter.

**Cron + logrotate** — It's a lightweight but capable monitoring stack for small systems.

**Cleanup is design, not afterthought** — you must know every file/mount/user your setup touched.

##11. Conclusion

This assignment gave me end-to-end, hands-on exposure to the full lifecycle of a Linux service account — from creation, through load and stress testing, to hardening, monitoring, log management, and finally clean removal.

The most valuable lesson was learning to write idempotent scripts: in real infrastructure, nothing runs only once. Every change must be safe to repeat, and every change must be reversible. That mindset — not just the individual commands — is what separates a good sysadmin from a great one.
