# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="robbyrussell"

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# User configuration
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Starship prompt
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

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
