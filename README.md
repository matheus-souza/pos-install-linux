# pos-install-linux

Scripts de pós-instalação para Linux (Zorin OS 18 / Ubuntu 24.04 Noble).

Este repositório automatiza a instalação e configuração de programas após uma instalação limpa do sistema.

## Sumário

- [Pré-requisitos](#pré-requisitos)
- [Como usar](#como-usar)
- [Lista de scripts](#lista-de-scripts)
- [CI/CD](#ci-cd)
- [Decisões de projeto](#decisões-de-projeto)
- [Licença](#licença)

## Pré-requisitos

- Ubuntu 24.04 Noble ou derivado (ex.: Zorin OS 18).
- Usuário com privilégios de `sudo`.
- Conexão com a internet.
- Git instalado (`sudo apt install git`).

## Como usar

Clone o repositório:

```bash
git clone https://github.com/matheus-souza/pos-install-linux.git
cd pos-install-linux
```

Torne os scripts executáveis e execute o orquestrador:

```bash
chmod +x run.sh
./run.sh
```

O `run.sh` executa, nesta ordem:

1. Atualiza o sistema (`apt update`, `apt upgrade`, `apt dist-upgrade`).
2. Instala `ttf-mscorefonts-installer`.
3. Remove programas desnecessários (use `--full` para remover também LibreOffice e GNOME Terminal).
4. Instala programas via `apt`.
5. Instala programas via `snap`.
6. Executa todos os scripts em `programs/`.
7. Limpa dependências órfãs e cache do `apt`.
8. Aplica configurações do sistema (`gsettings`, `/etc/environment`).
9. Remove snaps não usados.

Você também pode executar scripts individualmente:

```bash
bash programs/chrome.sh
bash programs/docker.sh
bash programs/zsh.sh
```

## Lista de scripts

### Orquestrador e suporte

| Script | Descrição |
|--------|-----------|
| `run.sh` | Orquestra toda a pós-instalação. |
| `programs_to_install_with_apt.sh` | Instala pacotes via `apt` (idempotente). |
| `programs_to_install_with_snap.sh` | Instala pacotes via `snap` (idempotente). |
| `programs_to_remove.sh` | Remove programas desnecessários (`--full` para mais). |
| `configure_rm_unused_snaps.sh` | Instala o utilitário `remove-unused-snaps`. |

### Scripts em `programs/`

| Script | Descrição |
|--------|-----------|
| `chrome.sh` | Google Chrome Stable (signed-by keyring). |
| `docker.sh` | Docker CE + Docker Compose v2 (plugin). |
| `fira-code.sh` | Fonte Fira Code (opcional, já vem via `apt`). |
| `insync.sh` | Insync (repo Noble, signed-by keyring). |
| `jetbrains-toolbox.sh` | JetBrains ToolBox (versão mais recente). |
| `sublime-text.sh` | Sublime Text 4 + Package Control. |
| `vscode.sh` | Visual Studio Code + extensões. |
| `zsh.sh` | zsh, Oh My Zsh, tema Spaceship, Zinit. |
| `fingerprint.sh` | fprintd, leitor de digital FPC, regra udev. |
| `swapfile.sh` | Swapfile de 8 GB + `/etc/fstab`. |
| `environment.sh` | `/etc/environment`, `.XCompose`, ibus, gsettings. |
| `dev-tools.sh` | SDKMAN, Java 21, NVM, Node.js LTS. |
| `ssh.sh` | Chave SSH Ed25519, `~/.ssh/config`. |
| `browsers.sh` | Brave, Edge, Vivaldi, Opera. |

Todos os scripts são **idempotentes**: podem ser executados mais de uma vez sem causar erros ou alterações indesejadas.

## CI/CD

O repositório usa GitHub Actions para garantir qualidade:

| Workflow | Descrição |
|----------|-----------|
| `lint.yml` | Roda `shellcheck` em todos os scripts `.sh`. |
| `test.yml` | Valida sintaxe `bash -n` em container Ubuntu 24.04. |
| `idempotence.yml` | Executa cada script duas vezes para verificar idempotência. |

Os workflows disparam em `push` e `pull_request` para o branch `master`.

## Decisões de projeto

As decisões de arquitetura estão documentadas em `docs/decisions/`. Cada decisão segue o espírito do padrão ASD-STE100: frases curtas, uma ideia por frase, voz ativa, um termo para cada coisa.

## Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.
