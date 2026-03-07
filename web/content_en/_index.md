---
title: "Disk Sentinel"
description: "NO-WAKEUP Disk Standby Manager for Debian / Ubuntu / Proxmox"
layout: hextra-home
---

<div class="hx:mt-6 hx:mb-6 hx:flex hx:flex-col hx:items-center hx:text-center hx:gap-4 hx:w-full">
  
  {{< hextra/hero-headline >}}💾 Disk Sentinel{{< /hextra/hero-headline >}}
  {{< hextra/hero-subtitle >}}NO‑WAKEUP Disk Standby Manager · Debian · Ubuntu · Proxmox VE{{< /hextra/hero-subtitle >}}
  <div class="hx:flex hx:gap-3 hx:mt-2">
    {{< hextra/hero-button text="Get Started →" link="install/" >}}
    {{< hextra/hero-button text="GitHub" link="https://github.com/pixatintes/disk-sentinel" style="background-color:#24292f" >}}
  </div>
  <div class="hx:mt-2">
{{< tabs >}}
{{< tab name="curl" >}}

```bash
curl -fsSL https://raw.githubusercontent.com/pixatintes/disk-sentinel/main/install-disk-sentinel.sh | sudo bash
```

{{< /tab >}}
{{< tab name="wget" >}}

```bash
wget -qO- https://raw.githubusercontent.com/pixatintes/disk-sentinel/main/install-disk-sentinel.sh | sudo bash
```
{{< /tab >}}
{{< tab name="Git clone" >}}

```bash
git clone https://github.com/pixatintes/disk-sentinel.git
cd disk-sentinel
chmod +x install-disk-sentinel.sh
sudo ./install-disk-sentinel.sh
```
{{< /tab >}}
{{< /tabs >}}</div>
</div>
</div>


{{< hextra/feature-grid >}}
  {{< hextra/feature-card title="💤 NO-WAKEUP" subtitle="Never wakes up disks — only puts them to sleep. All monitoring is done passively via kernel interfaces." >}}
  {{< hextra/feature-card title="⏱️ Per-Disk Idle Time" subtitle="Fine-grained IDLE_TIME_sdx per device. Set to 0 to disable standby for SSDs or system disks." >}}
  {{< hextra/feature-card title="🔍 Safe Monitoring" subtitle="Real-time monitoring via /proc/diskstats and sysfs. Zero disk wakeups guaranteed." >}}
  {{< hextra/feature-card title="🔔 Wakeup Detection" subtitle="Detects and logs external wakeup events with timestamp and device name." >}}
  {{< hextra/feature-card title="✅ Config Validation" subtitle="Dry-run with disk-sentinel-admin check before applying any changes to the system." >}}
  {{< hextra/feature-card title="🔄 Systemd Service" subtitle="Auto-start on boot, automatic restart on failure, watchdog integration and persistent logs." >}}
{{< /hextra/feature-grid >}}


