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
