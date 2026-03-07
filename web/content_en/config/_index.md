---
title: "Configuration"
description: "Disk Sentinel configuration reference"
date: 2026-03-06
weight: 4
showToc: true
TocOpen: true
---

## Configuration File

```
/usr/local/bin/disk-sentinel/config.conf
```

After editing, validate then restart:

```bash
disk-sentinel-admin check
disk-sentinel-admin restart
```

---

## Full Reference

```bash
# ============================================================
# Disk Sentinel - config.conf
# ============================================================

# List of disks to manage (full device paths)
DISKS=(/dev/sda /dev/sdb /dev/sdc /dev/sdd)

# Global idle time (seconds) before standby
IDLE_TIME=1800

# Per-disk overrides — set to 0 to DISABLE standby for that disk
# IDLE_TIME_sda=0
# IDLE_TIME_sdb=900
# IDLE_TIME_sdc=600
# IDLE_TIME_sdd=1200

# How often to check disk activity (seconds)
CHECK_INTERVAL=300

# Minimum I/O operations to consider a disk "active"
MIN_IO=50
```

---

## Parameter Reference

### DISKS

```bash
DISKS=(/dev/sda /dev/sdb /dev/sdc /dev/sdd)
```

Only listed devices are monitored and put to standby.

---

### IDLE_TIME

Global idle timeout in seconds.

```bash
IDLE_TIME=1800   # 30 minutes
```

| Value | Duration | Profile |
|-------|----------|---------|
| `300` | 5 min | Aggressive — cold data |
| `600` | 10 min | Balanced |
| `900` | 15 min | Conservative |
| `1800` | 30 min | Very conservative |
| `3600` | 1 hour | Minimal impact |

---

### IDLE_TIME_sdx

Per-disk override. Set to `0` to completely disable standby for that disk.

```bash
IDLE_TIME_sda=0      # SSD — DISABLE standby
IDLE_TIME_sdb=900    # Backup disk — 15 min
IDLE_TIME_sdc=300    # Cold data — 5 min
```

---

### CHECK_INTERVAL

How often Disk Sentinel checks disk activity (seconds).

```bash
CHECK_INTERVAL=300
```

---

### MIN_IO

Minimum I/O operations between checks to consider a disk "active".

```bash
MIN_IO=50
```

Increase this if brief background activity (metadata flushes, journaling) keeps preventing standby.

---

## Recommended Settings by Use Case

| Use Case | `IDLE_TIME` | Notes |
|----------|-------------|-------|
| SSD | `0` | Disable standby completely |
| System disk / VM / LXC | `0` | Never sleep |
| Hot data (frequently accessed) | `0` or `3600` | Consider disabling |
| Cold data (rarely accessed) | `300`–`600` | Aggressive standby |
| Backup RAID (nightly windows) | `900`–`1200` | Moderate standby |
| Archive / long-term storage | `600`–`900` | Balanced standby |
