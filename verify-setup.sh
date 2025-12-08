#!/bin/bash

# Verification Script - Check if everything is installed correctly
# Run this after installation to verify the setup

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

check_command() {
    if command -v "$1" &>/dev/null; then
        echo -e "${GREEN}✓${NC} $1 is installed"
        return 0
    else
        echo -e "${RED}✗${NC} $1 is NOT installed"
        return 1
    fi
}

check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1 exists"
        return 0
    else
        echo -e "${RED}✗${NC} $1 does NOT exist"
        return 1
    fi
}

check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} $1 exists"
        return 0
    else
        echo -e "${RED}✗${NC} $1 does NOT exist"
        return 1
    fi
}

check_extension() {
    if gnome-extensions list 2>/dev/null | grep -q "$1"; then
        if gnome-extensions info "$1" 2>/dev/null | grep -q "State: ENABLED"; then
            echo -e "${GREEN}✓${NC} $1 is installed and enabled"
            return 0
        else
            echo -e "${YELLOW}!${NC} $1 is installed but disabled"
            return 1
        fi
    else
        echo -e "${RED}✗${NC} $1 is NOT installed"
        return 1
    fi
}

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Ubuntu Illumini Dotfiles Checker    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Check commands
echo -e "${BLUE}[Checking Commands]${NC}"
check_command "zsh"
check_command "starship"
check_command "nvim"
check_command "fastfetch"
check_command "btop"
check_command "feh"
check_command "gh"
check_command "tmux"
check_command "atuin"
check_command "node" || echo -e "${YELLOW}  → Run: nvm install --lts${NC}"
check_command "gext" || echo -e "${YELLOW}  → Extensions CLI not installed (optional)${NC}"
echo ""

# Check configuration files
echo -e "${BLUE}[Checking Configuration Files]${NC}"
check_file "$HOME/.zshrc"
check_file "$HOME/.tmux.conf"
check_file "$HOME/.config/starship.toml"
check_dir "$HOME/.config/nvim"
check_file "$HOME/.config/fastfetch/config.jsonc"
echo ""

# Check Oh My Zsh
echo -e "${BLUE}[Checking Oh My Zsh]${NC}"
check_dir "$HOME/.oh-my-zsh"
echo ""

# Check plugins
echo -e "${BLUE}[Checking Shell Plugins]${NC}"
check_file "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
check_file "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
check_dir "$HOME/zsh-autocomplete"
check_dir "$HOME/.atuin"
echo ""

# Check NVM
echo -e "${BLUE}[Checking NVM]${NC}"
check_dir "$HOME/.nvm"
echo ""

# Check fonts
echo -e "${BLUE}[Checking Fonts]${NC}"
if fc-list | grep -qi "firacode"; then
    echo -e "${GREEN}✓${NC} FiraCode Nerd Font is installed"
else
    echo -e "${RED}✗${NC} FiraCode Nerd Font is NOT installed"
fi
echo ""

# Check default shell
echo -e "${BLUE}[Checking Default Shell]${NC}"
if [ "$SHELL" = "$(which zsh)" ]; then
    echo -e "${GREEN}✓${NC} Zsh is the default shell"
else
    echo -e "${YELLOW}!${NC} Default shell is $SHELL (expected zsh)"
    echo -e "${YELLOW}  → Run: chsh -s \$(which zsh)${NC}"
fi
echo ""

# Check GNOME extensions (if on GNOME)
if [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] || [ "$XDG_CURRENT_DESKTOP" = "ubuntu:GNOME" ]; then
    echo -e "${BLUE}[Checking GNOME Extensions]${NC}"
    check_extension "paperwm@paperwm.github.com"
    check_extension "tiling-assistant@leleat-on-github"
    check_extension "blur-my-shell@aunetx"
    check_extension "openbar@neuromorph"
    check_extension "hidetopbar@mathieu.bidon.ca"
    check_extension "just-perfection-desktop@just-perfection"
    check_extension "clipboard-indicator@tudmotu.com"
    check_extension "mediacontrols@cliffniff.github.com"
    check_extension "tilingshell@domandoman.xyz"
    echo ""
    
    # Check if user extensions are enabled
    if gsettings get org.gnome.shell disable-user-extensions | grep -q "false"; then
        echo -e "${GREEN}✓${NC} User extensions are enabled"
    else
        echo -e "${RED}✗${NC} User extensions are DISABLED"
        echo -e "${YELLOW}  → Run: gsettings set org.gnome.shell disable-user-extensions false${NC}"
    fi
    echo ""
else
    echo -e "${YELLOW}[Not running GNOME - skipping extension checks]${NC}"
    echo ""
fi

# Check wallpaper
echo -e "${BLUE}[Checking Wallpaper]${NC}"
check_dir "$HOME/Pictures/Wallpapers"
echo ""

# Summary
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║           Verification Complete        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Next steps if issues found:${NC}"
echo "1. Run ./install.sh again to fix missing components"
echo "2. Run ./apply-gnome-settings.sh to reapply GNOME settings"
echo "3. Check TROUBLESHOOTING.md for specific issues"
echo "4. Restart your system if major components are missing"
echo ""
