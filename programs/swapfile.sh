#!/bin/bash
set -euo pipefail

# ============================================================================
# programs/swapfile.sh — Cria swapfile de 8 GB e adiciona ao /etc/fstab
# Baseado na configuração manual feita nesta máquina.
# ============================================================================

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" >&2
}

SWAPFILE="/swapfile"
SWAP_SIZE="8G"

# Verifica se já existe swapfile ativo
if [[ -f "$SWAPFILE" ]] && sudo swapon --show | grep -q "$SWAPFILE"; then
    log_info "Swapfile $SWAPFILE já está ativo. Pulando."
    exit 0
fi

if [[ -f "$SWAPFILE" ]]; then
    log_info "Swapfile $SWAPFILE existe mas não está ativo. Ativando..."
    sudo chmod 600 "$SWAPFILE"
    sudo mkswap "$SWAPFILE"
    sudo swapon "$SWAPFILE"
else
    log_info "Criando swapfile de $SWAP_SIZE em $SWAPFILE..."
    sudo fallocate -l "$SWAP_SIZE" "$SWAPFILE" || \
        { log_error "fallocate falhou, tentando dd..."; sudo dd if=/dev/zero of="$SWAPFILE" bs=1M count=8192; }
    sudo chmod 600 "$SWAPFILE"
    sudo mkswap "$SWAPFILE"
    sudo swapon "$SWAPFILE"
fi

# Adiciona ao /etc/fstab se ainda não estiver lá
if ! grep -q "$SWAPFILE" /etc/fstab 2>/dev/null; then
    log_info "Adicionando $SWAPFILE ao /etc/fstab..."
    echo "$SWAPFILE none swap sw 0 0" | sudo tee -a /etc/fstab > /dev/null
else
    log_info "$SWAPFILE já consta em /etc/fstab."
fi

log_info "Swapfile configurado com sucesso."
sudo swapon --show
free -h
