#!/bin/bash
set -euo pipefail

# ============================================================================
# programs/sublime-text.sh — Instala Sublime Text 4
# Usa signed-by com keyring (método moderno do apt, sem apt-key)
# Configurações baixadas para ~/.config/sublime-text (ST 4)
# ============================================================================

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" >&2
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PREF_SRC="${SCRIPT_DIR}/../config/sublime-text/Preferences.sublime-settings"
PKGCTRL_SRC="${SCRIPT_DIR}/../config/sublime-text/Package Control.sublime-settings"
KEYRING="/etc/apt/keyrings/sublimehq-pub.asc"
SOURCE_LIST="/etc/apt/sources.list.d/sublime-text.sources"

if dpkg -s sublime-text >/dev/null 2>&1; then
    log_info "Sublime Text já está instalado. Pulando instalação do pacote."
else
    log_info "Baixando chave GPG do Sublime Text..."
    sudo mkdir -p /etc/apt/keyrings
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | \
        sudo tee "$KEYRING" > /dev/null
    sudo chmod a+r "$KEYRING"

    log_info "Adicionando repositório do Sublime Text..."
    printf '%s\n' \
        'Types: deb' \
        'URIs: https://download.sublimetext.com/' \
        'Suites: apt/stable/' \
        "Architectures: $(dpkg --print-architecture)" \
        "Signed-By: ${KEYRING}" | \
        sudo tee "$SOURCE_LIST" > /dev/null

    log_info "Atualizando repositórios e instalando sublime-text..."
    sudo apt update
    sudo apt install -y sublime-text
fi

log_info "Configurando diretórios do Sublime Text..."
mkdir -p "$USER_DIR"
mkdir -p "$INSTALLED_PACKAGES_DIR"

log_info "Baixando Package Control..."
if [[ ! -f "${INSTALLED_PACKAGES_DIR}/Package Control.sublime-package" ]]; then
    wget -qO "${INSTALLED_PACKAGES_DIR}/Package Control.sublime-package" \
        "https://packagecontrol.io/Package%20Control.sublime-package" || \
        log_error "Falha ao baixar Package Control (ignorado)."
fi

log_info "Copiando Preferences.sublime-settings..."
if [[ -f "$PREF_SRC" ]]; then
    cp "$PREF_SRC" "${USER_DIR}/Preferences.sublime-settings" || \
        log_error "Falha ao copiar Preferences.sublime-settings (ignorado)."
else
    log_error "Arquivo de origem não encontrado: $PREF_SRC (ignorado)."
fi

log_info "Copiando Package Control.sublime-settings..."
if [[ -f "$PKGCTRL_SRC" ]]; then
    cp "$PKGCTRL_SRC" "${USER_DIR}/Package Control.sublime-settings" || \
        log_error "Falha ao copiar Package Control.sublime-settings (ignorado)."
else
    log_error "Arquivo de origem não encontrado: $PKGCTRL_SRC (ignorado)."
fi

log_info "Sublime Text configurado com sucesso."
log_info "Abra o Sublime Text para finalizar a instalação do Package Control."
