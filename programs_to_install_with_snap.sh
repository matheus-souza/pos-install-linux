#!/bin/bash
set -euo pipefail

# ============================================================================
# programs_to_install_with_snap.sh — Pacotes instalados via snap
# Nenhum snap está instalado nesta máquina. Lista mantida para referência futura.
# ============================================================================

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" >&2
}

SNAP_PROGRAMS=()

SNAP_CLASSIC_PROGRAMS=()

if [[ ${#SNAP_PROGRAMS[@]} -eq 0 && ${#SNAP_CLASSIC_PROGRAMS[@]} -eq 0 ]]; then
    log_info "Nenhum programa configurado para instalação via snap. Pulando."
    exit 0
fi

log_info "Instalando snaps..."

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
