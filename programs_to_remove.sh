#!/bin/bash
set -euo pipefail

# ============================================================================
# programs_to_remove.sh — Remove programas desnecessários
# Remove apenas pacotes que não são do GNOME nem do LibreOffice.
# ============================================================================

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" >&2
}

remove_if_installed() {
    local pkg="$1"
    if dpkg -s "$pkg" >/dev/null 2>&1; then
        log_info "Removendo $pkg..."
        sudo apt remove --purge -y "$pkg" || log_error "Falha ao remover $pkg (continuando)."
    else
        log_info "$pkg não está instalado. Pulando."
    fi
}

log_info "Iniciando remoção de programas..."

# Navegadores e apps que não são usados no Zorin DDE.
# Pacotes do GNOME e do LibreOffice são mantidos intencionalmente.
PROGRAMS_TO_REMOVE=(
    firefox
    firefox-locale-ar
    firefox-locale-de
    firefox-locale-en
    firefox-locale-es
    firefox-locale-fr
    firefox-locale-it
    firefox-locale-ja
    firefox-locale-pt
    firefox-locale-ru
    firefox-locale-zh-hans
    firefox-locale-zh-hant
    thunderbird
    onboard
    onboard-common
)

for program_name in "${PROGRAMS_TO_REMOVE[@]}"; do
    remove_if_installed "$program_name"
done

log_info "Remoção concluída."
log_info "Pacotes do GNOME e do LibreOffice foram mantidos."
