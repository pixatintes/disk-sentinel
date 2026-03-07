# Disk Sentinel  
**NO‑WAKEUP Disk Standby Manager for Debian / Ubuntu / Proxmox**  
**Licensed under the GNU General Public License v3 (GPLv3)**

Disk Sentinel és una eina de gestió intel·ligent de standby per a discs mecànics en sistemes Linux basats en Debian.  
El seu objectiu principal és **allargar la vida útil dels discos mecànics**, reduint hores de rotació, evitant wakeups innecessaris, minimitzant la temperatura i disminuint el desgast mecànic.

Funciona especialment bé en servidors on conviuen:

- Discos mecànics de dades fredes
- Arrays RAID utilitzats només en finestres de backup
- Discos que només s’accedeixen esporàdicament

Disk Sentinel proporciona un control fi, segur i predictible del comportament dels discs mecànics, sense despertar-los mai.

---

## ✨ Característiques principals

- **NO-WAKEUP**: mai desperta discos, només els posa en standby.
- **Temps d’inactivitat per-disc** (`IDLE_TIME_sdx`).
- **Temps global de fallback**.
- **Monitoratge en temps real** sense despertar discos.
- **Monitoratge real** amb `hdparm -C` (pot despertar discos).
- **Detecció de wakeups externs** amb registre al log.
- **Validació i simulació de configuració** (`check`).
- **Eina d’administració completa** (`disk-sentinel-admin`).
- **Servei systemd** amb reinici automàtic.
- **Logs clars i persistents**.

---

## 🧩 Compatibilitat

Funciona en qualsevol sistema Linux basat en Debian:

- Debian 10/11/12/13  
- Ubuntu 18/20/22/24  
- Proxmox VE 6/7/8  
- ...

---

## 🎯 Objectiu del projecte

El propòsit de Disk Sentinel és clar:

### ⭐ **Allargar la vida dels discos mecànics.**

Ho aconsegueix:

- reduint hores de rotació  
- evitant wakeups innecessaris  
- minimitzant la temperatura  
- reduint vibració i soroll  
- disminuint consum  
- protegint el disc de desgast prematur  

Això és especialment útil en servidors casolans, NAS, Proxmox i sistemes amb dades fredes.

---

## 📦 Instal·lació

### Opció A — Una sola comanda (recomanat)

Descarrega i executa l'instal·lador directament sense necessitat de clonar el repositori:

```bash
curl -fsSL https://raw.githubusercontent.com/pixatintes/disk-sentinel/main/install-disk-sentinel.sh | sudo bash
```

> Si no tens `curl`, pots usar `wget`:
> ```bash
> wget -qO- https://raw.githubusercontent.com/pixatintes/disk-sentinel/main/install-disk-sentinel.sh | sudo bash
> ```

### Opció B — Git clone

Si prefereixes inspeccionar el codi abans d'executar-lo:

```bash
git clone https://github.com/pixatintes/disk-sentinel.git
cd disk-sentinel
chmod +x install-disk-sentinel.sh
sudo ./install-disk-sentinel.sh
```

---

Això instal·larà:

- `/usr/local/bin/disk-sentinel/` (script principal + config)
- `/usr/local/bin/disk-sentinel-admin`
- `/etc/systemd/system/disk-sentinel.service`
- `/var/log/disk-sentinel.log`

El servei s’activarà automàticament.

---

## ⚙️ Configuració

El fitxer de configuració es troba a:

```
/usr/local/bin/disk-sentinel/config.conf
```

### Exemple (`config.conf.example`)

```bash
# Temps global d'inactivitat (segons)
IDLE_TIME=1800

# Temps per-disc (opcional)
# IDLE_TIME_sda=0
# IDLE_TIME_sdb=900
# IDLE_TIME_sdc=600

# Interval entre comprovacions
CHECK_INTERVAL=300

# Mínim I/O per considerar activitat
MIN_IO=50

# Discs gestionats
DISKS=(/dev/sda /dev/sdb /dev/sdc /dev/sdd)
```

### Recomanacions

- **SSD** → NO standby (`IDLE_TIME_sdx=0`)
- **Dades fredes** → standby agressiu (300–600s)
- **RAID de backups nocturns** → standby moderat (900–1200s)
- **Discs de sistema / VM / LXC** → NO standby

---

## 🛠️ Eina d’administració

L’eina principal és:

```
disk-sentinel-admin
```

### Comandes disponibles

| Comanda | Descripció |
|--------|------------|
| `monitor-safe` | Monitor NO-WAKEUP (no desperta discos) |
| `monitor-real` | Monitor real amb `hdparm -C` |
| `consulta` | Consulta única de l’estat real |
| `config` | Mostra la configuració actual |
| `check` | Validació + simulació (dry-run) |
| `wake-monitor` | Mostra wakeups externs en temps real |
| `start` / `stop` / `restart` | Control del servei |
| `status` | Estat del servei |
| `enable` / `disable` | Activar/desactivar en arrencada |
| `logs` | Mostra els logs del servei |

---

## 🔍 Funcionament intern

Disk Sentinel:

1. Llegeix I/O real de `/proc/diskstats`.
2. Llegeix l’estat del disc de `/sys/block/.../runtime_status`.
3. Detecta activitat mínima (`MIN_IO`).
4. Incrementa un comptador d’inactivitat.
5. Quan arriba al límit → standby amb `hdparm -y`.
6. Mai desperta discos.
7. Registra wakeups externs al log.

---

## 📄 Llicència

Disk Sentinel is licensed under GPLv3 to ensure that all improvements, modifications, and redistributions of the software remain free and open for the community. This guarantees that the project cannot be closed, privatized, or restricted by third parties.

Disk Sentinel is free software released under the GNU General Public License v3 (GPLv3).
See the LICENSE file for the full text of the license.



