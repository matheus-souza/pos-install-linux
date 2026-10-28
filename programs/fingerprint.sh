#!/bin/bash
set -euo pipefail

# ============================================================================
# programs/fingerprint.sh — Configura leitor de digital (fprintd)
# Baseado na instalação manual feita nesta máquina (leitor FPC 10a5:9800)
# ============================================================================

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" >&2
}

if dpkg -s fprintd >/dev/null 2>&1; then
    log_info "fprintd já está instalado. Pulando instalação do pacote."
else
    log_info "Instalando fprintd e libfprint..."
    sudo apt update
    sudo apt install -y fprintd libfprint-2-2
fi

# Regra udev para leitor FPC (se ainda não existir)
UDEV_RULE="/usr/lib/udev/rules.d/60-libfprint-2-device-fpc.rules"
if [[ ! -f "$UDEV_RULE" ]]; then
    log_info "Criando regra udev para leitor de digital FPC..."
    # Ajuste o vendor/product ID conforme o seu leitor (exemplo: 10a5:9800)
    sudo tee "$UDEV_RULE" > /dev/null <<'EOF'
SUBSYSTEM=="usb", ATTR{idVendor}=="10a5", ATTR{idProduct}=="9800", MODE="0666", GROUP="plugdev"
EOF
    sudo udevadm control --reload-rules || true
    sudo udevadm trigger || true
else
    log_info "Regra udev já existe. Pulando."
fi

# Travar libfprint-2-2 para evitar atualizações que quebrem o suporte FPC
if ! dpkg --get-selections | grep -q "^libfprint-2-2[[:space:]]*hold$"; then
    log_info "Travando libfprint-2-2 (hold) para evitar atualizações automáticas..."
    echo "libfprint-2-2 hold" | sudo dpkg --set-selections || \
        log_error "Falha ao travar libfprint-2-2 (ignorando)."
else
    log_info "libfprint-2-2 já está travado (hold)."
fi

log_info "fprintd configurado."
log_info "Para registrar uma digital: fprintd-enroll"
log_info "Para verificar: fprintd-verify"
