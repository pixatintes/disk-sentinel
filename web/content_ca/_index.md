---
title: "Disk Sentinel"
description: "Gestor de Standby NO-WAKEUP per a Debian / Ubuntu / Proxmox"
layout: hextra-home
---

<div class="hx:mt-6 hx:mb-6 hx:flex hx:flex-col hx:items-center hx:text-center hx:gap-4 hx:w-full">
  {{< hextra/hero-headline >}}💾 Disk Sentinel{{< /hextra/hero-headline >}}
  {{< hextra/hero-subtitle >}}Gestor de Standby NO‑WAKEUP · Debian · Ubuntu · Proxmox VE{{< /hextra/hero-subtitle >}}
  <div class="hx:flex hx:gap-3 hx:mt-2">
    {{< hextra/hero-button text="Comença ara →" link="install/" >}}
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
{{< /tabs >}}
</div>


</div>

{{< hextra/feature-grid >}}
  {{< hextra/feature-card title="💤 NO-WAKEUP" subtitle="Mai desperta discos — només els posa en standby. Tot el monitoratge és passiu via kernel." >}}
  {{< hextra/feature-card title="⏱️ Temps per-disc" subtitle="Control fi amb IDLE_TIME_sdx per dispositiu. Posa 0 per desactivar el standby en SSDs o discos de sistema." >}}
  {{< hextra/feature-card title="🔍 Monitor Segur" subtitle="Monitoratge en temps real via /proc/diskstats i sysfs. Zero wakeups de disc garantits." >}}
  {{< hextra/feature-card title="🔔 Detecció de Wakeups" subtitle="Detecta i registra wakeups externs amb timestamp i nom del dispositiu." >}}
  {{< hextra/feature-card title="✅ Validació de Config" subtitle="Simulació dry-run amb disk-sentinel-admin check abans d'aplicar cap canvi." >}}
  {{< hextra/feature-card title="🔄 Servei Systemd" subtitle="Arrencada automàtica, reinici en fallada, integració amb watchdog i logs persistents." >}}
{{< /hextra/feature-grid >}}


