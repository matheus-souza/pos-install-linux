#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# programs/fira-code.sh — Instala fonte Fira Code (manual do GitHub)
# Nota: o pacote fonts-firacode já é instalado via apt (programs_to_install_with_apt.sh).
# Este script é opcional para quem quer a versão mais recente direto do GitHub.
# ============================================================================

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" >&2
}

fonts_dir="${HOME}/.local/share/fonts"
mkdir -p "${fonts_dir}"

for type in Bold Light Medium Regular Retina; do
    file_path="${fonts_dir}/FiraCode-${type}.ttf"
    file_url="https://github.com/tonsky/FiraCode/raw/master/distr/ttf/FiraCode-${type}.ttf"

    if [[ -e "${file_path}" ]]; then
        log_info "FiraCode-${type} já existe. Pulando."
    else
        log_info "Baixando FiraCode-${type}..."
        curl -fSsL "$file_url" -o "${file_path}" || \
            log_error "Falha ao baixar FiraCode-${type} (continuando)."
    fi
done

log_info "Atualizando cache de fontes..."
fc-cache -f "${fonts_dir}" >/dev/null 2>&1 || fc-cache -f

log_info "Fira Code instalado em ${fonts_dir}."
