#!/bin/bash
set -euo pipefail

# ============================================================================
# programs_to_install_with_apt.sh — Pacotes instalados via apt
# ============================================================================

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" >&2
}

# Atualiza repositórios antes de instalar
log_info "Atualizando repositórios apt..."
sudo apt update

APT_PROGRAMAS=(
    git
    curl
    vim
    neofetch
    tree
    sshfs
    fprintd
    language-pack-gnome-pt
    language-pack-gnome-pt-base
)

log_info "Instalando ${#APT_PROGRAMAS[@]} pacotes via apt..."

for program in "${APT_PROGRAMAS[@]}"; do
    if ! dpkg -s "$program" >/dev/null 2>&1; then
        log_info "Instalando $program..."
        sudo apt install -y "$program"
    else
        log_info "$program já está instalado. Pulando."
    fi
done

log_info "Instalação via apt concluída."
