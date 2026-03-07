---
title: "Característiques"
description: "Totes les característiques de Disk Sentinel en detall"
date: 2026-03-06
weight: 1
showToc: true
TocOpen: true
---

## 🚫 NO-WAKEUP — El principi fonamental

La promesa fonamental de Disk Sentinel: **mai despertarà un disc**.

Tot el monitoratge es fa de forma passiva:

- `/proc/diskstats` — comptadors I/O (sense accés al disc)
- `/sys/block/<dev>/device/power/runtime_status` — estat d'energia (sense accés al disc)

Els wakeups només passen quan **tu** decideixes usar el disc.

---

## ⏱️ Temps d'inactivitat per-disc

```bash
# Fallback global (segons)
IDLE_TIME=1800

# Sobreescriptures per-disc
IDLE_TIME_sda=0       # SSD — mai en standby
IDLE_TIME_sdb=900     # Disc de backup RAID
IDLE_TIME_sdc=600     # Disc de dades fredes
IDLE_TIME_sdd=1200    # Disc d'arxiu
```

Posa `IDLE_TIME_sdx=0` per **desactivar** el standby d'un disc concret.

---

## 🔍 Monitor segur (Sense wakeup)

```bash
disk-sentinel-admin monitor-safe
```

Mostra per a cada disc: nom, activitat I/O, progrés del comptador d'inactivitat i estat d'energia. **Zero wakeups garantits.**

---

## 📡 Monitor real

```bash
disk-sentinel-admin monitor-real
```

> ⚠️ **Avís:** `hdparm -C` pot despertar alguns discos. Utilitza `monitor-safe` per al monitoratge rutinari.

---

## 🔔 Detecció de wakeups

Disk Sentinel vigila contínuament els **wakeups externs**. Tots es registren amb timestamp:

```
[2026-03-06 03:42:17] WAKEUP DETECTED: /dev/sdb (external)
```

```bash
disk-sentinel-admin wake-monitor
```

---

## ✅ Validació de configuració

```bash
disk-sentinel-admin check
```

Analitza `config.conf`, valida tots els paràmetres, simula la lògica de standby. No es fan canvis al sistema.

---

## 🔄 Servei Systemd

- **Arrencada automàtica** en engegar
- **Reinici automàtic** en fallada
- Integració amb **watchdog**
- **Logs persistents** via `journalctl`

```bash
systemctl status disk-sentinel
journalctl -u disk-sentinel -f
```

---

## 📊 Consum mínim de recursos

- Cap daemon addicional
- Cap base de dades ni caché
- CPU mínima (desperta cada `CHECK_INTERVAL` segons)
- Sense accés a la xarxa
