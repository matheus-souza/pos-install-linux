#!/bin/bash
# ============================================================================
# scripts/lib/colors.sh - Cores e ícones para scripts de pós-instalação
# ============================================================================

# Cores ANSI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
GRAY='\033[0;90m'
BOLD='\033[1m'
RESET='\033[0m'

# Ícones emoji
ICON_OK="✅"
ICON_ERROR="❌"
ICON_WARNING="⚠️"
ICON_INFO="ℹ️"
ICON_PACKAGE="📦"
ICON_TOOLS="🔧"
ICON_ROCKET="🚀"
ICON_DOWNLOAD="⬇️"
ICON_CHECK="✔️"
ICON_CROSS="❌"
ICON_GEAR="⚙️"
ICON_STAR="⭐"
ICON_FOLDER="📁"
ICON_FILE="📄"
ICON_KEY="🔑"
ICON_LOCK="🔒"
ICON_NET="🌐"
ICON_DISK="💾"
ICON_CPU="🖥️"
ICON_RAM="🧠"
ICON_TIME="⏱️"

# Funções de log com cor
log_info() {
    echo -e "${BLUE}${ICON_INFO}${RESET} $*"
}

log_success() {
    echo -e "${GREEN}${ICON_OK}${RESET} $*"
}

log_warning() {
    echo -e "${YELLOW}${ICON_WARNING}${RESET} $*"
}

log_error() {
    echo -e "${RED}${ICON_ERROR}${RESET} $*" >&2
}

log_step() {
    echo -e "\n${BOLD}${CYAN}${ICON_ROCKET} $*${RESET}"
}

log_substep() {
    echo -e "  ${GRAY}${ICON_GEAR}${RESET} $*"
}

log_package() {
    echo -e "  ${BLUE}${ICON_PACKAGE}${RESET} $*"
}

log_done() {
    echo -e "${GREEN}${ICON_CHECK}${RESET} $*"
}

log_fail() {
    echo -e "${RED}${ICON_CROSS}${RESET} $*" >&2
}

# Função para imprimir uma linha divisória
log_separator() {
    echo "--------------------------------------------------------------------------------"
}

# Função para imprimir cabeçalho de seção
log_header() {
    echo -e "\n${BOLD}${MAGENTA}================================================================================${RESET}"
    echo -e "${BOLD}${MAGENTA}${ICON_STAR} $*${RESET}"
    echo -e "${BOLD}${MAGENTA}================================================================================${RESET}\n"
}
