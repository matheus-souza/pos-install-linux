#!/bin/bash
set -euo pipefail

# ============================================================================
# configure_rm_unused_snaps.sh — Instala o utilitário remove-unused-snaps
# Baixa o script de um Gist e o coloca em /usr/local/bin
# ============================================================================

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" >&2
}

GIST_URL="https://gist.githubusercontent.com/matheus-souza/49f7fb27eea56a230be1bd5942c8cc31/raw/bd08e376811996e5ab867a4c06cc52ffffb92dc5/remove-unused-snaps"
DEST_DIR="$HOME/Downloads"
DEST_FILE="${DEST_DIR}/remove-unused-snaps"
INSTALL_PATH="/usr/local/bin/remove-unused-snaps"

log_info "Baixando remove-unused-snaps do Gist..."

mkdir -p "$DEST_DIR"

if ! curl -fSsL "$GIST_URL" -o "$DEST_FILE"; then
    log_error "Falha ao baixar o script do Gist. Verifique a URL ou sua conexão."
    exit 1
fi

if [[ ! -s "$DEST_FILE" ]]; then
    log_error "O arquivo baixado está vazio. Abortando."
    exit 1
fi

log_info "Copiando para $INSTALL_PATH..."
sudo cp "$DEST_FILE" "$INSTALL_PATH"
sudo chmod u+rwx,g+rx,a+rx "$INSTALL_PATH"

log_info "remove-unused-snaps instalado com sucesso em $INSTALL_PATH."
log_info "Para executar: sudo remove-unused-snaps"
