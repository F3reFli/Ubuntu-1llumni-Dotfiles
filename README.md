<div align="center">

# Ubuntu Illumini Dotfiles
---
This document lists the customization and configuration ("ricing") of my Linux system.

![Ubuntu](https://img.shields.io/badge/Ubuntu-000000?style=for-the-badge&logo=ubuntu&logoColor=white)
![Neovim](https://img.shields.io/badge/NeoVim-000000?style=for-the-badge&logo=neovim&logoColor=white)
![GNOME](https://img.shields.io/badge/GNOME-000000?style=for-the-badge&logo=gnome&logoColor=white)
![Zsh](https://img.shields.io/badge/Zsh-000000?style=for-the-badge&logo=gnu-bash&logoColor=white)

</div>

## Demo 
---
![Demo Preview](demo/demo.gif)

---

## Installation
---

### Quick Install

```bash
git clone https://github.com/yourusername/ubuntuIllumniDotfiles.git
cd ubuntuIllumniDotfiles
chmod +x install.sh
./install.sh
```

After installation:
1. **Restart your computer** or log out/in
2. Open **Neovim** (`nvim`) to install plugins
3. Run `./verify-setup.sh` to check installation
4. If needed: `./apply-gnome-settings.sh` to reapply GNOME settings

### What Gets Installed

- Zsh with Oh My Zsh + Starship prompt
- Shell plugins (autosuggestions, syntax highlighting, autocomplete)
- Neovim with LazyVim configuration
- FiraCode Nerd Font
- Terminal tools (FastFetch, Btop, Tmux, Atuin)
- GNOME extensions and themes
- Dark mode and custom terminal theme
- Development tools (NVM, GitHub CLI)

### Helper Scripts

- **`install.sh`** - Main installation script
- **`verify-setup.sh`** - Verify installation status
- **`apply-gnome-settings.sh`** - Reapply GNOME settings
- **`QUICKSTART.md`** - Quick start guide
- **`TROUBLESHOOTING.md`** - Troubleshooting guide

### Manual Extension Installation

If GNOME extensions don't auto-install, use **Extension Manager** app or visit:
- https://extensions.gnome.org

Required extensions:
- PaperWM, Tiling Assistant, Tiling Shell
- Blur My Shell, OpenBar, Just Perfection
- Clipboard Indicator, Media Controls, Hide Top Bar



<div align="center">

## Table of Contents

</div>

- [Shell and Terminal](#shell-and-terminal)
- [Editor](#editor)
- [Desktop Environment](#desktop-environment-gnome)
- [Window Managers](#window-managers)
- [Applications](#applications)
- [Bootloader](#bootloader-grub)
--- 

## Shell and Terminal
---
* **Shell**: [Zsh](https://www.zsh.org/) with [Oh My Zsh](https://ohmyz.sh/)
* **Prompt**: [Starship](https://starship.rs/)
* **Terminal Emulator**: Kitty, GNOME terminal
* **Shell Plugins**:
    * `zsh-autosuggestions`
    * `zsh-syntax-highlighting`
    * `zsh-autocomplete`
    * [Atuin](https://atuin.sh/) (Magical shell history)
* **System Info**: [FastFetch](https://github.com/fastfetch-cli/fastfetch) (Runs on shell startup)
* **Resource Monitor**: [Btop](https://github.com/aristocratos/btop)

## Editor
---
* **Neovim**: Configured with [LazyVim](https://github.com/LazyVim/LazyVim)
* **Font**: [FiraCode Nerd Font](https://www.nerdfonts.com/font-downloads)
* **Plugin Manager**: Lazy.nvim
* **LSP & Autocompletion**: Configured via LazyVim
* **Additional Plugins**:
    * AI and completion
    > [CodeCompanion](https://github.com/olimorris/codecompanion.nvim) (Free AI Assistant)
    >
    > [Github Copilot](https://github.com/github/copilot.vim) (Code completion)
    > 
    > [Copilot Chat](https://github.com/olimorris/codecompanion.nvim) (paid AI assistant)
    * Themes and visuals
    > `Themes`: `tokyonight`, `Black Metal Theme` (darkthrone)
    * Productivity
    > [renderMarkdown](https://github.com/MeanderingProgrammer/render-markdown.nvim)

## Desktop Environment (GNOME)
---
I use GNOME with several extensions to enhance functionality and aesthetics.

### Extensions
* **Window Management**:
    * `PaperWM` (Scrollable tiling window manager)
    * `Tiling Assistant` & `Tiling Shell`
* **Visuals**:
    * `Blur My Shell`
    * `OpenBar`
    * `Hide System Icons`
    * `Just Perfection` (UI tweaking)
* **Utilities**:
    * `Clipboard Indicator`
    * `Media Controls`
    * `Quick Settings Tweaks`
    * `Workspace Indicator`

## Window Managers
---
* **i3**: GNOME Window and Tiling manager (select in login options)
> [!WARNING] specifications
***(not used in my config even tho it's installed)***
* **PaperWM**: Tiling window manager extension for GNOME

## Applications
---
* **Music Player**: Kew (CLI music player)
* **Image Viewer**: Feh
* **GitHub CLI**: `gh`
* **Github Copilot**: Copilot

## Bootloader (GRUB)
---
* **Themes**: *(Removed from auto-install for safety)*
    * `double-minegrub-menu` (Minecraft-inspired theme)
    * `Gorgeous-GRUB-Archive`
  
> [!NOTE]
> GRUB themes are no longer automatically installed to prevent bootloader issues.
> You can manually install GRUB themes if desired.

---

<div align="center">

# By 1llumni 
## made with <3 for ESGI community
</div>
