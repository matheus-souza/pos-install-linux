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

    # Remover qualquer fonte do Brave pré-existente com chave diferente
    sudo rm -f /etc/apt/sources.list.d/*brave*.sources /etc/apt/sources.list.d/*brave*.list 2>/dev/null || true
    if [[ ! -f /etc/apt/sources.list.d/brave-browser.sources ]]; then
        printf '%s\n' \
            'Types: deb' \
            'URIs: https://brave-browser-apt-release.s3.brave.com/' \
            'Suites: stable' \
            'Components: main' \
            "Signed-By: /etc/apt/keyrings/brave-browser.gpg" | \
            sudo tee /etc/apt/sources.list.d/brave-browser.sources > /dev/null
    else
        log_info "Repositório do Brave já está configurado. Pulando."
    fi

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

    # Remover qualquer fonte do Edge pré-existente com chave diferente
    sudo rm -f /etc/apt/sources.list.d/*microsoft-edge*.sources /etc/apt/sources.list.d/*microsoft-edge*.list 2>/dev/null || true
    if [[ ! -f /etc/apt/sources.list.d/microsoft-edge.sources ]]; then
        printf '%s\n' \
            'Types: deb' \
            'URIs: https://packages.microsoft.com/repos/edge' \
            'Suites: stable' \
            'Components: main' \
            "Signed-By: /etc/apt/keyrings/microsoft-edge.gpg" | \
            sudo tee /etc/apt/sources.list.d/microsoft-edge.sources > /dev/null
    else
        log_info "Repositório do Edge já está configurado. Pulando."
    fi

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

    # Remover qualquer fonte do Vivaldi pré-existente com chave diferente
    sudo rm -f /etc/apt/sources.list.d/*vivaldi*.sources /etc/apt/sources.list.d/*vivaldi*.list 2>/dev/null || true
    if [[ ! -f /etc/apt/sources.list.d/vivaldi.sources ]]; then
        printf '%s\n' \
            'Types: deb' \
            'URIs: https://repo.vivaldi.com/archive/deb/' \
            'Suites: stable' \
            'Components: main' \
            "Signed-By: /etc/apt/keyrings/vivaldi.gpg" | \
            sudo tee /etc/apt/sources.list.d/vivaldi.sources > /dev/null
    else
        log_info "Repositório do Vivaldi já está configurado. Pulando."
    fi

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

    # Remover qualquer fonte do Opera pré-existente com chave diferente
    sudo rm -f /etc/apt/sources.list.d/*opera*.sources /etc/apt/sources.list.d/*opera*.list 2>/dev/null || true
    if [[ ! -f /etc/apt/sources.list.d/opera.sources ]]; then
        printf '%s\n' \
            'Types: deb' \
            'URIs: https://deb.opera.com/opera-stable' \
            'Suites: stable' \
            'Components: non-free' \
            "Signed-By: /etc/apt/keyrings/opera.gpg" | \
            sudo tee /etc/apt/sources.list.d/opera.sources > /dev/null
    else
        log_info "Repositório do Opera já está configurado. Pulando."
    fi

    sudo apt update
    sudo apt install -y opera-stable
    log_info "Opera instalado."
}

install_brave
install_edge
install_vivaldi
install_opera

log_info "Navegadores configurados."