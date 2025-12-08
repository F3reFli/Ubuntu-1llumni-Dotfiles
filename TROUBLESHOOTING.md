# Troubleshooting Guide

## Installation Issues

### Extensions Not Working
1. Restart GNOME Shell:
   - **X11**: Press `Alt+F2`, type `r`, press `Enter`
   - **Wayland**: Log out and log back in

2. Manually install extensions:
   ```bash
   ./apply-gnome-settings.sh
   ```

3. Use Extension Manager app:
   ```bash
   sudo apt install gnome-shell-extension-manager
   ```

### Terminal Theme Not Applying
Run the settings script:
```bash
./apply-gnome-settings.sh
```

Or manually load terminal settings:
```bash
dconf load /org/gnome/terminal/ < gnome/terminal.dconf
```

### Zsh Not Default Shell
```bash
chsh -s $(which zsh)
```
Then log out and log back in.

### Starship Not Showing
Make sure it's in your PATH:
```bash
export PATH="$PATH:$HOME/.local/bin"
source ~/.zshrc
```

### Neovim Plugins Not Installing
Open Neovim and run:
```vim
:Lazy sync
```

### Fonts Not Working
Rebuild font cache:
```bash
fc-cache -fv
```

Check if fonts are installed:
```bash
fc-list | grep FiraCode
```

### NVM Not Working
Source NVM in your shell:
```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
```

### Atuin Not Working
Initialize Atuin:
```bash
eval "$(atuin init zsh)"
```

## Configuration Files

- **Zsh**: `~/.zshrc`
- **Starship**: `~/.config/starship.toml`
- **Neovim**: `~/.config/nvim/`
- **FastFetch**: `~/.config/fastfetch/config.jsonc`
- **Tmux**: `~/.tmux.conf`
- **Terminal**: `gnome/terminal.dconf`
- **Extensions**: `gnome-extensions.dconf`

## Reapplying All Settings

1. Reinstall everything:
   ```bash
   ./install.sh
   ```

2. Apply GNOME settings:
   ```bash
   ./apply-gnome-settings.sh
   ```

3. Restart your system

## Uninstall

To remove configurations:
```bash
# Backup first!
mv ~/.zshrc ~/.zshrc.backup
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.tmux.conf ~/.tmux.conf.backup

# Disable extensions
gnome-extensions disable paperwm@paperwm.github.com
# ... (repeat for each extension)

# Change shell back to bash
chsh -s /bin/bash
```

## Getting Help

- Check GNOME Shell logs: `journalctl -f -o cat /usr/bin/gnome-shell`
- Check extension errors: `journalctl --user -f -o cat`
- Neovim health check: `:checkhealth`

## Extension List

Required extensions (install via Extension Manager or extensions.gnome.org):
- paperwm@paperwm.github.com
- tiling-assistant@leleat-on-github
- blur-my-shell@aunetx
- openbar@neuromorph
- hidetopbar@mathieu.bidon.ca
- just-perfection-desktop@just-perfection
- clipboard-indicator@tudmotu.com
- mediacontrols@cliffniff.github.com
- tilingshell@domandoman.xyz
