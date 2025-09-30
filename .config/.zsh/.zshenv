# === PATH Modification for uv ===
export PATH="/Users/t980645/.local/bin:$PATH"

# === PATH & Homebrew ===
export PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:${PATH}"
eval "$(/opt/homebrew/bin/brew shellenv)"

# === Google Cloud SDK ===
export PATH="$HOME/google-cloud-sdk/bin:$PATH"

# === Disable VENV Prompt ===
export VIRTUAL_ENV_DISABLE_PROMPT=1