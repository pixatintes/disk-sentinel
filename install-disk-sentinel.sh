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
# 3. DESCARREGAR FITXERS SI CAL
# ------------------------------------------------------------
echo "[3/6] Verificant fitxers del repositori..."

REPO_RAW="https://raw.githubusercontent.com/pixatintes/disk-sentinel/main"
REQUIRED_FILES=("disk-sentinel.sh" "disk-sentinel-admin" "disk-sentinel.service")
MISSING=false
TMP_DOWNLOAD_DIR=""

# Primer, comprovem si falten fitxers al directori actual
for f in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "./$f" ]; then
        MISSING=true
    fi
done

# Si falta algun fitxer, els descarreguem tots a un directori temporal
if [ "$MISSING" = true ]; then
    echo "  - Alguns fitxers no es troben localment, descarregant al directori temporal..."

    if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
        echo "  ✘ Error: cal curl o wget per descarregar els fitxers." >&2
        exit 1
    fi

    TMP_DOWNLOAD_DIR="$(mktemp -d)"

    for f in "${REQUIRED_FILES[@]}"; do
        echo "  - Descarregant $f..."
        if command -v curl >/dev/null 2>&1; then
            curl -fsSL "$REPO_RAW/$f" -o "$TMP_DOWNLOAD_DIR/$f" || { echo "  ✘ Error descarregant $f" >&2; exit 1; }
        else
            wget -q "$REPO_RAW/$f" -O "$TMP_DOWNLOAD_DIR/$f" || { echo "  ✘ Error descarregant $f" >&2; exit 1; }
        fi
        echo "  ✔ $f descarregat"
    done

    # Ens situem al directori temporal perquè la resta de l'script pugui fer servir ./<fitxer>
    cd "$TMP_DOWNLOAD_DIR"
else
    echo "  ✔ Tots els fitxers presents localment"
fi
echo ""

# ------------------------------------------------------------
# 4. COPIAR FITXERS
# ------------------------------------------------------------
echo "[4/6] Copiant fitxers..."

cp ./disk-sentinel.sh "$MAIN_SCRIPT"
cp ./disk-sentinel-admin "$ADMIN_TOOL"
cp ./disk-sentinel.service "$SERVICE_FILE"

chmod +x "$MAIN_SCRIPT"
chmod +x "$ADMIN_TOOL"

echo "  ✔ Scripts copiats"
echo ""

# ------------------------------------------------------------
# 5. DETECCIÓ DE DISCS
# ------------------------------------------------------------
echo "[5/7] Detectant discs..."

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
# 6. CREAR CONFIGURACIÓ
# ------------------------------------------------------------
echo "[6/7] Generant configuració..."

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
# 7. ACTIVAR SERVEI
# ------------------------------------------------------------
echo "[7/7] Activant servei systemd..."

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
