#!/bin/bash
set -euo pipefail

# ============================================================================
# programs/vscode.sh — Instala Visual Studio Code e extensões
# Usa signed-by com keyring (método moderno do apt, sem apt-key)
# Mantém o repositório para atualizações futuras.
# ============================================================================

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" >&2
}

KEYRING="/etc/apt/keyrings/packages.microsoft.gpg"
SOURCE_LIST="/etc/apt/sources.list.d/vscode.sources"
SETTINGS_FILE="$HOME/.config/Code/User/settings.json"

if dpkg -s code >/dev/null 2>&1; then
    log_info "Visual Studio Code já está instalado. Pulando instalação do pacote."
else
    log_info "Instalando dependências..."
    sudo apt update
    sudo apt install -y software-properties-common apt-transport-https wget gnupg

    log_info "Baixando chave GPG da Microsoft..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | \
        sudo gpg --dearmor -o "$KEYRING"
    sudo chmod a+r "$KEYRING"

    log_info "Adicionando repositório do VS Code..."
    # Remover qualquer fonte do Microsoft pré-existente com chave diferente
    # para evitar conflito de Signed-By
    sudo rm -f /etc/apt/sources.list.d/*microsoft*.sources /etc/apt/sources.list.d/*microsoft*.list 2>/dev/null || true
    if [[ ! -f "$SOURCE_LIST" ]]; then
        printf '%s\n' \
            'Types: deb' \
            'URIs: https://packages.microsoft.com/ubuntu/24.04/prod' \
            'Suites: noble' \
            'Components: main' \
            "Signed-By: ${KEYRING}" | \
            sudo tee "$SOURCE_LIST" > /dev/null
    else
        log_info "Repositório do VS Code já está configurado. Pulando."
    fi

    log_info "Atualizando repositórios e instalando code..."
    sudo apt update
    sudo apt install -y code
fi

# Extensões do VS Code (versões ativas; removidas extensões descontinuadas)
VSCODE_EXTENSIONS=(
    alefragnani.Bookmarks
    bierner.github-markdown-preview
    bierner.markdown-checkbox
    bierner.markdown-emoji
    bierner.markdown-preview-github-styles
    bierner.markdown-yaml-preamble
    christian-kohler.path-intellisense
    codezombiech.gitignore
    DavidAnson.vscode-markdownlint
    dracula-theme.theme-dracula
    eamodio.gitlens
    EditorConfig.EditorConfig
    HookyQR.beautify
    isudox.vscode-jetbrains-keybindings
    mathiasfrohlich.Kotlin
    mikestead.dotenv
    ms-azuretools.vscode-docker
    MS-CEINTL.vscode-language-pack-pt-BR
    ms-python.python
    ms-python.vscode-pylance
    ms-toolsai.jupyter
    ms-toolsai.jupyter-keymap
    ms-toolsai.jupyter-renderers
    naumovs.color-highlight
    PKief.material-icon-theme
    ritwickdey.LiveServer
    shd101wyy.markdown-preview-enhanced
    streetsidesoftware.code-spell-checker
    streetsidesoftware.code-spell-checker-portuguese-brazilian
)

log_info "Instalando ${#VSCODE_EXTENSIONS[@]} extensões do VS Code..."
for ext in "${VSCODE_EXTENSIONS[@]}"; do
    if code --list-extensions 2>/dev/null | grep -qx "$ext"; then
        log_info "Extensão já instalada: $ext"
    else
        log_info "Instalando extensão: $ext..."
        code --install-extension "$ext" || log_error "Falha ao instalar $ext (continuando)."
    fi
done

log_info "Baixando settings.json..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETTINGS_SRC="${SCRIPT_DIR}/../config/vscode/settings.json"
mkdir -p "$(dirname "$SETTINGS_FILE")"
if [[ -f "$SETTINGS_SRC" ]]; then
    cp "$SETTINGS_SRC" "$SETTINGS_FILE" || \
        log_error "Falha ao copiar settings.json (ignorado)."
else
    log_error "Arquivo de origem não encontrado: $SETTINGS_SRC (ignorado)."
fi

# Configura DDE file manager como padrão para pastas (opcional)
if command -v xdg-mime >/dev/null 2>&1; then
    log_info "Configurando DDE File Manager como padrão para pastas..."
    xdg-mime default dde-file-manager.desktop inode/directory application/x-gnome-saved-search || \
        log_error "Falha ao configurar xdg-mime (ignorado)."
fi

log_info "Visual Studio Code configurado com sucesso."
