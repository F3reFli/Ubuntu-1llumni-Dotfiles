#!/usr/bin/env bash

# Ubuntu Illumini Dotfiles Installer (Repaired Version)
# Safe, idempotent, GNOME-aware

set -euo pipefail

# ────────────────────────────────────────────────────────────
# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
# ────────────────────────────────────────────────────────────

log()     { echo -e "${BLUE}[INFO]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1" >&2; exit 1; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }

# ────────────────────────────────────────────────────────────
# BACKUP HELPER
backup() {
    local target="$1"
    if [ -e "$target" ]; then
        local stamp="$(date +%s)"
        mv "$target" "$target.bak.$stamp"
        log "Backed up $target → $target.bak.$stamp"
    fi
}

# ────────────────────────────────────────────────────────────
# SYSTEM CHECKS

if ! command -v apt >/dev/null 2>&1; then
    error "This script requires an Ubuntu/Debian-based system using apt."
fi

if command -v gnome-shell >/dev/null 2>&1; then
    IS_GNOME=true
else
    IS_GNOME=false
    warn "GNOME Shell not detected. GNOME features will be skipped."
fi

# ────────────────────────────────────────────────────────────
# UPDATE & BASIC PACKAGES

log "Updating package index..."
sudo apt update -y

log "Installing required packages..."
sudo apt install -y \
    curl wget git unzip zsh tmux fonts-firacode \
    software-properties-common

# ────────────────────────────────────────────────────────────
# OH-MY-ZSH

log "Installing Oh-My-Zsh (idempotent)…"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    log "Oh-My-Zsh already installed."
fi

# ────────────────────────────────────────────────────────────
# ZSH CONFIG

backup "$HOME/.zshrc"
ln -sf "$PWD/.zshrc" "$HOME/.zshrc"
success "Zsh config linked."

# ────────────────────────────────────────────────────────────
# NEOVIM INSTALLATION

log "Installing Neovim…"
if ! command -v nvim >/dev/null; then
    curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o /tmp/nvim.appimage
    sudo install /tmp/nvim.appimage /usr/local/bin/nvim
else
    log "Neovim already installed."
fi

# CONFIG
backup "$HOME/.config/nvim"
mkdir -p "$HOME/.config"
ln -sf "$PWD/nvim" "$HOME/.config/nvim"

# ────────────────────────────────────────────────────────────
# TMUX CONFIG

backup "$HOME/.tmux.conf"
ln -sf "$PWD/.tmux.conf" "$HOME/.tmux.conf"

# ────────────────────────────────────────────────────────────
# FONTS (safe per-user install)

log "Installing nerd fonts safely (per user)…"
FONT_DIR="$HOME/.local/share/fonts/MesloLGS_NF"
mkdir -p "$FONT_DIR"

if [ -d "$PWD/fonts/MesloLGS_NF" ]; then
    # Check if directory is not empty
    if [ -n "$(ls -A "$PWD/fonts/MesloLGS_NF" 2>/dev/null)" ]; then
        for f in "$PWD/fonts/MesloLGS_NF"/*; do
            cp "$f" "$FONT_DIR/"
        done
        fc-cache -f "$HOME/.local/share/fonts"
        success "Fonts installed."
    else
        warn "Font directory $PWD/fonts/MesloLGS_NF is empty. Skipping font installation."
    fi
else
    warn "Font directory $PWD/fonts/MesloLGS_NF not found. Skipping font installation."
fi

# ────────────────────────────────────────────────────────────
# GNOME EXTENSIONS
if [ "$IS_GNOME" = true ]; then
    log "Installing GNOME extensions…"

    install_ext() {
        local uuid="$1"
        local ext_zip="/tmp/$uuid.zip"

        wget -q "https://extensions.gnome.org/download-extension/${uuid}.shell-extension.zip" -O "$ext_zip" \
            || { warn "Failed to download $uuid"; return; }

        gnome-extensions install "$ext_zip" --force || warn "Failed to install $uuid"
    }

    install_ext "user-theme@gnome-shell-extensions.gcampax.github.com"
    install_ext "dash-to-dock@micxgx.gmail.com"

else
    warn "Skipping GNOME extension installation due to missing GNOME Shell."
fi

# ────────────────────────────────────────────────────────────
# GNOME TERMINAL CONFIG (safe)

if [ "$IS_GNOME" = true ] && command -v dconf >/dev/null; then
    if [ -f ./gnome/terminal.dconf ]; then
        log "Applying GNOME Terminal settings…"
        dconf load /org/gnome/terminal/legacy/profiles:/ < ./gnome/terminal.dconf
    else
        warn "terminal.dconf missing, skipping."
    fi
else
    warn "Skipping GNOME Terminal configuration."
fi

# ────────────────────────────────────────────────────────────
# DEFAULT SHELL CHANGE

if [ "$SHELL" != "$(which zsh)" ]; then
    log "Changing default shell to zsh…"
    if grep -q "$(which zsh)" /etc/shells; then
        sudo chsh -s "$(which zsh)" "$USER"
    else
        warn "Zsh path not registered in /etc/shells. Adding it."
        echo "$(which zsh)" | sudo tee -a /etc/shells
        sudo chsh -s "$(which zsh)" "$USER"
    fi
else
    log "Default shell already set to zsh."
fi

# ────────────────────────────────────────────────────────────
# DONE

success "Installation complete!"
echo -e "${YELLOW}IMPORTANT STEPS REMAINING:${NC}"
echo "1. Log out/in or reboot to apply GNOME extension changes."
echo "2. Open Neovim once so LazyVim installs plugins."
echo "3. If you want the GRUB theme, run the theme installer manually."
echo "4. Configure GNOME extensions using Extension Manager."
echo "5. Enjoy your new setup!"
