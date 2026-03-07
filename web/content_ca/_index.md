---
title: "Disk Sentinel"
description: "Gestor de Standby NO-WAKEUP per a Debian / Ubuntu / Proxmox"
date: 2026-03-06
layout: "home"
---

## ⭐ Allarga la vida dels teus discos mecànics

Disk Sentinel és una eina de gestió intel·ligent de standby per a discos mecànics en sistemes Linux basats en Debian.

El seu objectiu principal és **allargar la vida útil dels discos mecànics**:

- 🔁 Reduint hores de rotació
- 🚫 Evitant wakeups innecessaris
- 🌡️ Minimitzant la temperatura
- 📉 Reduint el desgast mecànic i la vibració
- 💡 Disminuint el consum energètic

---

## 🚀 Característiques principals

| Característica | Descripció |
|----------------|------------|
| 🚫 **NO-WAKEUP** | Mai desperta discos — només els posa en standby |
| ⏱️ **Temps per-disc** | Control fi amb `IDLE_TIME_sdx` per dispositiu |
| 🔍 **Monitor segur** | Monitoratge via `/proc/diskstats` — sense despertar |
| 📡 **Monitor real** | Estat complet amb `hdparm -C` |
| 🔔 **Detecció de wakeups** | Detecta i registra wakeups externs |
| ✅ **Validació de config** | Comanda `check` per a dry-run |
| 🛠️ **Eina admin** | CLI complet `disk-sentinel-admin` |
| 🔄 **Servei Systemd** | Arrencada automàtica amb reinici en fallada |

---

## 🧩 Compatibilitat

| Distribució | Versions |
|-------------|----------|
| **Debian** | 10 · 11 · 12 · 13 |
| **Ubuntu** | 18 · 20 · 22 · 24 |
| **Proxmox VE** | 6 · 7 · 8 |

---

## 📦 Instal·lació ràpida

```bash
chmod +x install-disk-sentinel.sh
sudo ./install-disk-sentinel.sh
```

Comprova l'estat amb:

```bash
disk-sentinel-admin status
```

---

## 🔍 Com funciona

1. Llegeix comptadors I/O reals de `/proc/diskstats`
2. Llegeix l'estat del disc de `/sys/block/.../runtime_status`
3. Detecta activitat mínima (llindar `MIN_IO`)
4. Incrementa un comptador d'inactivitat per disc
5. Quan arriba al límit → standby via `hdparm -y`
6. **Mai desperta discos**
7. Registra wakeups externs al fitxer de log

---

## 📄 Llicència

Disk Sentinel és programari lliure publicat sota la **GNU General Public License v3 (GPLv3)**.
Això garanteix que totes les millores i modificacions restin lliures i obertes per a la comunitat.
