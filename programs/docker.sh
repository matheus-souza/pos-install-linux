#!/bin/bash
set -euo pipefail

# ============================================================================
# programs/docker.sh — Instala Docker CE e Docker Compose v2 (plugin)
# Usa signed-by com keyring (método moderno do apt, sem apt-key)
# ============================================================================

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" >&2
}

KEYRING="/etc/apt/keyrings/docker.gpg"
SOURCE_LIST="/etc/apt/sources.list.d/docker.sources"

# Remove versões antigas se existirem
for old_pkg in docker docker-engine docker.io containerd runc; do
    if dpkg -s "$old_pkg" >/dev/null 2>&1; then
        log_info "Removendo versão antiga: $old_pkg..."
        sudo apt remove --purge -y "$old_pkg" || true
    fi
done

if dpkg -s docker-ce >/dev/null 2>&1; then
    log_info "Docker CE já está instalado. Pulando instalação."
else
    log_info "Instalando dependências do apt..."
    sudo apt update
    sudo apt install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        software-properties-common

    log_info "Baixando chave GPG do Docker..."
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        sudo gpg --dearmor -o "$KEYRING"
    sudo chmod a+r "$KEYRING"

    log_info "Adicionando repositório do Docker..."
    echo "deb [arch=$(dpkg --print-architecture) signed-by=${KEYRING}] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
        sudo tee "$SOURCE_LIST" > /dev/null

    log_info "Atualizando repositórios e instalando Docker CE..."
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
fi

# Adiciona usuário ao grupo docker (idempotente)
if ! groups "$USER" | grep -q '\bdocker\b'; then
    log_info "Adicionando usuário $USER ao grupo docker..."
    sudo usermod -aG docker "$USER"
    log_info "Nota: faça logout e login novamente (ou newgrp docker) para aplicar o grupo docker."
else
    log_info "Usuário $USER já pertence ao grupo docker."
fi

log_info "Docker CE e Docker Compose v2 instalados com sucesso."
log_info "Versão do Docker: $(docker --version 2>/dev/null || echo 'não disponível ainda')"
log_info "Versão do Compose: $(docker compose version 2>/dev/null || echo 'não disponível ainda')"
