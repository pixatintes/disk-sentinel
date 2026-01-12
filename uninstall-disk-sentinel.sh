#!/bin/bash
# ============================================================
#   Disk Sentinel – Desinstal·lador complet
#   Elimina servei, scripts, configuració i logs
# ============================================================

set -e

SERVICE_NAME="disk-sentinel"
BASE_DIR="/usr/local/bin/disk-sentinel"
ADMIN_TOOL="/usr/local/bin/disk-sentinel-admin"
SERVICE_FILE="/etc/systemd/system/disk-sentinel.service"
LOG_FILE="/var/log/disk-sentinel.log"

echo "==============================================="
echo "  Desinstal·lador Disk Sentinel"
echo "==============================================="
echo ""

# ------------------------------------------------------------
# 1. Aturar i desactivar servei
# ------------------------------------------------------------
echo "[1/5] Aturant servei..."

if systemctl is-active --quiet "$SERVICE_NAME"; then
    systemctl stop "$SERVICE_NAME"
    echo "  ✔ Servei aturat"
else
    echo "  (El servei no estava actiu)"
fi

if systemctl is-enabled --quiet "$SERVICE_NAME"; then
    systemctl disable "$SERVICE_NAME"
    echo "  ✔ Servei desactivat"
else
    echo "  (El servei no estava habilitat)"
fi

echo ""

# ------------------------------------------------------------
# 2. Eliminar fitxer de servei
# ------------------------------------------------------------
echo "[2/5] Eliminant servei systemd..."

if [ -f "$SERVICE_FILE" ]; then
    rm -f "$SERVICE_FILE"
    echo "  ✔ Fitxer de servei eliminat"
else
    echo "  (No existeix cap fitxer de servei)"
fi

echo ""

# ------------------------------------------------------------
# 3. Eliminar scripts i configuració
# ------------------------------------------------------------
echo "[3/5] Eliminant scripts i configuració..."

if [ -d "$BASE_DIR" ]; then
    rm -rf "$BASE_DIR"
    echo "  ✔ Directori $BASE_DIR eliminat"
else
    echo "  (No existeix el directori del programa)"
fi

if [ -f "$ADMIN_TOOL" ]; then
    rm -f "$ADMIN_TOOL"
    echo "  ✔ Eina admin eliminada"
else
    echo "  (No existeix l'eina admin)"
fi

echo ""

# ------------------------------------------------------------
# 4. Eliminar logs
# ------------------------------------------------------------
echo "[4/5] Eliminant logs..."

if [ -f "$LOG_FILE" ]; then
    rm -f "$LOG_FILE"
    echo "  ✔ Log eliminat"
else
    echo "  (No existeix cap log)"
fi

echo ""

# ------------------------------------------------------------
# 5. Reload systemd
# ------------------------------------------------------------
echo "[5/5] Actualitzant systemd..."

systemctl daemon-reload

echo ""
echo "🎉 Desinstal·lació completada!"
echo "Disk Sentinel ha estat eliminat completament del sistema."
