#!/bin/bash
set -euo pipefail

# ============================================================================
# programs/insync.sh — Instala Insync
# Repo: Ubuntu Noble (24.04). Usa signed-by com keyring (sem apt-key).
# ============================================================================

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" >&2
}

KEYRING="/etc/apt/keyrings/insync-archive-keyring.gpg"
SOURCE_LIST="/etc/apt/sources.list.d/insync.sources"

if dpkg -s insync >/dev/null 2>&1; then
    log_info "Insync já está instalado. Pulando."
    exit 0
fi

log_info "Baixando chave GPG do Insync..."
sudo mkdir -p /etc/apt/keyrings
curl -L https://apt.insync.io/insynchq.gpg 2>/dev/null | \
    gpg --dearmor | sudo tee "$KEYRING" > /dev/null
sudo chmod a+r "$KEYRING"

log_info "Adicionando repositório do Insync (noble)..."
printf '%s\n' \
    'Types: deb' \
    'URIs: http://apt.insync.io/ubuntu' \
    'Suites: noble' \
    'Components: non-free contrib' \
    "Architectures: $(dpkg --print-architecture)" \
    "Signed-By: ${KEYRING}" | \
    sudo tee "$SOURCE_LIST" > /dev/null

log_info "Atualizando repositórios e instalando insync..."
sudo apt update
sudo apt install -y insync

log_info "Insync instalado com sucesso."
