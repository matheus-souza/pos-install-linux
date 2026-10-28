#!/bin/bash
set -euo pipefail

# ============================================================================
# configure_rm_unused_snaps.sh — Instala o utilitário remove-unused-snaps
# Copia o script de config/remove-unused-snaps.sh para /usr/local/bin
# ============================================================================

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" >&2
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_FILE="${SCRIPT_DIR}/config/remove-unused-snaps.sh"
INSTALL_PATH="/usr/local/bin/remove-unused-snaps"

if [[ ! -f "$SOURCE_FILE" ]]; then
    log_error "Arquivo de origem não encontrado: $SOURCE_FILE"
    exit 1
fi

log_info "Copiando remove-unused-snaps para $INSTALL_PATH..."

sudo cp "$SOURCE_FILE" "$INSTALL_PATH"
sudo chmod u+rwx,g+rx,a+rx "$INSTALL_PATH"

log_info "remove-unused-snaps instalado com sucesso em $INSTALL_PATH."
log_info "Para executar: sudo remove-unused-snaps"
