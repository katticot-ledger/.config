# ===========================================
# 🛠️ Aliases & Environment Setup for Fish 🐟
# ===========================================

# 🏗️ Add Homebrew paths to Fish shell
fish_add_path /opt/homebrew/sbin
fish_add_path /opt/homebrew/bin

# 🦀 Add Rust Cargo bin directory
fish_add_path $HOME/.cargo/bin

# 🚀 Initialize Zoxide (smart directory jumping)
zoxide init fish | source

# ✨ Initialize Starship prompt (beautiful terminal UI)
starship init fish | source

# 🐟✨ Node version management (fnm on macOS)
if type -q fnm
    fnm env --use-on-cd | source
end

# 📝 Set the default editor to Neovim (nvim)
if not set -q EDITOR
    set -Ux EDITOR nvim
end

# 🛑 Global Git configuration - Set excludes file (only if missing)
if type -q git
    set -l __git_excludes (git config --global --get core.excludesfile 2> /dev/null)
    if test "$__git_excludes" != "$HOME/.config/.gitignore"
        git config --global core.excludesfile ~/.config/.gitignore
    end
end

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
# 📂 Quick Directory Search with Ctrl + Alt + F
bind \e\cf _fzf_search_directory

# ===========================
# 🔐 Secrets & API Tokens 🛡️
# ===========================

# 🔑 Retrieve and set JIRA API Token securely from 1Password (if not already set)
if not set -q JIRA_API_TOKEN
    if type -q op
        set -l jira_token (op item get ocj3glcbzdaxevswcn2kvrmx3i --fields token 2> /dev/null)
        if test -n "$jira_token"
            set -Ux JIRA_API_TOKEN $jira_token
        end
    end
end

# 🔑 Retrieve and set Anthropic API Key securely from 1Password (if not already set)
if not set -q ANTHROPIC_API_KEY
    if type -q op
        set -l anthropic_key (op item get 7c7ddeemjohrphdgxvtphjw6c4 --fields "api key" 2> /dev/null)
        if test -n "$anthropic_key"
            set -Ux ANTHROPIC_API_KEY $anthropic_key
        end
    end
end

if not set -q GOOGLE_GENERATIVE_AI_API_KEY
    if type -q op
        set -l google_key (op item get z6wvmtuk3l2piffifw42ywd2ti --fields gemini 2> /dev/null)
        if test -n "$google_key"
            set -Ux GOOGLE_GENERATIVE_AI_API_KEY $google_key
        end
    end
end

set -x GOOGLE_APPLICATION_CREDENTIALS /Users/keita/.config/gcloud/application_default_credentials.json
# ===========================
# 🌍 Environment Variables 🏗️
# ===========================

# Quick edit config
abbr -a ec nvim ~/.config/fish/config.fish
abbr -a es source ~/.config/fish/config.fish

abbr -a vconf nvim ~/.config/fish/config.fish
abbr -a vsource source ~/.config/fish/config.fish

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
fish_add_path /Users/keita/.codeium/windsurf/bin

# bun
set --export BUN_INSTALL "$HOME/.config/bun"

set --export PATH $BUN_INSTALL/bin $PATH
alias lz lazygit
alias sshk 'ssh keita@72.62.46.79 -t tmux a'

# Added by Antigravity
fish_add_path /Users/keita/.antigravity/antigravity/bin

# opencode
fish_add_path /Users/keita/.opencode/bin
