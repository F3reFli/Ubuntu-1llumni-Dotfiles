#!/bin/bash

# Ubuntu Illumini Dotfiles Installer
# Based on the README.md configuration

set -e

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
  exit 1
}

# Check if running on Ubuntu/Debian
if [ ! -f /etc/debian_version ]; then
  error "This script is intended for Ubuntu/Debian based systems."
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

log "Starting installation of Ubuntu Illumini Dotfiles configuration..."
log "Script directory: $SCRIPT_DIR"

# 1. System Update & Dependencies
log "Updating system and installing dependencies..."
sudo apt update
sudo apt install -y git curl wget unzip fontconfig python3-pip zsh build-essential \
    zsh-autosuggestions zsh-syntax-highlighting ripgrep fd-find tmux dconf-cli glib2.0-bin

# 2. Copy tmux config if exists
if [ -f "$SCRIPT_DIR/.tmux.conf" ]; then
    log "Copying .tmux.conf..."
    cp "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"
    success ".tmux.conf copied."
else
    warn ".tmux.conf not found in repository."
fi

# 3. Shell & Terminal (Zsh, Starship, Plugins)
log "Setting up Shell (Zsh, Starship, Plugins)..."

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log "Installing Oh My Zsh..."
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || warn "Oh My Zsh installation failed, continuing..."
else
    warn "Oh My Zsh already installed."
fi

# Install Starship
if ! command -v starship &>/dev/null; then
  log "Installing Starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
  success "Starship installed."
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
  log "Installing zsh-autocomplete..."
  git clone https://github.com/marlonrichert/zsh-autocomplete "$HOME/zsh-autocomplete"
  success "zsh-autocomplete installed."
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
    success "NVM installed with LTS Node.js."
else
    warn "NVM already installed."
fi

# Install Atuin
if ! command -v atuin &>/dev/null; then
  log "Installing Atuin..."
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
  success "Atuin installed."
else
    warn "Atuin already installed."
fi

# Configure Atuin
if [ -d "$SCRIPT_DIR/atuin" ]; then
  log "Copying Atuin config from repository..."
  mkdir -p "$HOME/.config/atuin"
  cp "$SCRIPT_DIR/atuin/config.toml" "$HOME/.config/atuin/config.toml"
  success "Atuin config copied."
else
  warn "Atuin config not found in repository."
fi

# Copy existing .zshrc if present
log "Copying .zshrc configuration..."
if [ -f "$SCRIPT_DIR/.zshrc" ]; then
  cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
  success ".zshrc copied from repository."
else
  # Configure .zshrc (Matching user's config)
  log "Creating default .zshrc..."
  cat >"$HOME/.zshrc" <<'EOF'
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# User configuration
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Starship prompt
eval "$(starship init zsh)"

# System Plugins
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# User Plugins
if [ -f "$HOME/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ]; then
    source "$HOME/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
fi

# Atuin
if [ -f "$HOME/.atuin/bin/env" ]; then
    . "$HOME/.atuin/bin/env"
fi
if command -v atuin &> /dev/null; then
    eval "$(atuin init zsh)"
fi

# FastFetch on startup
if command -v fastfetch &> /dev/null; then
    fastfetch
fi

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Path and Editor
export PATH="$PATH:$HOME/.local/bin"
export EDITOR="nvim"
EOF
  success ".zshrc created."
fi

# 4. Terminal Tools (FastFetch, Btop)
log "Installing Terminal Tools..."
if ! sudo apt install -y fastfetch 2>/dev/null; then
    warn "Fastfetch not found in default repos. Adding PPA..."
    sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch || warn "PPA failed to add"
    sudo apt update
    if ! sudo apt install -y fastfetch 2>/dev/null; then
        warn "Failed to install fastfetch from PPA. Trying direct download..."
        ARCH=$(dpkg --print-architecture)
        if [ "$ARCH" = "amd64" ]; then
            wget -O /tmp/fastfetch.deb https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-amd64.deb
        else
            wget -O /tmp/fastfetch.deb https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-${ARCH}.deb
        fi
        if [ -f /tmp/fastfetch.deb ]; then
            sudo dpkg -i /tmp/fastfetch.deb || sudo apt install -f -y
            rm /tmp/fastfetch.deb
            success "Fastfetch installed from GitHub."
        else
            warn "Failed to download fastfetch.deb"
        fi
    fi
else
    success "Fastfetch installed."
fi

sudo apt install -y btop
success "Btop installed."

# Configure Btop
if [ -d "$SCRIPT_DIR/btop" ]; then
  log "Copying Btop config from repository..."
  mkdir -p "$HOME/.config/btop"
  cp "$SCRIPT_DIR/btop/btop.conf" "$HOME/.config/btop/btop.conf" 2>/dev/null || warn "btop.conf not found"
  if [ -d "$SCRIPT_DIR/btop/themes" ]; then
    cp -r "$SCRIPT_DIR/btop/themes" "$HOME/.config/btop/" 2>/dev/null || true
  fi
  success "Btop config copied."
else
  warn "Btop config not found in repository."
fi

# Install and configure Kitty
if ! command -v kitty &>/dev/null; then
  log "Installing Kitty terminal..."
  sudo apt install -y kitty || warn "Kitty installation failed"
else
  warn "Kitty already installed."
fi

if [ -d "$SCRIPT_DIR/kitty" ]; then
  log "Copying Kitty config from repository..."
  mkdir -p "$HOME/.config/kitty"
  cp "$SCRIPT_DIR/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf" 2>/dev/null || warn "kitty.conf not found"
  success "Kitty config copied."
else
  warn "Kitty config not found in repository."
fi

# Configure FastFetch
log "Creating FastFetch configuration..."
mkdir -p "$HOME/.config/fastfetch"
if [ -d "$SCRIPT_DIR/fastfetch" ]; then
  log "Copying FastFetch config from repository..."
  cp -r "$SCRIPT_DIR/fastfetch"/* "$HOME/.config/fastfetch/"
  success "FastFetch config copied."
else
  warn "fastfetch directory not found in repository, creating default..."
  cat > "$HOME/.config/fastfetch/config.jsonc" <<'EOF'
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
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
fi
success "FastFetch configured."

# 5. Editor (Neovim + LazyVim)
log "Setting up Neovim and LazyVim..."

# Install Neovim (LazyVim requires Neovim >= 0.9.0)
if ! command -v nvim &>/dev/null; then
    log "Neovim not found. Installing from PPA..."
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt update
    sudo apt install -y neovim
    success "Neovim installed."
else
    log "Neovim already installed."
fi

# Backup existing config
if [ -d "$HOME/.config/nvim" ]; then
  warn "Backing up existing Neovim config to ~/.config/nvim.bak.$(date +%s)"
  mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak.$(date +%s)"
fi

# Check if nvim config exists in repository
if [ -d "$SCRIPT_DIR/nvim" ]; then
  log "Copying Neovim configuration from repository..."
  cp -r "$SCRIPT_DIR/nvim" "$HOME/.config/nvim"
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
  cat > "$HOME/.config/nvim/lua/plugins/themes.lua" <<'EOF'
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
  cat > "$HOME/.config/nvim/lua/plugins/ai.lua" <<'EOF'
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
  cat > "$HOME/.config/nvim/lua/plugins/markdown.lua" <<'EOF'
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {},
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  },
}
EOF
  success "LazyVim starter with custom plugins configured."
fi

# 6. Fonts (FiraCode Nerd Font)
log "Installing FiraCode Nerd Font..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
if [ ! -f "$FONT_DIR/FiraCodeNerdFont-Regular.ttf" ]; then
  log "Downloading FiraCode Nerd Font..."
  wget -O /tmp/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
  unzip -o /tmp/FiraCode.zip -d "$FONT_DIR"
  rm /tmp/FiraCode.zip
  fc-cache -fv
  success "FiraCode Nerd Font installed."
else
  warn "FiraCode Nerd Font seems to be installed."
fi

# 7. Applications
log "Installing Applications (Feh, GitHub CLI)..."
sudo apt install -y feh gh
success "Applications installed."

# Try to install Kew (might not be in repos)
if sudo apt install -y kew 2>/dev/null; then
    success "Kew installed."
else
    warn "Kew not found in repositories. Skipping."
fi

# 8. Wallpaper
log "Setting up Wallpaper..."
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
mkdir -p "$WALLPAPER_DIR"
# Find the first jpg/png in the wallpapers directory
WALLPAPER_FILE=$(find "$SCRIPT_DIR/wallpapers" -type f \( -name "*.jpg" -o -name "*.png" \) 2>/dev/null | head -n 1)

if [ -f "$WALLPAPER_FILE" ]; then
  WALLPAPER_EXT="${WALLPAPER_FILE##*.}"
  WALLPAPER_NAME=$(basename "$WALLPAPER_FILE")
  cp "$WALLPAPER_FILE" "$WALLPAPER_DIR/$WALLPAPER_NAME"
  
  if command -v gsettings &>/dev/null; then
    gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_DIR/$WALLPAPER_NAME"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER_DIR/$WALLPAPER_NAME"
    success "Wallpaper set successfully: $WALLPAPER_NAME"
  else
    warn "gsettings not found. Wallpaper copied but not set."
  fi
else
  warn "No wallpaper file found in $SCRIPT_DIR/wallpapers/"
fi

# 9. GNOME Extensions
log "Installing GNOME Extensions tools..."
sudo apt install -y gnome-shell-extensions gnome-shell-extension-manager pipx gnome-tweaks chrome-gnome-shell
pipx ensurepath
export PATH="$PATH:$HOME/.local/bin"

# Install gnome-extensions-cli
if ! command -v gext &>/dev/null; then
  log "Installing gnome-extensions-cli..."
  pipx install gnome-extensions-cli --system-site-packages || warn "Failed to install gnome-extensions-cli"
fi

log "Installing GNOME Extensions..."
# Extensions list matching the dconf file
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

if command -v gext &>/dev/null; then
  for ext in "${EXTENSIONS[@]}"; do
    log "Installing extension: $ext"
    gext install "$ext" || warn "Failed to install $ext (may need manual install from extensions.gnome.org)"
  done
  success "Extensions installation attempted."
else
  warn "gext command not found. Please install extensions manually via Extension Manager or https://extensions.gnome.org"
  warn "Required extensions: ${EXTENSIONS[*]}"
fi

# Apply GNOME Extensions Configuration
if [ -f "$SCRIPT_DIR/gnome-extensions.dconf" ]; then
  log "Applying GNOME Extensions configuration..."
  dconf load /org/gnome/shell/extensions/ < "$SCRIPT_DIR/gnome-extensions.dconf"
  success "Extensions configuration loaded."
  
  # Enable extensions globally
  if command -v gsettings &>/dev/null; then
      gsettings set org.gnome.shell disable-user-extensions false
      
      # Compile schemas and enable all installed extensions
      for ext in "${EXTENSIONS[@]}"; do
          EXT_DIR="$HOME/.local/share/gnome-shell/extensions/$ext"
          if [ -d "$EXT_DIR" ]; then
              if [ -d "$EXT_DIR/schemas" ]; then
                  log "Compiling schemas for: $ext"
                  glib-compile-schemas "$EXT_DIR/schemas" 2>/dev/null || warn "Schema compilation failed for $ext"
              fi
              
              log "Enabling extension: $ext"
              gnome-extensions enable "$ext" || warn "Failed to enable $ext"
          fi
      done
      success "Extensions enabled."
  fi
else
  warn "gnome-extensions.dconf not found at $SCRIPT_DIR/gnome-extensions.dconf. Skipping configuration."
fi

# 10. System Settings (Dark Mode, Terminal)
log "Configuring System Settings..."

# Dark Mode
if command -v gsettings &>/dev/null; then
    log "Setting system to Dark Mode..."
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'
    success "Dark mode enabled."
else
    warn "gsettings not found. Skipping Dark Mode configuration."
fi

# GNOME Terminal Profile
if command -v dconf &>/dev/null; then
    log "Configuring GNOME Terminal..."
    
    # Check if terminal.dconf exists in gnome directory
    if [ -f "$SCRIPT_DIR/gnome/terminal.dconf" ]; then
        log "Loading terminal configuration from repository..."
        dconf load /org/gnome/terminal/ < "$SCRIPT_DIR/gnome/terminal.dconf"
        
        # Set the default profile from the dconf file
        PROFILE_UUID=$(dconf read /org/gnome/terminal/legacy/profiles:/default | tr -d "'")
        if [ -n "$PROFILE_UUID" ]; then
            gsettings set org.gnome.Terminal.ProfilesList default "$PROFILE_UUID" 2>/dev/null || true
        fi
        success "GNOME Terminal configured from repository file."
    else
        # Create default Tokyo Night profile
        warn "No terminal.dconf found, creating Tokyo Night profile..."
        PROFILE_UUID="b1dcc9dd-5262-4d8d-a863-c897e6d979b9"
        
        # Create dconf dump for the profile
        cat > /tmp/terminal.dconf <<'EOF'
[legacy/profiles:]
default='b1dcc9dd-5262-4d8d-a863-c897e6d979b9'
list=['b1dcc9dd-5262-4d8d-a863-c897e6d979b9']

[legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9]
background-color='rgb(26,27,38)'
foreground-color='rgb(192,202,245)'
use-theme-colors=false
use-transparent-background=false
visible-name='TokyoNight'
palette=['rgb(21,22,30)', 'rgb(247,118,142)', 'rgb(158,206,106)', 'rgb(224,175,104)', 'rgb(122,162,247)', 'rgb(187,154,247)', 'rgb(125,207,255)', 'rgb(169,177,214)', 'rgb(65,72,104)', 'rgb(247,118,142)', 'rgb(158,206,106)', 'rgb(224,175,104)', 'rgb(122,162,247)', 'rgb(187,154,247)', 'rgb(125,207,255)', 'rgb(192,202,245)']
font='FiraCode Nerd Font 12'
use-system-font=false
bold-color-same-as-fg=true
cursor-shape='ibeam'
EOF

        # Load the profile
        dconf load /org/gnome/terminal/ < /tmp/terminal.dconf
        rm /tmp/terminal.dconf
        
        gsettings set org.gnome.Terminal.ProfilesList default "$PROFILE_UUID" 2>/dev/null || true
        success "GNOME Terminal configured with Tokyo Night theme."
    fi
else
    warn "dconf not found. Skipping Terminal configuration."
fi

# 11. Finalizing
log "Changing default shell to Zsh..."
if [ "$SHELL" != "$(which zsh)" ]; then
    sudo chsh -s $(which zsh) $USER
    success "Default shell changed to Zsh."
else
    warn "Zsh is already the default shell."
fi

success "Installation complete!"
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Ubuntu Illumini Dotfiles Installed! ${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}IMPORTANT NEXT STEPS:${NC}"
echo "1. ${BLUE}Restart your computer${NC} or log out/in for all changes to take effect."
echo "2. Open ${BLUE}Neovim${NC} (type 'nvim') to let LazyVim install all plugins."
echo "3. Use ${BLUE}Extension Manager${NC} app to verify/configure GNOME extensions."
echo "4. If extensions don't work, you may need to:"
echo "   - Restart GNOME Shell (Alt+F2, type 'r', press Enter on X11)"
echo "   - Or logout/login again"
echo "5. Configure GitHub Copilot in Neovim: ${BLUE}:Copilot setup${NC}"
echo ""
echo -e "${GREEN}Enjoy your new setup!${NC}"
echo ""
