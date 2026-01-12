#!/bin/bash
# ============================================================
#   Disk Sentinel – Desinstal·lador complet
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
echo "[1/6] Aturant servei..."

systemctl stop "$SERVICE_NAME" 2>/dev/null || true
systemctl disable "$SERVICE_NAME" 2>/dev/null || true

echo "  ✔ Servei aturat i desactivat"
echo ""

# ------------------------------------------------------------
# 2. Eliminar fitxer de servei
# ------------------------------------------------------------
echo "[2/6] Eliminant servei systemd..."

rm -f "$SERVICE_FILE"
rm -f /etc/systemd/system/multi-user.target.wants/disk-sentinel.service

echo "  ✔ Fitxer de servei eliminat"
echo ""

# ------------------------------------------------------------
# 3. Eliminar scripts i configuració
# ------------------------------------------------------------
echo "[3/6] Eliminant scripts i configuració..."

rm -rf "$BASE_DIR"
rm -f "$ADMIN_TOOL"

echo "  ✔ Scripts eliminats"
echo ""

# ------------------------------------------------------------
# 4. Eliminar logs
# ------------------------------------------------------------
echo "[4/6] Eliminant logs..."

rm -f "$LOG_FILE"

echo "  ✔ Logs eliminats"
echo ""

# ------------------------------------------------------------
# 5. Reload systemd
# ------------------------------------------------------------
echo "[5/6] Actualitzant systemd..."

systemctl daemon-reload
systemctl reset-failed "$SERVICE_NAME" 2>/dev/null || true

echo "  ✔ systemd actualitzat"
echo ""

# ------------------------------------------------------------
# 6. Final
# ------------------------------------------------------------
echo "🎉 Desinstal·lació completada!"
echo "Disk Sentinel ha estat eliminat completament del sistema."
