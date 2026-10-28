#!/bin/bash
set -euo pipefail

# ============================================================================
# programs/environment.sh — Configura variáveis de ambiente e locale
# Baseado no que foi configurado manualmente em /etc/environment e ~/.XCompose
# ============================================================================

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" >&2
}

ENV_FILE="/etc/environment"

# 1. Garantir que PATH padrão tenha /usr/local/sbin, /usr/local/bin, etc.
if ! grep -q 'PATH=' "$ENV_FILE" 2>/dev/null; then
    log_info "Adicionando PATH padrão a $ENV_FILE..."
    sudo tee -a "$ENV_FILE" > /dev/null <<'EOF'
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
EOF
else
    log_info "PATH já está configurado em $ENV_FILE."
fi

# 2. Configurar .XCompose se não existir
XCOMPOSE_FILE="$HOME/.XCompose"
if [[ ! -f "$XCOMPOSE_FILE" ]]; then
    log_info "Criando $XCOMPOSE_FILE..."
    tee "$XCOMPOSE_FILE" > /dev/null <<'EOF'
include "%L"
<Multi_key> <period> <period> : "…"
<Multi_key> <hyphen> <hyphen> <hyphen> : "—"
EOF
else
    log_info "$XCOMPOSE_FILE já existe. Pulando."
fi

# 3. Configurar ibus como IM module (se ainda não estiver)
if ! grep -q "GTK_IM_MODULE" "$ENV_FILE" 2>/dev/null; then
    log_info "Adicionando GTK_IM_MODULE=ibus a $ENV_FILE..."
    sudo tee -a "$ENV_FILE" > /dev/null <<'EOF'
GTK_IM_MODULE=ibus
QT_IM_MODULE=ibus
XMODIFIERS=@im=ibus
EOF
else
    log_info "Variáveis do ibus já estão em $ENV_FILE."
fi

# 4. Desabilitar hotkey de emoji do ibus (via gsettings)
if command -v gsettings >/dev/null 2>&1; then
    log_info "Desabilitando hotkey de emoji do ibus..."
    gsettings set org.freedesktop.ibus.panel.emoji unicode-hotkey "@as []" || \
        log_error "Falha ao aplicar gsettings do ibus (ignorando)."
else
    log_error "gsettings não encontrado. Pulando configuração do ibus."
fi

log_info "Variáveis de ambiente configuradas."
log_info "Nota: algumas alterações em /etc/environment exigem logout/login para surtir efeito."
