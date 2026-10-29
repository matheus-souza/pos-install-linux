#!/bin/bash
set -euo pipefail

# ============================================================================
# programs/dev-tools.sh — Instala SDKMAN, Java 21, NVM e Node.js
# Baseado na instalação manual feita nesta máquina (Zorin 18 / Ubuntu 24.04)
# ============================================================================

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" >&2
}

# 1. SDKMAN
SDKMAN_DIR="$HOME/.sdkman"
if [[ -d "$SDKMAN_DIR" ]]; then
    log_info "SDKMAN já está instalado."
else
    log_info "Instalando SDKMAN..."
    curl -s "https://get.sdkman.io" | bash || \
        log_error "Falha ao instalar SDKMAN (continuando)."
fi

# 2. Java via SDKMAN (apenas se sdkman estiver disponível)
if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
    # Desabilitar set -u temporariamente porque sdkman-init.sh referencia
    # variáveis que podem não estar definidas
    set +u
    # shellcheck source=/dev/null
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
    set -u
    if ! sdk list java 2>/dev/null | grep -q "21.0.9"; then
        log_info "Instalando Java 21 via SDKMAN..."
        sdk install java 21.0.9.0+116386-jbr || \
            log_error "Falha ao instalar Java 21 via SDKMAN (ignorando)."
    else
        log_info "Java 21 já está instalado via SDKMAN."
    fi
else
    log_error "SDKMAN não encontrado. Pulando instalação de Java."
fi

# 3. NVM
NVM_DIR="$HOME/.nvm"
if [[ -d "$NVM_DIR" ]]; then
    log_info "NVM já está instalado."
else
    log_info "Instalando NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh | bash || \
        log_error "Falha ao instalar NVM (continuando)."
fi

# 4. Node.js via NVM
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    # shellcheck source=/dev/null
    source "$NVM_DIR/nvm.sh"
    if ! nvm list 2>/dev/null | grep -q "lts/krypton\|v24"; then
        log_info "Instalando Node.js LTS via NVM..."
        nvm install lts/krypton || \
            log_error "Falha ao instalar Node.js LTS via NVM (ignorando)."
        nvm use lts/krypton || true
        nvm alias default lts/krypton || true
    else
        log_info "Node.js LTS já está instalado via NVM."
    fi
else
    log_error "NVM não encontrado. Pulando instalação de Node.js."
fi

log_info "Ferramentas de desenvolvimento configuradas."
log_info "Reinicie o terminal para que sdkman e nvm fiquem disponíveis."
