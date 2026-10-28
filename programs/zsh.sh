#!/bin/bash
set -euo pipefail

# ============================================================================
# programs/zsh.sh — Instala zsh, Oh My Zsh, tema Spaceship e Zinit
# Idempotente: verifica se cada componente já está instalado.
# ============================================================================

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" >&2
}

# 1. Instalar zsh, curl, git se necessário
if ! command -v zsh >/dev/null 2>&1; then
    log_info "Instalando zsh, curl, git..."
    sudo apt update
    sudo apt install -y zsh curl git
else
    log_info "zsh já está instalado."
fi

# 2. Oh My Zsh
OMZ_DIR="${HOME}/.oh-my-zsh"
if [[ ! -d "$OMZ_DIR" ]]; then
    log_info "Instalando Oh My Zsh (não interativo)..."
    export RUNZSH=no
    export KEEP_ZSHRC=yes
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || \
        log_error "Falha ao instalar Oh My Zsh (continuando)."
else
    log_info "Oh My Zsh já está instalado."
fi

# 3. Tema Spaceship
SPACESHIP_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt"
if [[ ! -d "$SPACESHIP_DIR" ]]; then
    log_info "Instalando tema Spaceship..."
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$SPACESHIP_DIR" --depth=1 || \
        log_error "Falha ao clonar Spaceship (continuando)."
    ln -sf "$SPACESHIP_DIR/spaceship.zsh-theme" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship.zsh-theme" || true
else
    log_info "Tema Spaceship já está instalado."
fi

# 4. Zinit (zdharma-continuum, nome atualizado)
ZINIT_DIR="${HOME}/.local/share/zinit/zinit.git"
if [[ ! -d "$ZINIT_DIR" ]]; then
    log_info "Instalando Zinit..."
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)" || \
        log_error "Falha ao instalar Zinit (continuando)."
else
    log_info "Zinit já está instalado."
fi

# 5. Definir zsh como shell padrão (se ainda não for)
if [[ "$(getent passwd "$USER" | cut -d: -f7)" != "$(command -v zsh)" ]]; then
    log_info "Definindo zsh como shell padrão para $USER..."
    sudo chsh -s "$(command -v zsh)" "$USER" || \
        log_error "Falha ao definir zsh como shell padrão (faça manualmente: chsh -s $(which zsh))."
else
    log_info "zsh já é o shell padrão."
fi

log_info "Configuração do zsh concluída."
log_info "Reinicie o terminal ou execute: zsh"
