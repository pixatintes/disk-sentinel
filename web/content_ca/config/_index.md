---
title: "Configuració"
description: "Referència de configuració de Disk Sentinel"
date: 2026-03-06
weight: 4
toc: true
---

## Fitxer de configuració

```
/usr/local/bin/disk-sentinel/config.conf
```

Valida i reinicia després de cada canvi:

```bash
disk-sentinel-admin check
disk-sentinel-admin restart
```

---

## Referència completa

```bash
# ============================================================
# Disk Sentinel - config.conf
# ============================================================

# Llista de discos a gestionar (rutes completes)
DISKS=(/dev/sda /dev/sdb /dev/sdc /dev/sdd)

# Temps global d'inactivitat (segons) abans de standby
IDLE_TIME=1800

# Sobreescriptures per-disc (posa 0 per DESACTIVAR)
# IDLE_TIME_sda=0
# IDLE_TIME_sdb=900
# IDLE_TIME_sdc=600
# IDLE_TIME_sdd=1200

# Interval entre comprovacions (segons)
CHECK_INTERVAL=300

# Mínim d'operacions I/O per considerar un disc "actiu"
MIN_IO=50
```

---

## Referència de paràmetres

### DISKS

```bash
DISKS=(/dev/sda /dev/sdb /dev/sdc /dev/sdd)
```

Només els dispositius llistats seran monitoritzats i posats en standby.

---

### IDLE_TIME

Temps d'inactivitat global en segons.

| Valor | Durada | Perfil |
|-------|--------|--------|
| `300` | 5 min | Agressiu — dades fredes |
| `600` | 10 min | Equilibrat |
| `900` | 15 min | Conservador |
| `1800` | 30 min | Molt conservador |
| `3600` | 1 hora | Impacte mínim |

---

### IDLE_TIME_sdx

Sobreescriptura per-disc. Posa `0` per desactivar completament el standby.

```bash
IDLE_TIME_sda=0      # SSD — DESACTIVAR standby
IDLE_TIME_sdb=900    # Disc de backup — 15 min
IDLE_TIME_sdc=300    # Dades fredes — 5 min
```

---

### CHECK_INTERVAL / MIN_IO

```bash
CHECK_INTERVAL=300   # Comprova cada 5 minuts
MIN_IO=50            # Activitat mínima per considerar "actiu"
```

---

## Configuració recomanada per cas d'ús

| Cas d'ús | `IDLE_TIME` | Notes |
|----------|-------------|-------|
| SSD | `0` | Desactivar standby completament |
| Disc de sistema / VM / LXC | `0` | Mai en standby |
| Dades calentes | `0` o `3600` | Considera desactivar |
| Dades fredes | `300`–`600` | Standby agressiu |
| RAID de backup | `900`–`1200` | Standby moderat |
| Arxiu a llarg termini | `600`–`900` | Standby equilibrat |
