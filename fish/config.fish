# ===========================================
# 🌍 Environment & Path Setup (Global)
# ===========================================

# 🍺 Initialize Homebrew (First to ensure paths are available)
# This sets up PATH, MANPATH, INFOPATH, etc.
if test -x /opt/homebrew/bin/brew
    eval "$(/opt/homebrew/bin/brew shellenv)"
end

# 📁 XDG Base Directory Specification
set -gx ZDOTDIR ~/.config/zsh
set -gx NPM_CONFIG_CACHE ~/.config/npm

# 📝 Default Editor
if not set -q EDITOR
    set -Ux EDITOR nvim
end

# 🛠️ Path Management (Using fish_add_path for deduplication)
# Local bins
fish_add_path $HOME/.local/bin
# Rust Cargo
fish_add_path $HOME/.cargo/bin
# Bun
set --export BUN_INSTALL "$HOME/.config/bun"
fish_add_path $BUN_INSTALL/bin
# Windsurf
fish_add_path $HOME/.codeium/windsurf/bin
# Antigravity
fish_add_path $HOME/.antigravity/antigravity/bin
# Opencode
fish_add_path $HOME/.opencode/bin
# Obsidian CLI
fish_add_path /Applications/Obsidian.app/Contents/MacOS

# 🔐 Secrets & API Tokens (1Password)
# Universal variables (-Ux) persist across sessions, so this only runs if the var is missing.
if type -q op
    if not set -q JIRA_API_TOKEN
        set -l jira_token (op item get ocj3glcbzdaxevswcn2kvrmx3i --fields token 2> /dev/null)
        test -n "$jira_token" && set -Ux JIRA_API_TOKEN $jira_token
    end

    if not set -q ANTHROPIC_API_KEY
        set -l anthropic_key (op item get 7c7ddeemjohrphdgxvtphjw6c4 --fields "api key" 2> /dev/null)
        test -n "$anthropic_key" && set -Ux ANTHROPIC_API_KEY $anthropic_key
    end

    if not set -q GOOGLE_GENERATIVE_AI_API_KEY
        set -l google_key (op item get z6wvmtuk3l2piffifw42ywd2ti --fields gemini 2> /dev/null)
        test -n "$google_key" && set -Ux GOOGLE_GENERATIVE_AI_API_KEY $google_key
    end

    if not set -q BRAVE_SEARCH_API_KEY
        set -l brave_key (op item get "Brave Search API" --fields credential --reveal 2> /dev/null)
        test -n "$brave_key" && set -Ux BRAVE_SEARCH_API_KEY $brave_key
    end
end

set -x GOOGLE_APPLICATION_CREDENTIALS /Users/keita/.config/gcloud/application_default_credentials.json

# 🔔 Pi Notify Sound
set -gx PI_NOTIFY_SOUND_CMD "afplay /System/Library/Sounds/Submarine.aiff"

# 🛑 Global Git Ignore
if type -q git
    set -l __git_excludes (git config --global --get core.excludesfile 2> /dev/null)
    if test "$__git_excludes" != "$HOME/.config/.gitignore"
        git config --global core.excludesfile ~/.config/.gitignore
    end
end

# ===========================================
# 🖥️ Interactive Session Settings
# ===========================================
if status is-interactive

    # 🚀 Tools Initialization
    type -q zoxide && zoxide init fish | source
    type -q starship && starship init fish | source
    type -q fnm && fnm env --use-on-cd | source

    # ⌨️ Keybindings
    fish_vi_key_bindings
    bind \cn nvims
    bind \cg 'git diff; commandline -f repaint'
    bind \cl clear-screen
    
    # 📂 Quick Directory Search Wrapper
    function __fzf_fdir
        fdir
    end
    bind \cf __fzf_fdir
    bind \e\cf _fzf_search_directory

    # 📌 Abbreviations & Aliases
    abbr -a ec nvim ~/.config/fish/config.fish
    abbr -a es source ~/.config/fish/config.fish
    abbr -a vconf nvim ~/.config/fish/config.fish
    abbr -a vsource source ~/.config/fish/config.fish

    alias lz lazygit
    alias sshk 'ssh keita@72.62.46.79 -t tmux a'

end
# Added by Antigravity
fish_add_path /Users/keita/.antigravity/antigravity/bin
