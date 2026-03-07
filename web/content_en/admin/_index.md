---
title: "Admin Tool"
description: "disk-sentinel-admin command reference"
date: 2026-03-06
weight: 3
showToc: true
TocOpen: true
---

## 🛠️ disk-sentinel-admin

`disk-sentinel-admin` is the main CLI for controlling and monitoring Disk Sentinel.

```bash
disk-sentinel-admin <command>
```

---

## 📋 Command Reference

### Monitoring

| Command | Description |
|---------|-------------|
| `monitor-safe` | Real-time NO-WAKEUP monitor (reads `/proc/diskstats` and sysfs) |
| `monitor-real` | Real-time monitor using `hdparm -C` (may wake some drives) |
| `consulta` | Single-shot real status query for all managed disks |
| `wake-monitor` | Live feed of external wakeup events |

### Configuration

| Command | Description |
|---------|-------------|
| `config` | Display current configuration |
| `check` | Validate configuration and run dry-run simulation |

### Service Control

| Command | Description |
|---------|-------------|
| `start` | Start the Disk Sentinel service |
| `stop` | Stop the Disk Sentinel service |
| `restart` | Restart the service (apply config changes) |
| `status` | Show service status |
| `enable` | Enable service on system boot |
| `disable` | Disable service on system boot |
| `logs` | Show recent service logs |

---

## 🔍 Monitoring Examples

### Safe monitor (recommended)

```bash
disk-sentinel-admin monitor-safe
```

Example output:

```
=== Disk Sentinel — Safe Monitor ===
Refreshing every 5s. Press Ctrl+C to stop.

/dev/sda  [ACTIVE ]  I/O: 142  idle: 0/1800s
/dev/sdb  [STANDBY]  I/O:   0  idle: ---
/dev/sdc  [ACTIVE ]  I/O:  38  idle: 247/600s
```

### Watch for wakeups live

```bash
disk-sentinel-admin wake-monitor
```

---

## ✅ Validate Your Config

Always validate after editing `config.conf`:

```bash
disk-sentinel-admin check
```

Example output:

```
=== Disk Sentinel — Config Check ===
DISKS: /dev/sda /dev/sdb /dev/sdc /dev/sdd
IDLE_TIME (global): 1800s
  /dev/sda -> IDLE_TIME=0 (standby disabled)
  /dev/sdb -> IDLE_TIME=900s
  /dev/sdc -> IDLE_TIME=600s
  /dev/sdd -> IDLE_TIME=1800s (global)
CHECK_INTERVAL: 300s  |  MIN_IO: 50

[OK] Configuration is valid.
[DRY RUN] No changes made to the system.
```

---

## 📋 Service Management

```bash
# Check service health
disk-sentinel-admin status

# Apply config changes
disk-sentinel-admin restart

# Follow live logs
disk-sentinel-admin logs
```
