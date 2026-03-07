---
title: "Features"
description: "All Disk Sentinel features in detail"
date: 2026-03-06
weight: 1
toc: true
---

## 💤 NO-WAKEUP — The Core Principle

The fundamental promise of Disk Sentinel: **it will never wake up a disk**.

All monitoring is done passively using kernel interfaces:

- `/proc/diskstats` — I/O counters (no disk access)
- `/sys/block/<dev>/device/power/runtime_status` — power state (no disk access)

Wakeups only happen when **you** decide to use the disk. Disk Sentinel never initiates one.

---

## ⏱️ Per-Disk Idle Time

Each disk can have its own idle timeout, independent of the global setting.

```bash
# Global fallback (seconds)
IDLE_TIME=1800

# Per-disk overrides
IDLE_TIME_sda=0       # SSD — never sleep
IDLE_TIME_sdb=900     # Backup RAID disk
IDLE_TIME_sdc=600     # Cold data disk
IDLE_TIME_sdd=1200    # Archive disk
```

Set `IDLE_TIME_sdx=0` to **disable** standby for a specific disk (useful for SSDs, system disks, or VM/LXC storage).

---

## 🔍 Safe Monitoring (No-Wakeup)

The `monitor-safe` mode reads disk state purely from kernel counters:

```bash
disk-sentinel-admin monitor-safe
```

Output refreshes every few seconds showing:

- Disk device name
- Current I/O activity
- Inactivity counter progress
- Estimated power state (from sysfs)

**Zero disk wakeups guaranteed.**

---

## 📡 Real Monitoring

The `monitor-real` mode uses `hdparm -C` to query the true hardware state of each disk:

```bash
disk-sentinel-admin monitor-real
```

> ⚠️ **Warning:** `hdparm -C` may wake up some drives depending on firmware. Use `monitor-safe` for routine monitoring.

---

## 🔔 Wakeup Detection

Disk Sentinel continuously watches for **external wakeup events** — situations where something else (a backup job, a cron task, or a filesystem mount) wakes up a disk that Disk Sentinel had put to sleep.

All wakeups are logged with timestamp and device:

```
[2026-03-06 03:42:17] WAKEUP DETECTED: /dev/sdb (external)
```

Use the `wake-monitor` command to watch wakeups live:

```bash
disk-sentinel-admin wake-monitor
```

---

## ✅ Configuration Validation

Before applying a new configuration, validate it with a dry-run:

```bash
disk-sentinel-admin check
```

This will parse your `config.conf`, validate all parameters, simulate the standby logic, and report any issues. No changes are made to the system.

---

## 🔄 Systemd Service

Disk Sentinel runs as a managed systemd service:

- **Auto-start** on boot
- **Automatic restart** on failure
- **Watchdog** integration
- **Persistent logs** via `journalctl`

```bash
systemctl status disk-sentinel
journalctl -u disk-sentinel -f
```

---

## 📊 Minimal Resource Usage

Disk Sentinel is a lightweight Bash script. It uses:

- No daemons other than itself
- No databases or caches
- Minimal CPU (wakes every `CHECK_INTERVAL` seconds)
- No network access
