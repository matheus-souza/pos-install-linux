#!/bin/bash
set -euo pipefail

# ============================================================================
# programs/chrome.sh — Instala Google Chrome Stable
# Usa signed-by com keyring (método moderno do apt, sem apt-key)
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/colors.sh"

KEYRING="/usr/share/keyrings/google-chrome.gpg"
SOURCE_LIST="/etc/apt/sources.list.d/google-chrome.sources"

if dpkg -s google-chrome-stable >/dev/null 2>&1; then
    log_info "Google Chrome já está instalado. Pulando."
    exit 0
fi

log_info "Baixando chave GPG do Google Chrome..."
sudo mkdir -p /etc/apt/keyrings
curl -fSsL https://dl.google.com/linux/linux_signing_key.pub | \
    sudo gpg --dearmor -o "$KEYRING"
sudo chmod a+r "$KEYRING"

log_info "Adicionando repositório do Google Chrome..."
printf '%s\n' \
    'Types: deb' \
    'URIs: https://dl.google.com/linux/chrome/deb/' \
    'Suites: stable' \
    'Components: main' \
    "Architectures: $(dpkg --print-architecture)" \
    "Signed-By: ${KEYRING}" | \
    sudo tee "$SOURCE_LIST" > /dev/null

log_info "Atualizando repositórios e instalando google-chrome-stable..."
sudo apt update
sudo apt install -y google-chrome-stable

log_success "Google Chrome instalado com sucesso."
