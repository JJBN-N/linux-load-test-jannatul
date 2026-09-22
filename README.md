# Linux Load Test Assignment — BongoDev

**Student Name:** Jannatul

**Service Account:** `bgdsvc_jannatul`

**Environment:** Ubuntu (Linux)

**Assignment:** Linux System Administration — Load Test, Hardening & Automation

---

## 📌 Overview

This is a hands-on Linux system administration lab simulating a **production service account lifecycle** for a service called `bgdsvc_jannatul`. The assignment covers:

1. Creating an idempotent **service account**
2. Provisioning **tmpfs (RAM-backed) scratch space**
3. Running **CPU / Memory / Disk stress tests**
4. Observing **OOM Killer** behaviour
5. Configuring **SSH key access + hardening**
6. Automating **monitoring via cron**
7. Managing logs via **logrotate**
8. Performing a **full idempotent cleanup** (leave no trace)

Every step is scripted, verified with screenshots, and safe to re-run.


---

## 🎯 Learning Objectives

By completing this assignment, I learned how to:

- Create and manage **system service accounts** (non-login, `nologin` shell)
- Write **idempotent Bash scripts** (safe to run multiple times)
- Set up **tmpfs (RAM-backed scratch space)** with size limits
- Perform **stress testing** using `stress-ng` (CPU, memory, disk)
- Observe system behavior under load with `free -h`, `top`, `df -h`, `dmesg`
- Detect **OOM (Out-Of-Memory) Killer** events in the kernel log
- Configure **SSH key-based authentication** (passwordless login)
- Apply **SSH hardening** (custom port, disable root login, disable password auth)
- Automate **system monitoring via cron**
- Configure **logrotate** for log rotation and compression
- Write **safe cleanup scripts** that remove users, mounts, cron jobs, logs, and files

---

## 📁 Repository Structure

```
linux-load-test-jannatul/
├── README.md
├── observations.md 
├── .gitignore
├── scripts/
│ ├── 01_create_user.sh
│ ├── 02_setup_tmpfs.sh 
│ ├── 03_stress_and_populate.sh 
│ ├── 04_cleanup.sh 
│ ├── bgdsvc_jannatul_monitor.sh 
│ └── bgdsvc_jannatul_cleanup_old_files.sh 
└── screenshots/
├── 00_svc_name.png
├── 01_id_created.png
├── 02_df_before.png 
├── 02_df_after.png 
├── 03_free_before.png 
├── 03_free_during.png 
├── 03_free_after.png 
├── 03_dmesg_oom.png 
├── 04_ssh_success.png 
├── 05_crontab_l.png 
├── 05_logrotate.png 
└── 06_cleanup_verify.png 

```

## How to Run

1. To set service name: **export SVC_NAME=bgdsvc_jannatut**
2. **sudo env SVC_NAME=$SVC_NAME ./scripts/01_create_user.sh**
3. **sudo env SVC_NAME=$SVC_NAME ./scripts/02_setup_tmpfs.sh**
4. **sudo env SVC_NAME=$SVC_NAME ./scripts/03_stress_and_populate.sh**
5. **Configure SSH, Cron, and Logrotate as per assignment**
6. **sudo env SVC_NAME=$SVC_NAME ./scripts/04_cleanup.sh**

