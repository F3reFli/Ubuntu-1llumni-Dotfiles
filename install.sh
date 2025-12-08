#!/bin/bash

# Ubuntu Illumini Dotfiles Installer
# Based on the README.md configuration

# set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

success() {
  echo -e "${GREEN}[OK]${NC} $1"
}

error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Ubuntu/Debian
if [ ! -f /etc/debian_version ]; then
  error "This script is intended for Ubuntu/Debian based systems."
  exit 1
fi

log "Starting installation of Ubuntu Illumini Dotfiles configuration..."

# 2. System Update & Dependencies
log "Installing tmux..."
sudo apt install -y tmux

# Copy tmux config if exists
if [ -f "./.tmux.conf" ]; then
    log "Copying .tmux.conf..."
    cp "./.tmux.conf" "$HOME/.tmux.conf"
    success ".tmux.conf copied."
fi

# 3. System Update & Dependencies
log "Updating system and installing dependencies..."
sudo apt update
sudo apt install -y git curl wget unzip fontconfig python3-pip zsh build-essential zsh-autosuggestions zsh-syntax-highlighting ripgrep fd-find

# 4. Shell & Terminal (Zsh, Starship, Plugins)
log "Setting up Shell (Zsh, Starship, Plugins)..."

# Install Starship
if ! command -v starship &>/dev/null; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y
else
  warn "Starship already installed."
fi

# Configure Starship
log "Creating Starship configuration..."
mkdir -p "$HOME/.config"
cat > "$HOME/.config/starship.toml" <<EOF
format = """
[░▒▓](#a3aed2)\\
[  ](bg:#a3aed2 fg:#090c0c)\\
[](bg:#769ff0 fg:#a3aed2)\\
\$directory\\
[](fg:#769ff0 bg:#394260)\\
\$git_branch\\
\$git_status\\
[](fg:#394260 bg:#212736)\\
\$nodejs\\
\$rust\\
\$golang\\
\$php\\
[](fg:#212736 bg:#1d2230)\\
\$time\\
[ ](fg:#1d2230)\\
\\n\$character"""

[directory]
style = "fg:#e3e5e5 bg:#769ff0"
format = "[ \$path ](\$style)"
truncation_length = 3
truncation_symbol = "…/"

[directory.substitutions]
"Documents" = "󰈙 "
"Downloads" = " "
"Music" = " "
"Pictures" = " "

[git_branch]
symbol = ""
style = "bg:#394260"
format = "[[ \$symbol \$branch ](fg:#769ff0 bg:#394260)](\$style)"

[git_status]
style = "bg:#394260"
format = "[[(\$all_status\$ahead_behind )](fg:#769ff0 bg:#394260)](\$style)"

[nodejs]
symbol = ""
style = "bg:#212736"
format = "[[ \$symbol (\$version) ](fg:#769ff0 bg:#212736)](\$style)"

[rust]
symbol = ""
style = "bg:#212736"
format = "[[ \$symbol (\$version) ](fg:#769ff0 bg:#212736)](\$style)"

[golang]
symbol = ""
style = "bg:#212736"
format = "[[ \$symbol (\$version) ](fg:#769ff0 bg:#212736)](\$style)"

[php]
symbol = ""
style = "bg:#212736"
format = "[[ \$symbol (\$version) ](fg:#769ff0 bg:#212736)](\$style)"

[time]
disabled = false
time_format = "%R" # Hour:Minute Format
style = "bg:#1d2230"
format = "[[  \$time ](fg:#a0a9cb bg:#1d2230)](\$style)"
EOF

# Install zsh-autocomplete (Manual clone)
if [ ! -d "$HOME/zsh-autocomplete" ]; then
  git clone https://github.com/marlonrichert/zsh-autocomplete "$HOME/zsh-autocomplete"
else
  warn "zsh-autocomplete already installed."
fi

# Install NVM
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    log "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    nvm install --lts
fi

# Install Atuin
if ! command -v atuin &>/dev/null; then
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
fi

# Copy existing .zshrc if present
log "Copying .zshrc configuration..."
if [ -f "./.zshrc" ]; then
  cp "./.zshrc" "$HOME/.zshrc"
  success ".zshrc copied from repository."
else
  # Configure .zshrc (Matching user's config)
  log "Creating default .zshrc..."
  cat >"$HOME/.zshrc" <<EOF
# Created by Illumini Dotfiles Installer

eval "\$(starship init zsh)"

# System Plugins
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# User Plugins
if [ -f "\$HOME/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ]; then
    source "\$HOME/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
fi

# Atuin
if [ -f "\$HOME/.atuin/bin/env" ]; then
    . "\$HOME/.atuin/bin/env"
fi
eval "\$(atuin init zsh)"

# Default app
if command -v fastfetch &> /dev/null; then
    fastfetch
fi

# NVM
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && . "\$NVM_DIR/nvm.sh"

# Path and Editor
export PATH="\$PATH:\$HOME/.local/bin"
export EDITOR="nvim"
EOF
fi

# 5. Terminal Tools (FastFetch, Btop)
log "Installing Terminal Tools..."
if ! sudo apt install -y fastfetch; then
    warn "Fastfetch not found in default repos. Adding PPA..."
    sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
    sudo apt update
    if ! sudo apt install -y fastfetch; then
        warn "Failed to install fastfetch from PPA. Trying direct download..."
        wget -O /tmp/fastfetch.deb https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-amd64.deb
        if [ -f /tmp/fastfetch.deb ]; then
            sudo apt install -y /tmp/fastfetch.deb
            rm /tmp/fastfetch.deb
        else
            warn "Failed to download fastfetch.deb"
        fi
    fi
fi
sudo apt install -y btop

# Configure FastFetch
log "Creating FastFetch configuration..."
mkdir -p "$HOME/.config/fastfetch"
cat > "$HOME/.config/fastfetch/config.jsonc" <<EOF
{
  "\$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "type": "small"
  },
  "display": {
    "separator": "  "
  },
  "modules": [
    "title",
    "separator",
    "os",
    "host",
    "kernel",
    "uptime",
    "packages",
    "shell",
    "display",
    "de",
    "wm",
    "wmtheme",
    "theme",
    "icons",
    "font",
    "cursor",
    "terminal",
    "terminalfont",
    "cpu",
    "gpu",
    "memory",
    "swap",
    "disk",
    "localip",
    "battery",
    "poweradapter",
    "locale",
    "break",
    "colors"
  ]
}
EOF

# 6. Editor (Neovim + LazyVim)
log "Setting up Neovim and LazyVim..."

# Install Neovim (LazyVim requires Neovim >= 0.9.0)
# We use the unstable PPA to ensure we get a recent enough version for LazyVim
if ! command -v nvim &>/dev/null; then
    log "Neovim not found. Installing from PPA..."
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt update
    sudo apt install -y neovim
else
    log "Neovim already installed."
fi

# Backup existing config
if [ -d "$HOME/.config/nvim" ]; then
  warn "Backing up existing Neovim config to ~/.config/nvim.bak"
  mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
fi

# Check if nvim config exists in repository
if [ -d "./nvim" ]; then
  log "Copying Neovim configuration from repository..."
  cp -r "./nvim" "$HOME/.config/nvim"
  success "Neovim configuration copied."
else
  # Clone LazyVim Starter
  log "No nvim config in repo, cloning LazyVim Starter..."
  git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
  # Remove .git to make it a user config
  rm -rf "$HOME/.config/nvim/.git"

  # Configure Custom Plugins (from README)
  log "Installing Custom Neovim Plugins configuration..."
  mkdir -p "$HOME/.config/nvim/lua/plugins"

  # 1. Themes (TokyoNight & Black Metal)
  cat > "$HOME/.config/nvim/lua/plugins/themes.lua" <<EOF
return {
  { "folke/tokyonight.nvim" },
  { "rampjet/vim-black-metal" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
EOF

  # 2. AI (Copilot & CodeCompanion)
  cat > "$HOME/.config/nvim/lua/plugins/ai.lua" <<EOF
return {
  -- GitHub Copilot
  { "github/copilot.vim" },
  
  -- CodeCompanion
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = true,
  },
}
EOF

  # 3. Markdown (Render Markdown)
  cat > "$HOME/.config/nvim/lua/plugins/markdown.lua" <<EOF
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {},
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  },
}
EOF
fi

# 7. Fonts (FiraCode Nerd Font)
log "Installing FiraCode Nerd Font..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
if [ ! -f "$FONT_DIR/FiraCodeNerdFont-Regular.ttf" ]; then
  wget -O /tmp/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
  unzip -o /tmp/FiraCode.zip -d "$FONT_DIR"
  rm /tmp/FiraCode.zip
  fc-cache -fv
else
  warn "FiraCode Nerd Font seems to be installed."
fi

# 8. Applications
log "Installing Applications (Feh, GitHub CLI)..."
sudo apt install -y feh gh

# Try to install Kew (might not be in repos)
if sudo apt install -y kew 2>/dev/null; then
    success "Kew installed."
else
    warn "Kew not found in repositories. Skipping."
fi

# 9. Wallpaper
log "Setting up Wallpaper..."
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
mkdir -p "$WALLPAPER_DIR"
# Find the first jpg/png in the wallpapers directory
WALLPAPER_FILE=$(find ./wallpapers -type f \( -name "*.jpg" -o -name "*.png" \) 2>/dev/null | head -n 1)

if [ -f "$WALLPAPER_FILE" ]; then
  WALLPAPER_EXT="${WALLPAPER_FILE##*.}"
  cp "$WALLPAPER_FILE" "$WALLPAPER_DIR/wallpaper.$WALLPAPER_EXT"
  
  if command -v gsettings &>/dev/null; then
    gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_DIR/wallpaper.$WALLPAPER_EXT"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER_DIR/wallpaper.$WALLPAPER_EXT"
    success "Wallpaper set successfully."
  else
    warn "gsettings not found. Wallpaper copied but not set."
  fi
else
  warn "No wallpaper file found in ./wallpapers/"
fi

# 10. GNOME Extensions (Best Effort)
log "Installing GNOME Extensions tools..."
sudo apt install -y gnome-shell-extensions gnome-shell-extension-manager pipx
pipx ensurepath
export PATH="$PATH:$HOME/.local/bin"

# Attempt to install gnome-extensions-cli to help user
if ! command -v gnome-extensions-cli &>/dev/null; then
  pipx install gnome-extensions-cli --system-site-packages
fi

log "Installing GNOME Extensions (requires session restart to take full effect)..."
# List of extensions from README
# PaperWM, Tiling Assistant, Blur My Shell, OpenBar, Hide System Icons, Just Perfection, Clipboard Indicator, Media Controls, Quick Settings Tweaks, Workspace Indicator
# Note: This might fail if gnome-extensions-cli isn't working perfectly or UUIDs changed.
EXTENSIONS=(
  "paperwm@paperwm.github.com"
  "tiling-assistant@leleat-on-github"
  "blur-my-shell@aunetx"
  "openbar@neuromorph"
  "hidetopbar@mathieu.bidon.ca" # Approximation for Hide System Icons
  "just-perfection-desktop@just-perfection"
  "clipboard-indicator@tudmotu.com"
  "mediacontrols@cliffniff.github.com"
  "quick-settings-tweaks@atareao.es"
  "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
  "tilingshell@domandoman.xyz"
)

if command -v gnome-extensions-cli &>/dev/null; then
  for ext in "${EXTENSIONS[@]}"; do
    log "Installing extension: $ext"
    gext install "$ext" || warn "Failed to install $ext (might need manual install)"
  done
else
  warn "gnome-extensions-cli not found. Please install these extensions manually: ${EXTENSIONS[*]}"
fi

# Apply GNOME Extensions Configuration
if [ -f "./gnome-extensions.dconf" ]; then
  log "Applying GNOME Extensions configuration..."
  # Load dconf settings
  dconf load /org/gnome/shell/extensions/ < "./gnome-extensions.dconf"
  
  # Enable extensions globally
  if command -v gsettings &>/dev/null; then
      gsettings set org.gnome.shell disable-user-extensions false
      
      # Enable specific extensions (using the list we defined earlier)
      # We need to extract UUIDs. The array EXTENSIONS contains "uuid" or "uuid@..."
      # Some in the list are just IDs for the CLI, not the actual UUIDs.
      # But gnome-extensions-cli usually installs them.
      
      # Let's try to enable all installed extensions
      INSTALLED_EXTENSIONS=$(gnome-extensions list)
      for ext in $INSTALLED_EXTENSIONS; do
          log "Compiling schemas for: $ext"
          # Find the extension directory
          EXT_DIR="$HOME/.local/share/gnome-shell/extensions/$ext"
          if [ -d "$EXT_DIR/schemas" ]; then
              glib-compile-schemas "$EXT_DIR/schemas"
          fi
          
          log "Enabling extension: $ext"
          gnome-extensions enable "$ext"
      done
  fi
  success "Extensions configuration applied."
else
  warn "gnome-extensions.dconf not found. Skipping configuration."
fi

# 11. Bootloader (GRUB)
log "Downloading GRUB Theme (Minecraft)..."
if [ ! -d "$HOME/double-minegrub-menu" ]; then
  git clone https://github.com/Lxtharia/double-minegrub-menu "$HOME/double-minegrub-menu"
  warn "GRUB theme downloaded to $HOME/double-minegrub-menu."
  warn "Please run the install script inside that directory manually to avoid breaking bootloader automatically."
else
  warn "GRUB theme directory already exists."
fi

# 12. System Settings (Dark Mode, Terminal)
log "Configuring System Settings..."

# Dark Mode
if command -v gsettings &>/dev/null; then
    log "Setting system to Dark Mode..."
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    # Also set legacy theme just in case
    gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'
else
    warn "gsettings not found. Skipping Dark Mode configuration."
fi

# GNOME Terminal Profile (Tokyo Night)
if command -v dconf &>/dev/null; then
    log "Configuring GNOME Terminal..."
    
    # Check if terminal.dconf exists in gnome directory
    if [ -f "./gnome/terminal.dconf" ]; then
        log "Loading terminal configuration from repository..."
        dconf load /org/gnome/terminal/ < "./gnome/terminal.dconf"
        success "GNOME Terminal configured from repository file."
    else
        # Create default Tokyo Night profile
        log "Creating Tokyo Night terminal profile..."
        PROFILE_UUID="b1dcc9dd-5262-4d8d-a863-c897e6d979b9"
        
        # Create dconf dump for the profile
        cat > /tmp/terminal.dconf <<EOF
[legacy/profiles:/:$PROFILE_UUID]
background-color='rgb(26,27,38)'
foreground-color='rgb(192,202,245)'
use-theme-colors=false
use-transparent-background=false
visible-name='TokyoNight'
palette=['rgb(21,22,30)', 'rgb(247,118,142)', 'rgb(158,206,106)', 'rgb(224,175,104)', 'rgb(122,162,247)', 'rgb(187,154,247)', 'rgb(125,207,255)', 'rgb(169,177,214)', 'rgb(65,72,104)', 'rgb(247,118,142)', 'rgb(158,206,106)', 'rgb(224,175,104)', 'rgb(122,162,247)', 'rgb(187,154,247)', 'rgb(125,207,255)', 'rgb(192,202,245)']
font='FiraCode Nerd Font 12'
use-system-font=false
EOF

        # Load the profile
        dconf load /org/gnome/terminal/ < /tmp/terminal.dconf
        rm /tmp/terminal.dconf
        
        if command -v gsettings &>/dev/null; then
            gsettings set org.gnome.Terminal.ProfilesList default "$PROFILE_UUID"
            
            CURRENT_LIST=$(gsettings get org.gnome.Terminal.ProfilesList list)
            if [[ $CURRENT_LIST != *"$PROFILE_UUID"* ]]; then
                # Remove closing bracket and append
                NEW_LIST="${CURRENT_LIST%]*}, '$PROFILE_UUID']"
                gsettings set org.gnome.Terminal.ProfilesList list "$NEW_LIST"
            fi
        fi
        success "GNOME Terminal configured with Tokyo Night theme."
    fi
else
    warn "dconf not found. Skipping Terminal configuration."
fi

# 13. Finalizing
log "Changing default shell to Zsh..."
sudo chsh -s $(which zsh) $USER

success "Installation complete!"
echo -e "${YELLOW}IMPORTANT STEPS REMAINING:${NC}"
echo "1. Restart your computer or log out/in to apply GNOME extensions and Shell changes."
echo "2. Open Neovim ('nvim') to let LazyVim install plugins."
echo "3. Run the GRUB theme installer in $HOME/double-minegrub-menu if you want the Minecraft theme."
echo "4. Configure your GNOME extensions via 'Extension Manager' app."
echo "5. Enjoy your new setup!"
