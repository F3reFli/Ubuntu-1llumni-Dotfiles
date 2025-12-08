#!/bin/bash

# Apply GNOME Settings Script
# Run this script after installation to apply all GNOME settings

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
  echo -e "${GREEN}[OK]${NC} $1"
}

warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

log "Applying GNOME Settings..."

# Check if running GNOME
if [ "$XDG_CURRENT_DESKTOP" != "GNOME" ] && [ "$XDG_CURRENT_DESKTOP" != "ubuntu:GNOME" ]; then
    warn "Not running GNOME desktop. Some settings may not apply."
fi

# Apply dark mode
if command -v gsettings &>/dev/null; then
    log "Setting dark mode..."
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'
    success "Dark mode enabled."
fi

# Apply terminal settings
if [ -f "$SCRIPT_DIR/gnome/terminal.dconf" ] && command -v dconf &>/dev/null; then
    log "Applying terminal settings..."
    dconf load /org/gnome/terminal/ < "$SCRIPT_DIR/gnome/terminal.dconf"
    success "Terminal settings applied."
fi

# Apply extension settings
if [ -f "$SCRIPT_DIR/gnome-extensions.dconf" ] && command -v dconf &>/dev/null; then
    log "Applying extension settings..."
    dconf load /org/gnome/shell/extensions/ < "$SCRIPT_DIR/gnome-extensions.dconf"
    success "Extension settings applied."
    
    # Enable extensions
    log "Enabling extensions..."
    EXTENSIONS=(
        "paperwm@paperwm.github.com"
        "tiling-assistant@leleat-on-github"
        "blur-my-shell@aunetx"
        "openbar@neuromorph"
        "hidetopbar@mathieu.bidon.ca"
        "just-perfection-desktop@just-perfection"
        "clipboard-indicator@tudmotu.com"
        "mediacontrols@cliffniff.github.com"
        "tilingshell@domandoman.xyz"
    )
    
    gsettings set org.gnome.shell disable-user-extensions false
    
    for ext in "${EXTENSIONS[@]}"; do
        if gnome-extensions list | grep -q "$ext"; then
            EXT_DIR="$HOME/.local/share/gnome-shell/extensions/$ext"
            if [ -d "$EXT_DIR/schemas" ]; then
                log "Compiling schemas for $ext..."
                glib-compile-schemas "$EXT_DIR/schemas" 2>/dev/null || true
            fi
            gnome-extensions enable "$ext" 2>/dev/null || warn "Could not enable $ext"
        else
            warn "Extension $ext not installed."
        fi
    done
    success "Extensions enabled."
fi

# Set wallpaper
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
if [ -d "$WALLPAPER_DIR" ]; then
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | head -n 1)
    if [ -f "$WALLPAPER" ] && command -v gsettings &>/dev/null; then
        log "Setting wallpaper..."
        gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER"
        gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER"
        success "Wallpaper set."
    fi
fi

echo ""
success "GNOME settings applied!"
echo ""
echo -e "${YELLOW}Note:${NC} If extensions don't work properly:"
echo "  - On X11: Press Alt+F2, type 'r', press Enter to restart GNOME Shell"
echo "  - On Wayland: Log out and log back in"
echo ""
