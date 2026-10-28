#!/bin/bash
set -euo pipefail

# ============================================================================
# programs/browsers.sh — Instala navegadores extras (Brave, Edge, Vivaldi, Opera)
# Usa signed-by com keyring (método moderno do apt, sem apt-key)
# ============================================================================

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" >&2
}

install_brave() {
    if dpkg -s brave-browser >/dev/null 2>&1; then
        log_info "Brave já está instalado. Pulando."
        return
    fi

    log_info "Instalando Brave Browser..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg | \
        sudo gpg --dearmor -o /etc/apt/keyrings/brave-browser.gpg
    sudo chmod a+r /etc/apt/keyrings/brave-browser.gpg

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/brave-browser.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | \
        sudo tee /etc/apt/sources.list.d/brave-browser.sources > /dev/null

    sudo apt update
    sudo apt install -y brave-browser
    log_info "Brave instalado."
}

install_edge() {
    if dpkg -s microsoft-edge-stable >/dev/null 2>&1; then
        log_info "Microsoft Edge já está instalado. Pulando."
        return
    fi

    log_info "Instalando Microsoft Edge..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | \
        sudo gpg --dearmor -o /etc/apt/keyrings/microsoft-edge.gpg
    sudo chmod a+r /etc/apt/keyrings/microsoft-edge.gpg

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft-edge.gpg] https://packages.microsoft.com/repos/edge stable main" | \
        sudo tee /etc/apt/sources.list.d/microsoft-edge.sources > /dev/null

    sudo apt update
    sudo apt install -y microsoft-edge-stable
    log_info "Microsoft Edge instalado."
}

install_vivaldi() {
    if dpkg -s vivaldi-stable >/dev/null 2>&1; then
        log_info "Vivaldi já está instalado. Pulando."
        return
    fi

    log_info "Instalando Vivaldi..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.vivaldi.com/archive/linux_signing_key.pub | \
        sudo gpg --dearmor -o /etc/apt/keyrings/vivaldi.gpg
    sudo chmod a+r /etc/apt/keyrings/vivaldi.gpg

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/vivaldi.gpg] https://repo.vivaldi.com/archive/ stable main" | \
        sudo tee /etc/apt/sources.list.d/vivaldi.sources > /dev/null

    sudo apt update
    sudo apt install -y vivaldi-stable
    log_info "Vivaldi instalado."
}

install_opera() {
    if dpkg -s opera-stable >/dev/null 2>&1; then
        log_info "Opera já está instalado. Pulando."
        return
    fi

    log_info "Instalando Opera..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://deb.opera.com/archive.key | \
        sudo gpg --dearmor -o /etc/apt/keyrings/opera.gpg
    sudo chmod a+r /etc/apt/keyrings/opera.gpg

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/opera.gpg] https://deb.opera.com/opera-stable stable main" | \
        sudo tee /etc/apt/sources.list.d/opera.sources > /dev/null

    sudo apt update
    sudo apt install -y opera-stable
    log_info "Opera instalado."
}

install_brave
install_edge
install_vivaldi
install_opera

log_info "Navegadores configurados."
