#!/bin/bash
set -euo pipefail

# ============================================================================
# programs/ssh.sh — Configura chaves SSH e ~/.ssh/config
# Baseado no que foi configurado manualmente nesta máquina.
# ============================================================================

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" >&2
}

SSH_DIR="$HOME/.ssh"
KEY_FILE="$SSH_DIR/id_ed25519"
CONFIG_FILE="$SSH_DIR/config"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# 1. Gerar chave SSH se não existir
if [[ ! -f "$KEY_FILE" ]]; then
    log_info "Gerando chave SSH Ed25519..."
    ssh-keygen -t ed25519 -f "$KEY_FILE" -N "" -C "$USER@$(hostname)" || \
        log_error "Falha ao gerar chave SSH (continuando)."
else
    log_info "Chave SSH já existe em $KEY_FILE. Pulando geração."
fi

# 2. Mostrar a chave pública para o usuário adicionar no GitHub/GitLab
if [[ -f "${KEY_FILE}.pub" ]]; then
    log_info "=== Sua chave pública SSH ==="
    cat "${KEY_FILE}.pub"
    log_info "================================"
    log_info "Adicione esta chave no GitHub (https://github.com/settings/keys) ou GitLab."
fi

# 3. Criar ~/.ssh/config se não existir
if [[ ! -f "$CONFIG_FILE" ]]; then
    log_info "Criando $CONFIG_FILE..."
    tee "$CONFIG_FILE" > /dev/null <<'EOF'
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes

Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
EOF
    chmod 600 "$CONFIG_FILE"
else
    log_info "$CONFIG_FILE já existe. Pulando criação."
fi

log_info "SSH configurado."
log_info "Teste com: ssh -T git@github.com"
