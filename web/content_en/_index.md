---
title: "Disk Sentinel"
description: "NO-WAKEUP Disk Standby Manager for Debian / Ubuntu / Proxmox"
date: 2026-03-06
layout: "home"
---

## ⭐ Extend the life of your mechanical drives

Disk Sentinel is an intelligent standby management tool for mechanical hard disks on Debian-based Linux systems.

Its primary goal is **to extend the life of mechanical hard drives** by:

- 🔁 Reducing rotation hours
- 🚫 Avoiding unnecessary wakeups
- 🌡️ Minimizing temperature
- 📉 Reducing mechanical wear and vibration
- 💡 Lowering power consumption

---

## 🚀 Key Features

| Feature | Description |
|---------|-------------|
| 🚫 **NO-WAKEUP** | Never wakes up disks — only puts them to sleep |
| ⏱️ **Per-Disk Idle Time** | Fine-grained `IDLE_TIME_sdx` per device |
| 🔍 **Safe Monitoring** | Real-time monitoring via `/proc/diskstats` — no wakeup |
| 📡 **Real Monitoring** | Full status with `hdparm -C` |
| 🔔 **Wakeup Detection** | Detects and logs external wakeup events |
| ✅ **Config Validation** | `check` command for dry-run simulation |
| 🛠️ **Admin Tool** | Full-featured `disk-sentinel-admin` CLI |
| 🔄 **Systemd Service** | Auto-start with watchdog and automatic restart |

---

## 🧩 Compatibility

Disk Sentinel works on any Debian-based Linux system:

| Distribution | Versions |
|-------------|----------|
| **Debian** | 10 · 11 · 12 · 13 |
| **Ubuntu** | 18 · 20 · 22 · 24 |
| **Proxmox VE** | 6 · 7 · 8 |

---

## 📦 Quick Install

```bash
chmod +x install-disk-sentinel.sh
sudo ./install-disk-sentinel.sh
```

After installation, the service starts automatically. Check its status with:

```bash
disk-sentinel-admin status
```

---

## 🔍 How It Works

1. Reads real I/O counters from `/proc/diskstats`
2. Reads disk state from `/sys/block/.../runtime_status`
3. Detects minimum activity (`MIN_IO` threshold)
4. Increments an inactivity counter per disk
5. When the limit is reached → standby via `hdparm -y`
6. **Never wakes up disks**
7. Logs external wakeups to the log file

---

## 📄 License

Disk Sentinel is free software released under the **GNU General Public License v3 (GPLv3)**.  
This ensures all improvements and modifications remain free and open for the community.
