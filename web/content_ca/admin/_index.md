---
title: "Eina d'Administració"
description: "Referència de comandes de disk-sentinel-admin"
date: 2026-03-06
weight: 3
toc: true
---

## 🛠️ disk-sentinel-admin

```bash
disk-sentinel-admin <comanda>
```

---

## 📋 Referència de comandes

### Monitoratge

| Comanda | Descripció |
|---------|------------|
| `monitor-safe` | Monitor NO-WAKEUP en temps real (llegeix `/proc/diskstats` i sysfs) |
| `monitor-real` | Monitor en temps real amb `hdparm -C` (pot despertar alguns discos) |
| `consulta` | Consulta puntual de l'estat real de tots els discos gestionats |
| `wake-monitor` | Seguiment en directe dels wakeups externs |

### Configuració

| Comanda | Descripció |
|---------|------------|
| `config` | Mostra la configuració actual |
| `check` | Valida la configuració i executa una simulació dry-run |

### Control del servei

| Comanda | Descripció |
|---------|------------|
| `start` | Inicia el servei Disk Sentinel |
| `stop` | Atura el servei Disk Sentinel |
| `restart` | Reinicia el servei (aplica canvis de configuració) |
| `status` | Mostra l'estat del servei |
| `enable` | Activa el servei en l'arrencada del sistema |
| `disable` | Desactiva el servei en l'arrencada del sistema |
| `logs` | Mostra els logs recents del servei |

---

## 🔍 Exemples de monitoratge

### Monitor segur (recomanat)

```bash
disk-sentinel-admin monitor-safe
```

```
=== Disk Sentinel — Monitor Segur ===
/dev/sda  [ACTIU  ]  I/O: 142  inactivitat: 0/1800s
/dev/sdb  [STANDBY]  I/O:   0  inactivitat: ---
/dev/sdc  [ACTIU  ]  I/O:  38  inactivitat: 247/600s
```

### Seguiment de wakeups

```bash
disk-sentinel-admin wake-monitor
```

---

## ✅ Valida la teva configuració

```bash
disk-sentinel-admin check
```

```
=== Disk Sentinel — Validació de Config ===
DISKS: /dev/sda /dev/sdb /dev/sdc /dev/sdd
IDLE_TIME (global): 1800s
  /dev/sda -> IDLE_TIME=0 (standby desactivat)
  /dev/sdb -> IDLE_TIME=900s

[OK] La configuració és vàlida.
[DRY RUN] No s'han fet canvis al sistema.
```

---

## 📋 Gestió del servei

```bash
disk-sentinel-admin status
disk-sentinel-admin restart
disk-sentinel-admin logs
```
