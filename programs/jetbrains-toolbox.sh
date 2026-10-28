#!/bin/bash
set -euo pipefail

# ============================================================================
# programs/jetbrains-toolbox.sh — Instala JetBrains Toolbox
# Baixa a versão mais recente e extrai para ~/Downloads
# ============================================================================

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" >&2
}

DOWNLOAD_DIR="$HOME/Downloads"
TOOLBOX_DIR="${DOWNLOAD_DIR}/jetbrains-toolbox"
INSTALL_SCRIPT="${TOOLBOX_DIR}/jetbrains-toolbox"

if [[ -x "$INSTALL_SCRIPT" ]]; then
    log_info "JetBrains Toolbox já está extraído em ${TOOLBOX_DIR}. Pulando."
    exit 0
fi

log_info "Baixando JetBrains Toolbox..."
curl -fsSL "https://www.jetbrains.com/toolbox/app/" -o /tmp/jetbrains-toolbox.html 2>/dev/null || true

# Tenta extrair a URL do tarball Linux da página do JetBrains
TOOLBOX_URL=$(grep -o 'https://download-cf.jetbrains.com/toolbox/jetbrains-toolbox-[0-9.]*-linux.tar.gz' /tmp/jetbrains-toolbox.html 2>/dev/null | head -1 || true)

if [[ -z "$TOOLBOX_URL" ]]; then
    log_error "Não foi possível detectar a URL mais recente do JetBrains Toolbox."
    log_info "Tente acessar https://www.jetbrains.com/toolbox/app/ e baixar manualmente."
    exit 1
fi

TOOLBOX_TARBALL="${DOWNLOAD_DIR}/$(basename "$TOOLBOX_URL")"

log_info "URL detectada: $TOOLBOX_URL"
log_info "Baixando para $TOOLBOX_TARBALL..."

curl -fSsL "$TOOLBOX_URL" -o "$TOOLBOX_TARBALL"

log_info "Extraindo..."
tar -xzf "$TOOLBOX_TARBALL" -C "$DOWNLOAD_DIR"

# Encontra o diretório extraído
EXTRACTED_DIR=$(find "${DOWNLOAD_DIR}" -maxdepth 1 -name 'jetbrains-toolbox-*' -type d -printf '%T+ %p\n' 2>/dev/null | sort -r | head -1 | cut -d' ' -f2- || true)

if [[ -z "$EXTRACTED_DIR" ]]; then
    log_error "Falha ao extrair o JetBrains Toolbox."
    exit 1
fi

log_info "JetBrains Toolbox extraído em: $EXTRACTED_DIR"
log_info "Execute: $EXTRACTED_DIR/jetbrains-toolbox"
