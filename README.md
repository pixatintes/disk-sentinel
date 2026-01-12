# Disk Sentinel  
**NO‑WAKEUP Disk Standby Manager for Debian / Ubuntu / Proxmox**

Disk Sentinel és un sistema de gestió intel·ligent de standby per a discs mecànics en entorns Linux basats en Debian.  
Està dissenyat per **evitar despertar discos innecessàriament**, aplicar **polítiques de standby per-disc**, i detectar **wakeups externs** provocats per altres processos del sistema.

Funciona especialment bé en servidors on conviuen:

- discs SSD de sistema o treball (que no han de fer standby)
- discs mecànics de dades fredes (música, vídeos, fotos…)
- arrays RAID utilitzats només en finestres de backup
- discs que només s’accedeixen esporàdicament

Disk Sentinel proporciona un control fi, segur i predictible del comportament dels discs mecànics.

---

## ✨ Característiques principals

- **NO-WAKEUP**: mai desperta discos, només els posa en standby.
- **Temps d’inactivitat per-disc** (IDLE_TIME_sdx).
- **Temps global de fallback**.
- **Monitoratge en temps real** sense despertar discos.
- **Monitoratge real** amb `hdparm -C` (pot despertar discos).
- **Detecció de wakeups externs** (registre al log).
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
- Devuan, Mint, Pop!\_OS, etc.

No depèn de cap component específic de Proxmox.

---

## 📦 Instal·lació

Descarrega i executa l’instal·lador:

```bash
chmod +x install-disk-sentinel.sh
sudo ./install-disk-sentinel.sh
```

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

Aquest projecte està sota llicència **MIT**.  
Consulta el fitxer `LICENSE` per més informació.

---

## 🤝 Contribucions

Les contribucions són benvingudes:

- millores del monitoratge
- suport per més tipus de discs
- integració amb altres eines
- documentació

Fes un fork i envia un pull request.

---

## ⭐ Crèdits

Creat per a entorns Debian/Proxmox que necessiten un control fi i segur del standby dels discs mecànics.

