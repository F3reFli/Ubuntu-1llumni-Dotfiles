# My Ricing Configuration
---
This document lists the customization and configuration ("ricing") of my Linux system.

## Demo 
---
![Demo Preview](demo/demo.gif)

## Shell & Terminal
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
* **Themes**:
    * `double-minegrub-menu` (Minecraft-inspired theme)
    * `Gorgeous-GRUB-Archive`
