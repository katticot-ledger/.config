# ===========================================
# 🛠️ Aliases & Environment Setup for Fish 🐟
# ===========================================

# 🏗️ Add Homebrew paths to Fish shell
fish_add_path /opt/homebrew/sbin
fish_add_path /opt/homebrew/bin

# 🚀 Initialize Zoxide (smart directory jumping)
zoxide init fish | source

# ✨ Initialize Starship prompt (beautiful terminal UI)
starship init fish | source

# 🐟✨ Use NVM with bass in Fish (bridge Bash ➜ Fish)
set -gx NVM_DIR ~/.config/nvm
bass source $NVM_DIR/nvm.sh --no-use ';' nvm use --lts

# 📝 Set the default editor to Neovim (nvim)
set -Ux EDITOR nvim

# 🛑 Global Git configuration - Set excludes file
git config --global core.excludesfile ~/.config/.gitignore

# ===========================
# ⌨️ Custom Keybindings 🎹
# ===========================

#🧠 Vim mode
fish_vi_key_bindings

# 🔄 Open Neovim with Ctrl + N
bind \cn nvims

# 🔍 Show Git diff with Ctrl + G, then repaint the command line
bind \cg 'git diff; commandline -f repaint'

# 🧼 Clear screen with Ctrl + L
bind \cl clear-screen

# 📂 Quick Directory Search with Ctrl + F
function __fzf_fdir
    fdir
end
bind \cf __fzf_fdir

# ===========================
# 🔐 Secrets & API Tokens 🛡️
# ===========================

# 📝 Set Jira Username
set -Ux JIRA_USERNAME keita.atticot@ledger.fr

# 🔑 Retrieve and set JIRA API Token securely from 1Password (if not already set)
if not set -q JIRA_API_TOKEN
    set -Ux JIRA_API_TOKEN (op item get ocj3glcbzdaxevswcn2kvrmx3i --fields token)
end

# 🔑 Retrieve and set GitHub API Token securely from 1Password (if not already set)
if not set -q GH_TOKEN
    set -Ux GH_TOKEN (op item get hit73pl5zuvp7ct5zvkrrqrwn4 --fields token)
end

# 🔑 Retrieve and set Anthropic API Key securely from 1Password (if not already set)
if not set -q ANTHROPIC_API_KEY
    set -Ux ANTHROPIC_API_KEY (op item get 7c7ddeemjohrphdgxvtphjw6c4 --fields "api key")
end

set -x GOOGLE_APPLICATION_CREDENTIALS /Users/keita/.config/gcloud/application_default_credentials.json
# ===========================
# 🌍 Environment Variables 🏗️
# ===========================

# 📁 XDG Base Directory Specification - Relocate configs to ~/.config/
set -gx ZDOTDIR ~/.config/zsh
set -gx NPM_CONFIG_CACHE ~/.config/npm
set -gx PNPM_STORE_PATH ~/.config/pnpm-store

# ===========================
# 📦 Package Manager: pnpm 🚀
# ===========================

# Set the pnpm home directory
set -gx PNPM_HOME /Users/ke/Library/pnpm

# Add pnpm to the PATH if not already included
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end

# ===========================
# 🍺 Initialize Homebrew 🏗️
# ===========================

eval "$(/opt/homebrew/bin/brew shellenv)"

# ✅ Configuration Loaded Successfully! 🎉
fish_add_path $HOME/.local/bin

# Added by Windsurf
fish_add_path /Users/ke/.codeium/windsurf/bin

# bun
set --export BUN_INSTALL "$HOME/.config/bun"

set --export PATH $BUN_INSTALL/bin $PATH
