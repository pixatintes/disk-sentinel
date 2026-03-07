---
title: "Instal·lació"
description: "Com instal·lar Disk Sentinel"
date: 2026-03-06
weight: 2
toc: true
---

## 📋 Requisits

- Sistema Linux basat en Debian (Debian 10+, Ubuntu 18+, Proxmox VE 6+)
- Paquet `hdparm` (s'instal·la automàticament si falta)
- `systemd`
- Accés root / sudo

---

## 📦 Passos d'instal·lació

{{< tabs >}}
{{< tab name="curl" >}}
Descarrega i executa l'instal·lador directament sense necessitat de clonar el repositori:

```bash
curl -fsSL https://raw.githubusercontent.com/pixatintes/disk-sentinel/main/install-disk-sentinel.sh | sudo bash
```
{{< /tab >}}

{{< tab name="wget" >}}
Descarrega i executa l'instal·lador directament sense necessitat de clonar el repositori:

```bash
wget -qO- https://raw.githubusercontent.com/pixatintes/disk-sentinel/main/install-disk-sentinel.sh | sudo bash
```
{{< /tab >}}
{{< tab name="Git clone" >}}
Si prefereixes inspeccionar el codi abans d'executar-lo:

```bash
git clone https://github.com/pixatintes/disk-sentinel.git
cd disk-sentinel
chmod +x install-disk-sentinel.sh
sudo ./install-disk-sentinel.sh
```
{{< /tab >}}
{{< /tabs >}}

Ambdues opcions executen el mateix instal·lador, que:

- Instal·la `hdparm` si no està present
- Copia l'script principal a `/usr/local/bin/disk-sentinel/`
- Copia l'eina d'administració a `/usr/local/bin/disk-sentinel-admin`
- Instal·la la unitat de servei systemd
- Crea el fitxer de log a `/var/log/disk-sentinel.log`
- Activa i inicia el servei automàticament

---

## ✅ Verifica la instal·lació

```bash
disk-sentinel-admin status
disk-sentinel-admin logs
```

---

## 📁 Fitxers instal·lats

| Ruta | Descripció |
|------|------------|
| `/usr/local/bin/disk-sentinel/disk-sentinel.sh` | Script daemon principal |
| `/usr/local/bin/disk-sentinel/config.conf` | Fitxer de configuració |
| `/usr/local/bin/disk-sentinel-admin` | Eina CLI d'administració |
| `/etc/systemd/system/disk-sentinel.service` | Unitat de servei Systemd |
| `/var/log/disk-sentinel.log` | Fitxer de log |

---

## ⚙️ Configuració inicial

```bash
sudo nano /usr/local/bin/disk-sentinel/config.conf
```

Defineix la llista de discos:

```bash
DISKS=(/dev/sda /dev/sdb /dev/sdc /dev/sdd)
```

Reinicia el servei:

```bash
disk-sentinel-admin restart
```

Consulta la pàgina [Configuració](/ca/config/) per a totes les opcions.

---

## 🗑️ Desinstal·lació

Per eliminar completament Disk Sentinel:

{{< tabs >}}
{{< tab name="curl" >}}

```bash
curl -fsSL https://raw.githubusercontent.com/pixatintes/disk-sentinel/main/uninstall-disk-sentinel.sh | sudo bash
```

{{< /tab >}}
{{< tab name="wget" >}}

```bash
wget -qO- https://raw.githubusercontent.com/pixatintes/disk-sentinel/main/uninstall-disk-sentinel.sh | sudo bash
```

{{< /tab >}}
{{< tab name="Git clone" >}}

```bash
chmod +x uninstall-disk-sentinel.sh
sudo ./uninstall-disk-sentinel.sh
```

{{< /tab >}}
{{< /tabs >}}

Això aturarà i desactivarà el servei, eliminarà tots els fitxers instal·lats i opcionalment el fitxer de log.

