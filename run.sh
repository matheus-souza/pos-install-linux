#!/bin/bash
set -euo pipefail

# ============================================================================
# run.sh — Orquestrador de pós-instalação (Zorin OS 18 / Ubuntu 24.04 Noble)
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" >&2
}

# Verifica se o script tem privilégios de sudo
check_sudo() {
    if ! sudo -n true 2>/dev/null; then
        log_error "Este script requer privilégios de sudo. Execute com: sudo ./run.sh ou configure o sudo sem senha."
        exit 1
    fi
}

# Limpa locks de apt/dpkg em caso de falha (apenas se existirem)
cleanup_locks() {
    log_info "Limpando locks de apt/dpkg, se existirem..."
    sudo rm -f /var/lib/apt/lists/lock \
               /var/lib/dpkg/lock \
               /var/lib/dpkg/lock-frontend \
               /var/cache/apt/archives/lock 2>/dev/null || true
    sudo dpkg --configure -a 2>/dev/null || true
}

trap cleanup_locks EXIT

programs_to_remove() {
    log_info "Removendo programas desnecessários..."
    "${SCRIPT_DIR}/programs_to_remove.sh"
}

programs_to_install_with_apt() {
    log_info "Instalando programas via apt..."
    "${SCRIPT_DIR}/programs_to_install_with_apt.sh"
}

programs_to_install_with_snap() {
    log_info "Instalando programas via snap..."
    "${SCRIPT_DIR}/programs_to_install_with_snap.sh"
}

configure_rm_unused_snaps() {
    log_info "Configurando remoção de snaps não usados..."
    "${SCRIPT_DIR}/configure_rm_unused_snaps.sh"
}

update_upgrade() {
    log_info "Atualizando repositórios e pacotes..."
    sudo apt update
    sudo apt upgrade -y
    sudo apt dist-upgrade -y
}

autoremove_autoclean() {
    log_info "Removendo dependências órfãs e limpando cache..."
    sudo apt autoremove -y
    sudo apt autoclean -y
}

main() {
    check_sudo

    log_info "=== Iniciando pós-instalação ==="

    # 1. Atualizar sistema
    update_upgrade

    # 2. Instalar fontes da Microsoft (aceita EULA automaticamente)
    log_info "Instalando ttf-mscorefonts-installer..."
    sudo apt install -y ttf-mscorefonts-installer

    # 3. Remover programas desnecessários
    programs_to_remove

    # 4. Atualizar novamente após remoções
    update_upgrade
    autoremove_autoclean

    # 5. Instalar programas via apt
    programs_to_install_with_apt

    # 6. Instalar programas via snap
    programs_to_install_with_snap

    # 7. Executar scripts de configuração em programs/
    for program in "${SCRIPT_DIR}"/programs/*.sh; do
        log_info "Executando $(basename "${program}")..."
        bash "${program}"
    done

    # 8. Limpeza final
    update_upgrade
    autoremove_autoclean

    # 9. Configurações do sistema
    log_info "Aplicando configurações do sistema..."
    gsettings set org.freedesktop.ibus.panel.emoji unicode-hotkey "@as []" || \
        log_error "Falha ao aplicar gsettings do ibus (ignorado)."

    # 10. Remover snaps não usados
    configure_rm_unused_snaps

    log_info "=== Pós-instalação concluída com sucesso ==="
}

main "$@"
