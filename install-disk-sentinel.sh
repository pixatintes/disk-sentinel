# Disk Sentinel – NO-WAKEUP Disk Standby Manager
# Copyright (C) 2025  
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.


#!/bin/bash
# ============================================================
#   Disk Sentinel - Instal·lador complet (NO-WAKEUP)
# ============================================================

set -e

SERVICE_NAME="disk-sentinel"
BASE_DIR="/usr/local/bin/disk-sentinel"
CONFIG_FILE="$BASE_DIR/config.conf"
MAIN_SCRIPT="$BASE_DIR/disk-sentinel.sh"
ADMIN_TOOL="/usr/local/bin/disk-sentinel-admin"
LOG_FILE="/var/log/disk-sentinel.log"

IDLE_TIME_DEFAULT=1800
CHECK_INTERVAL_DEFAULT=300
MIN_IO_DEFAULT=50

echo "==============================================="
echo "  Instal·lador Disk Sentinel (NO-WAKEUP)"
echo "==============================================="
echo ""

# ------------------------------------------------------------
# 1. PREREQUISITS
# ------------------------------------------------------------
echo "[1/7] Verificant prerequisits..."

if ! command -v hdparm >/dev/null 2>&1; then
    echo "  - hdparm no instal·lat, instal·lant..."
    apt-get update && apt-get install -y hdparm
fi

echo "  ✅ hdparm disponible"
echo ""

# ------------------------------------------------------------
# 2. DIRECTORIS
# ------------------------------------------------------------
echo "[2/7] Creant directoris..."

mkdir -p "$BASE_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

echo "  ✅ Directori base: $BASE_DIR"
echo ""

# ------------------------------------------------------------
# 3. DETECCIÓ DE DISCS
# ------------------------------------------------------------
echo "[3/7] Detectant discs..."

get_all_disks() {
    local disks=()
    for d in /dev/sd[a-z] /dev/nvme[0-9]n[0-9]; do
        if [ -b "$d" ] && [[ ! "$d" =~ [0-9]$ ]]; then
            disks+=("$d")
        fi
    done
    echo "${disks[@]}"
}

ALL_DISKS=($(get_all_disks))

echo "  Discs detectats:"
for d in "${ALL_DISKS[@]}"; do
    echo "   - $d"
done
echo ""

# ------------------------------------------------------------
# 4. CONFIGURACIÓ
# ------------------------------------------------------------
echo "[4/7] Creant configuració..."

cat > "$CONFIG_FILE" << CONFIG_EOF
# ============================================================
#   Disk Sentinel - Configuració del sistema
# ============================================================

# Temps global d'inactivitat abans de standby (segons)
IDLE_TIME=$IDLE_TIME_DEFAULT

# Temps per-disc (opcional)
# Exemple:
# IDLE_TIME_sda=600
# IDLE_TIME_sdb=1200

# Interval entre comprovacions (segons)
CHECK_INTERVAL=$CHECK_INTERVAL_DEFAULT

# Mínim I/O per considerar activitat
MIN_IO=$MIN_IO_DEFAULT

# Fitxer de log
LOG_FILE="$LOG_FILE"

# Discs gestionats
DISKS=(${ALL_DISKS[@]})
CONFIG_EOF

echo "  ✅ Configuració creada: $CONFIG_FILE"
echo ""

# ------------------------------------------------------------
# 5. SCRIPT PRINCIPAL (NO-WAKEUP + WAKE-DETECTION)
# ------------------------------------------------------------
echo "[5/7] Creant script principal..."

cat > "$MAIN_SCRIPT" << 'SCRIPT_EOF'
#!/bin/bash
# ============================================================
#   Disk Sentinel - Auto Standby NO-WAKEUP + Wake Detection
# ============================================================

CONFIG_FILE="/usr/local/bin/disk-sentinel/config.conf"
source "$CONFIG_FILE"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

get_io_total() {
    local disk="$1"
    local name="${disk#/dev/}"
    grep " $name " /proc/diskstats | awk '{print $6 + $10}'
}

get_state() {
    local disk="$1"
    local base=$(basename "$disk")
    local path="/sys/block/$base/device/power/runtime_status"
    [ -f "$path" ] && cat "$path" || echo "unknown"
}

declare -A idle_counters
declare -A prev_state

for disk in "${DISKS[@]}"; do
    idle_counters["$disk"]=0
    prev_state["$disk"]="unknown"
done

log "=== Disk Sentinel iniciat (NO-WAKEUP + Wake Detection) ==="

while true; do
    log "--- Cicle ---"

    for disk in "${DISKS[@]}"; do
        [ -b "$disk" ] || continue

        base=$(basename "$disk")
        varname="IDLE_TIME_${base}"
        idle_limit="${!varname:-$IDLE_TIME}"

        state=$(get_state "$disk")

        io_start=$(get_io_total "$disk")
        sleep 10
        io_end=$(get_io_total "$disk")
        io_diff=$((io_end - io_start))

        # Wake detection
        if [ "${prev_state[$disk]}" = "suspended" ] && [ "$io_diff" -gt 0 ]; then
            log "⚠ $disk: despertat externament (I/O: $io_diff)"
        fi
        prev_state["$disk"]="$state"

        if [ "$state" = "suspended" ]; then
            log "💤 $disk: ja en standby"
            idle_counters["$disk"]=0
            continue
        fi

        if [ "$io_diff" -lt "$MIN_IO" ]; then
            idle_counters["$disk"]=$((idle_counters["$disk"] + CHECK_INTERVAL))

            if [ "${idle_counters[$disk]}" -ge "$idle_limit" ]; then
                log "🚀 $disk: forçant standby (límit: ${idle_limit}s)"
                hdparm -y "$disk" >/dev/null 2>&1
                idle_counters["$disk"]=0
            else
                log "⏳ $disk: inactiu (I/O: $io_diff)"
            fi
        else
            log "🔁 $disk: activitat (I/O: $io_diff)"
            idle_counters["$disk"]=0
        fi
    done

    sleep "$CHECK_INTERVAL"
done
SCRIPT_EOF

chmod +x "$MAIN_SCRIPT"
echo "  ✅ Script principal creat"
echo ""

# ------------------------------------------------------------
# 6. SERVEI SYSTEMD
# ------------------------------------------------------------
echo "[6/7] Creant servei systemd..."

cat > "/etc/systemd/system/${SERVICE_NAME}.service" << SERVICE_EOF
[Unit]
Description=Disk Sentinel - Auto Standby NO-WAKEUP + Wake Detection
After=local-fs.target

[Service]
Type=simple
ExecStart=$MAIN_SCRIPT
Restart=always
RestartSec=30
Nice=19
IOSchedulingClass=idle

[Install]
WantedBy=multi-user.target
SERVICE_EOF

echo "  ✅ Servei creat"
echo ""

# ------------------------------------------------------------
# 7. EINA ADMIN (monitor-safe, monitor-real, consulta, config, check, wake-monitor)
# ------------------------------------------------------------
echo "[7/7] Creant eina admin..."

cat > "$ADMIN_TOOL" << 'ADMIN_EOF'
#!/bin/bash
# ============================================================
#   Disk Sentinel - Eina d'Administració
# ============================================================

SERVICE="disk-sentinel"
CONFIG_FILE="/usr/local/bin/disk-sentinel/config.conf"
source "$CONFIG_FILE"

# -------------------------
# Monitor NO-WAKEUP
# -------------------------
monitor_safe() {
    clear
    echo "👁️  Monitor NO-WAKEUP (estat + I/O + logs)"
    echo ""

    declare -A io_prev

    while true; do
        clear
        echo "🕒 $(date '+%Y-%m-%d %H:%M:%S')"
        echo ""
        printf "%-8s %-12s %-12s %-12s\n" "Disc" "Estat" "I/O total" "I/O Δ"
        echo "------------------------------------------------------"

        for d in "${DISKS[@]}"; do
            base=$(basename "$d")
            state=$(cat /sys/block/$base/device/power/runtime_status 2>/dev/null || echo "unknown")
            io_now=$(grep " $base " /proc/diskstats | awk '{print $6 + $10}')

            if [ -z "${io_prev[$base]}" ]; then
                io_delta=0
            else
                io_delta=$((io_now - io_prev[$base]))
            fi

            io_prev[$base]=$io_now

            printf "%-8s %-12s %-12s %-12s\n" "$base" "$state" "$io_now" "$io_delta"
        done

        echo ""
        echo "📄 Últims 10 logs:"
        echo "------------------------------"
        tail -10 "$LOG_FILE" 2>/dev/null || echo "(Encara no hi ha logs)"

        sleep 5
    done
}

# -------------------------
# Monitor REAL (hdparm -C)
# -------------------------
monitor_real() {
    clear
    echo "⚠️  Monitor REAL (usa hdparm -C, pot despertar discs)"
    echo ""

    while true; do
        clear
        echo "🕒 $(date '+%Y-%m-%d %H:%M:%S')"
        echo ""
        printf "%-8s %-20s\n" "Disc" "Estat real"
        echo "--------------------------------------"

        for d in "${DISKS[@]}"; do
            echo -n "$(basename "$d"): "
            hdparm -C "$d" 2>/dev/null | grep "state"
        done

        sleep 5
    done
}

# -------------------------
# Consulta única (hdparm)
# -------------------------
consulta_hdparm() {
    echo "🕒 $(date '+%Y-%m-%d %H:%M:%S')"
    echo "🔍 Estat real dels discs:"
    echo "--------------------------------"
    for d in "${DISKS[@]}"; do
        echo -n "$(basename "$d"): "
        hdparm -C "$d" 2>/dev/null | grep "state"
    done
}

# -------------------------
# Mostrar configuració
# -------------------------
config_show() {
    echo "Configuració actual:"
    echo "--------------------------------"
    echo "  IDLE_TIME global: $IDLE_TIME"
    echo "  MIN_IO: $MIN_IO"
    echo "  CHECK_INTERVAL: $CHECK_INTERVAL"
    echo ""
    echo "  Per-disc:"
    for d in "${DISKS[@]}"; do
        base=$(basename "$d")
        varname="IDLE_TIME_${base}"
        val="${!varname:-$IDLE_TIME}"
        echo "    $base → ${val}s"
    done
    echo ""
    echo "  Discs gestionats:"
    echo "    ${DISKS[@]}"
}

# -------------------------
# Validació + Dry-run
# -------------------------
check_config() {
    echo "Validació de configuració:"
    echo "--------------------------------"

    if ! [[ "$IDLE_TIME" =~ ^[0-9]+$ ]]; then
        echo "❌ IDLE_TIME global no vàlid"
    else
        echo "✔ IDLE_TIME global correcte"
    fi

    if ! [[ "$MIN_IO" =~ ^[0-9]+$ ]]; then
        echo "❌ MIN_IO no vàlid"
    else
        echo "✔ MIN_IO correcte"
    fi

    echo ""
    echo "Per-disc:"
    for d in "${DISKS[@]}"; do
        base=$(basename "$d")
        varname="IDLE_TIME_${base}"
        if [ -n "${!varname}" ]; then
            if [[ "${!varname}" =~ ^[0-9]+$ ]]; then
                echo "✔ $base → ${!varname}s"
            else
                echo "❌ $base → valor no vàlid (${!varname})"
            fi
        else
            echo "✔ $base → usa valor global ($IDLE_TIME)"
        fi
    done

    echo ""
    echo "Simulació:"
    for d in "${DISKS[@]}"; do
        base=$(basename "$d")
        varname="IDLE_TIME_${base}"
        val="${!varname:-$IDLE_TIME}"
        echo "  $base → standby després de ${val}s"
    done
}

# -------------------------
# Wake-monitor
# -------------------------
wake_monitor() {
    clear
    echo "⚠️  Monitor de wakeups externs"
    echo ""

    tail -f "$LOG_FILE" | grep --line-buffered "despertat externament"
}

# -------------------------
# Menú
# -------------------------
case "$1" in
    monitor-safe)   monitor_safe ;;
    monitor-real)   monitor_real ;;
    consulta)       consulta_hdparm ;;
    config)         config_show ;;
    check)          check_config ;;
    wake-monitor)   wake_monitor ;;
    start)          systemctl start "$SERVICE" ;;
    stop)           systemctl stop "$SERVICE" ;;
    restart)        systemctl restart "$SERVICE" ;;
    status)         systemctl status "$SERVICE" ;;
    enable)         systemctl enable "$SERVICE" ;;
    disable)        systemctl disable "$SERVICE" ;;
    logs)           tail -f "$LOG_FILE" ;;
    *)
        echo "Comandes disponibles:"
        echo "  monitor-safe     - Monitor NO-WAKEUP (no desperta discos)"
        echo "  monitor-real     - Monitor amb hdparm -C (pot despertar discos)"
        echo "  consulta         - Consulta única de l'estat real dels discs"
        echo "  config           - Mostra la configuració actual"
        echo "  check            - Validació + simulació (dry-run)"
        echo "  wake-monitor     - Mostra wakeups externs en temps real"
        echo "  start            - Inicia el servei Disk Sentinel"
        echo "  stop             - Atura el servei Disk Sentinel"
        echo "  restart          - Reinicia el servei Disk Sentinel"
        echo "  status           - Mostra l'estat del servei"
        echo "  enable           - Activa el servei en arrencada"
        echo "  disable          - Desactiva el servei en arrencada"
        echo "  logs             - Mostra els últims logs del servei"
        ;;
esac
ADMIN_EOF

chmod +x "$ADMIN_TOOL"
echo "  ✅ Eina admin creada"
echo ""

# ------------------------------------------------------------
# ACTIVAR SERVEI
# ------------------------------------------------------------
systemctl daemon-reload
systemctl enable "$SERVICE_NAME"
systemctl start "$SERVICE_NAME"

echo ""
echo "🎉 Instal·lació completada!"
echo "Comandes:"
echo "  disk-sentinel-admin monitor-safe"
echo "  disk-sentinel-admin monitor-real"
echo "  disk-sentinel-admin consulta"
echo "  disk-sentinel-admin config"
echo "  disk-sentinel-admin check"
echo "  disk-sentinel-admin wake-monitor"
echo "  tail -f $LOG_FILE"
