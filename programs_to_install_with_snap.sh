#!/bin/bash
set -euo pipefail

# ============================================================================
# programs_to_install_with_snap.sh — Pacotes instalados via snap
# ============================================================================

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" >&2
}

SNAP_PROGRAMS=(
    mailspring
    spotify
    postman
)

SNAP_CLASSIC_PROGRAMS=(
    gitkraken
    slack
)

log_info "Instalando snaps clássicos..."

for program in "${SNAP_PROGRAMS[@]}"; do
    if snap list "$program" >/dev/null 2>&1; then
        log_info "$program já está instalado via snap. Pulando."
    else
        log_info "Instalando $program via snap..."
        sudo snap install "$program"
    fi
done

log_info "Instalando snaps com --classic..."

for program in "${SNAP_CLASSIC_PROGRAMS[@]}"; do
    if snap list "$program" >/dev/null 2>&1; then
        log_info "$program já está instalado via snap (classic). Pulando."
    else
        log_info "Instalando $program via snap --classic..."
        sudo snap install "$program" --classic
    fi
done

log_info "Instalação via snap concluída."
