---
title: "Installation"
description: "How to install Disk Sentinel"
date: 2026-03-06
weight: 2
showToc: true
TocOpen: true
---

## 📋 Requirements

- Debian-based Linux (Debian 10+, Ubuntu 18+, Proxmox VE 6+)
- `hdparm` package (installed automatically if missing)
- `systemd`
- Root / sudo access

---

## 📦 Installation Steps

### Option A — One-liner (recommended)

Download and run the installer in a single command, no git clone needed:

```bash
curl -fsSL https://raw.githubusercontent.com/pixatintes/disk-sentinel/main/install-disk-sentinel.sh | sudo bash
```

> No `curl`? Use `wget` instead:
> ```bash
> wget -qO- https://raw.githubusercontent.com/pixatintes/disk-sentinel/main/install-disk-sentinel.sh | sudo bash
> ```

### Option B — Git clone

If you prefer to inspect the code before running it:

```bash
git clone https://github.com/pixatintes/disk-sentinel.git
cd disk-sentinel
chmod +x install-disk-sentinel.sh
sudo ./install-disk-sentinel.sh
```

Both options run the same installer, which will:

- Install `hdparm` if not present
- Copy the main script to `/usr/local/bin/disk-sentinel/`
- Copy the admin tool to `/usr/local/bin/disk-sentinel-admin`
- Install the systemd service unit
- Create the log file at `/var/log/disk-sentinel.log`
- Enable and start the service automatically

---

## ✅ Verify the installation

```bash
disk-sentinel-admin status
```

Check the logs with:

```bash
disk-sentinel-admin logs
```

---

## 📁 Installed Files

| Path | Description |
|------|-------------|
| `/usr/local/bin/disk-sentinel/disk-sentinel.sh` | Main daemon script |
| `/usr/local/bin/disk-sentinel/config.conf` | Configuration file |
| `/usr/local/bin/disk-sentinel-admin` | Admin CLI tool |
| `/etc/systemd/system/disk-sentinel.service` | Systemd service unit |
| `/var/log/disk-sentinel.log` | Log file |

---

## ⚙️ Post-Installation: Configure Your Disks

Edit the configuration file:

```bash
sudo nano /usr/local/bin/disk-sentinel/config.conf
```

Set the list of disks you want to manage:

```bash
DISKS=(/dev/sda /dev/sdb /dev/sdc /dev/sdd)
```

Then restart the service to apply changes:

```bash
disk-sentinel-admin restart
```

See the [Configuration](/en/config/) page for all available options.

---

## 🗑️ Uninstallation

To completely remove Disk Sentinel:

```bash
chmod +x uninstall-disk-sentinel.sh
sudo ./uninstall-disk-sentinel.sh
```

This will stop and disable the service, remove all installed files, and optionally the log file.
