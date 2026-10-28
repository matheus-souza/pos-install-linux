#!/bin/bash
set -euo pipefail

# ============================================================================
# programs_to_remove.sh — Remove programas desnecessários
# Uso: ./programs_to_remove.sh [--full]
#   Sem --full: remove apenas navegadores/jogos on-board e apps óbvios.
#   Com --full: remove também LibreOffice, GNOME Terminal e relacionados.
# ============================================================================

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" >&2
}

REMOVE_FULL=false

if [[ "${1:-}" == "--full" ]]; then
    REMOVE_FULL=true
fi

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

# Navegadores e apps que não são usados no Zorin DDE
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
    gnome-2048
    gnome-chess
    gnome-mahjongg
    gnome-sudoku
)

for program_name in "${PROGRAMS_TO_REMOVE[@]}"; do
    remove_if_installed "$program_name"
done

if $REMOVE_FULL; then
    log_info "Modo --full ativado: removendo LibreOffice, GNOME Terminal e relacionados..."
    FULL_REMOVE=(
        libreoffice
        libreoffice-base-core
        libreoffice-calc
        libreoffice-common
        libreoffice-core
        libreoffice-draw
        libreoffice-gtk
        libreoffice-gtk2
        libreoffice-gtk3
        libreoffice-help-common
        libreoffice-help-pt
        libreoffice-impress
        libreoffice-l10n-pt
        libreoffice-math
        libreoffice-style-colibre
        libreoffice-style-tango
        libreoffice-writer
        gnome-screenshot
        gnome-calculator
        gnome-terminal
        gnome-terminal-data
    )
    for program_name in "${FULL_REMOVE[@]}"; do
        remove_if_installed "$program_name"
    done
else
    log_info "Modo padrão: pulando remoção de LibreOffice e GNOME Terminal. Use --full para removê-los."
fi

log_info "Remoção concluída."
