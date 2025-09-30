# Set XDG directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export SHELL_SESSION_DIR="$XDG_CACHE_HOME/zsh/.zsh-sessions"
export HISTFILE="$XDG_CACHE_HOME/zsh/.zsh_history"
export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/.zcompdump"

# Point zsh to configuration in .config
export ZDOTDIR="$XDG_CONFIG_HOME/.zsh/"

# Source extended .zshenv if it exists
[[ -f "$ZDOTDIR/.zshenv" ]] && source "$ZDOTDIR/.zshenv"