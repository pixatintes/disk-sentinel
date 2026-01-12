#!/bin/bash
# ============================================================
#   Disk Sentinel – Instal·lador estàndard (NO-WAKEUP)
#   Copyright (C) 2025
#
#   Aquest programa és programari lliure: podeu redistribuir-lo i/o
#   modificar-lo sota els termes de la GNU GPL v3 o posterior.
# ============================================================

set -e

SERVICE_NAME="disk-sentinel"
BASE_DIR="/usr/local/bin/disk-sentinel"
CONFIG_FILE="$BASE_DIR/config.conf"
MAIN_SCRIPT="$BASE_DIR/disk-sentinel.sh"
ADMIN_TOOL="/usr/local/bin/disk-sentinel-admin"
SERVICE_FILE="/etc/systemd/system/disk-sentinel.service"
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
echo "[1/6] Verificant prerequisits..."

if ! command -v hdparm >/dev/null 2>&1; then
    echo "  - hdparm no instal·lat, instal·lant..."
    apt-get update && apt-get install -y hdparm
fi

echo "  ✔ hdparm disponible"
echo ""

# ------------------------------------------------------------
# 2. DIRECTORIS
# ------------------------------------------------------------
echo "[2/6] Creant directoris..."

mkdir -p "$BASE_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

echo "  ✔ Directori base: $BASE_DIR"
echo ""

# ------------------------------------------------------------
# 3. COPIAR FITXERS DEL REPOSITORI
# ------------------------------------------------------------
echo "[3/6] Copiant fitxers del repositori..."

cp ./disk-sentinel.sh "$MAIN_SCRIPT"
cp ./disk-sentinel-admin "$ADMIN_TOOL"
cp ./disk-sentinel.service "$SERVICE_FILE"

chmod +x "$MAIN_SCRIPT"
chmod +x "$ADMIN_TOOL"

echo "  ✔ Scripts copiats"
echo ""

# ------------------------------------------------------------
# 4. DETECCIÓ DE DISCS
# ------------------------------------------------------------
echo "[4/6] Detectant discs..."

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
# 5. CREAR CONFIGURACIÓ
# ------------------------------------------------------------
echo "[5/6] Generant configuració..."

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

echo "  ✔ Configuració creada: $CONFIG_FILE"
echo ""

# ------------------------------------------------------------
# 6. ACTIVAR SERVEI
# ------------------------------------------------------------
echo "[6/6] Activant servei systemd..."

systemctl daemon-reload
systemctl enable "$SERVICE_NAME"
systemctl restart "$SERVICE_NAME"

echo ""
echo "🎉 Instal·lació completada!"
echo ""
echo "Comandes útils:"
echo "  disk-sentinel-admin monitor-safe"
echo "  disk-sentinel-admin monitor-real"
echo "  disk-sentinel-admin consulta"
echo "  disk-sentinel-admin config"
echo "  disk-sentinel-admin check"
echo "  disk-sentinel-admin wake-monitor"
echo "  tail -f $LOG_FILE"
echo ""
