setopt PROMPT_SUBST

alias python="python3"

# === Modular Config Files ===
source ~/.config/.zsh/.zprompt

# === zsh-autosuggestions ===
if [ -f ~/.config/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source ~/.config/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#E7F9A9'
fi

# === zsh-syntax-highlighting ===
if [ -f ~/.config/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source ~/.config/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# === ls alias with vivid color support ===
alias ls="gls --color=auto"

# Generate LS_COLORS using vivid
export LS_COLORS="$(vivid generate ayu)"

function gc {
  local GHOSTTY_DIR="$HOME/.config/ghostty"
  local CMD="sed -i '' 's:\(config-file = {1}\)/.*:\1/{2}:' $GHOSTTY_DIR/config && osascript -so -e 'tell application \"Ghostty\" to activate' -e 'tell application \"System Events\" to keystroke \",\" using {command down, shift down}'"
  fd \
    --type f \
    --exclude 'config' \
    --base-directory $GHOSTTY_DIR \
  | fzf \
    --preview "cat $GHOSTTY_DIR/{}" \
    --delimiter=/ \
    --bind="enter:become:$CMD"
}
