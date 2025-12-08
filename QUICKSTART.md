# Quick Start Guide

## Installation (5 minutes)

```bash
# 1. Clone the repository
git clone <your-repo-url> ~/ubuntuIllumniDotfiles
cd ~/ubuntuIllumniDotfiles

# 2. Make install script executable
chmod +x install.sh

# 3. Run the installer (will ask for sudo password)
./install.sh

# 4. Restart your computer
sudo reboot
```

## After Reboot

```bash
# 1. Verify installation
cd ~/ubuntuIllumniDotfiles
./verify-setup.sh

# 2. Open Neovim to install plugins (first time will take a moment)
nvim

# 3. If GNOME extensions aren't working, reapply settings:
./apply-gnome-settings.sh

# 4. Restart GNOME Shell (X11 only)
# Press Alt+F2, type 'r', press Enter
# On Wayland: just log out and log back in
```

## What Gets Installed

### Shell & Terminal
- ✓ Zsh as default shell
- ✓ Oh My Zsh framework
- ✓ Starship prompt
- ✓ Auto-suggestions, syntax highlighting, autocomplete
- ✓ Atuin (shell history)
- ✓ FastFetch (system info)
- ✓ Btop (resource monitor)
- ✓ Tmux (terminal multiplexer)

### Editor
- ✓ Neovim with LazyVim
- ✓ GitHub Copilot support
- ✓ TokyoNight theme
- ✓ LSP and autocompletion

### Fonts & Visuals
- ✓ FiraCode Nerd Font
- ✓ Dark mode enabled
- ✓ Custom terminal theme

### GNOME Extensions
- ✓ PaperWM (tiling)
- ✓ Blur My Shell
- ✓ OpenBar
- ✓ Clipboard Indicator
- ✓ Media Controls
- ✓ And more...

### Development Tools
- ✓ NVM + Node.js LTS
- ✓ GitHub CLI (gh)
- ✓ Ripgrep, fd-find

## Common Commands

```bash
# Open Neovim
nvim

# System info
fastfetch

# Resource monitor
btop

# Shell history search
atuin search <query>
# Or press Ctrl+R

# GitHub CLI
gh repo list
gh pr list

# Node version management
nvm list
nvm install --lts
nvm use --lts

# Extension management
gnome-extensions list
gnome-extensions enable <extension-name>
```

## Customization

### Change Starship Prompt
Edit `~/.config/starship.toml`

### Change Neovim Theme
1. Open Neovim: `nvim`
2. Press `Space` to open command palette
3. Search for "colorscheme"

Or edit `~/.config/nvim/lua/plugins/themes.lua`

### Change Terminal Theme
Edit or replace `gnome/terminal.dconf`, then:
```bash
./apply-gnome-settings.sh
```

### Add Zsh Plugins
Edit `~/.zshrc` and add your plugins

### Configure Extensions
1. Open Extension Manager app
2. Or edit `gnome-extensions.dconf` and reapply

## Troubleshooting

**Extensions not working?**
```bash
./apply-gnome-settings.sh
```

**Neovim plugins not loading?**
```bash
nvim
# Then type: :Lazy sync
```

**Fonts not showing?**
```bash
fc-cache -fv
```

**Terminal theme wrong?**
```bash
dconf load /org/gnome/terminal/ < gnome/terminal.dconf
```

**More issues?** Check `TROUBLESHOOTING.md`

## Uninstall

```bash
# Change shell back
chsh -s /bin/bash

# Backup configs
mv ~/.zshrc ~/.zshrc.backup
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.tmux.conf ~/.tmux.conf.backup

# Disable extensions
gnome-extensions disable paperwm@paperwm.github.com
# ... etc

# Remove Oh My Zsh
rm -rf ~/.oh-my-zsh
```

## Getting Help

1. Check `TROUBLESHOOTING.md`
2. Run `./verify-setup.sh` to diagnose issues
3. Check logs: `journalctl -f`
4. For GNOME issues: `journalctl -f -o cat /usr/bin/gnome-shell`

## Tips & Tricks

- **Clipboard History**: Press `Super+V`
- **Window Tiling**: Use `Super+Arrow Keys`
- **Workspace Switch**: `Super+Page Up/Down`
- **Command History**: Press `Ctrl+R`
- **Neovim Help**: Press `Space` in Neovim for commands

Enjoy your new setup! 🚀
