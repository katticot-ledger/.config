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

# 🔐 Pi Agent API Keys (lazy-loaded on demand)
# Use `load_pi_keys` to fetch all keys when needed (e.g. before running pi).
# Nothing blocks at shell startup.

set -x GOOGLE_APPLICATION_CREDENTIALS /Users/keita/.config/gcloud/application_default_credentials.json

# 🔔 Pi Notify Sound
set -gx PI_NOTIFY_SOUND_CMD "afplay /System/Library/Sounds/Pop.aiff"

# 🛑 Global Git Ignore
# ⚠️ NEVER call `git` in this block — git's startup path-discovery does stat()
# on parent directories, which HANGS indefinitely when CWD is inside iCloud Drive.
# Just ensure .gitignore exists with sensible defaults.
if not test -f ~/.config/.gitignore
    echo 'node_modules/' > ~/.config/.gitignore
    echo '.DS_Store' >> ~/.config/.gitignore
    echo '*.log' >> ~/.config/.gitignore
end

# ===========================================
# 🖥️ Interactive Session Settings
# ===========================================
if status is-interactive
    # 📭 Disable system mail check
    set -e MAIL

    # 🚀 Tools Initialization
    type -q zoxide && zoxide init fish | source

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
    alias linear 'npx @schpet/linear-cli'

end
# Added by Antigravity
fish_add_path /Users/keita/.antigravity/antigravity/bin

# op command audit wrapper
function op
    echo (date '+%Y-%m-%d %H:%M:%S') (whoami) op $argv >>~/.op_audit.log
    command op $argv
end

# ===========================================
# 📚 Google Workspace CLI - Multi-Account
# ===========================================
function gws-powerhive
    env GOOGLE_WORKSPACE_CLI_CONFIG_DIR="$HOME/.config/gws-powerhive" gws $argv
end

function gws-personal
    gws $argv
end

abbr -a gwp gws-powerhive
abbr -a gws-per gws-personal
# 🔑 Bitwarden quick password retrieval (auto-unlocks from Keychain)
function bwp
    set -l session (security find-generic-password -s "bw" -a "keita.atticot@gmail.com" -w 2>/dev/null | xargs -I{} bw unlock {} --raw 2>/dev/null)
    bw get password $argv[1] --session "$session"
end

# 🔄 Lazy API key loader — call once before running pi to avoid blocking shell startup
function load_pi_keys --description "Load all Pi agent API keys from 1Password & Bitwarden"
    # --- 1Password keys (cached as universal vars) ---
    if type -q op
        if not set -q ANTHROPIC_API_KEY
            set -l val (op item get 7c7ddeemjohrphdgxvtphjw6c4 --fields "api key" 2>/dev/null)
            test -n "$val"; and set -Ux ANTHROPIC_API_KEY $val; and echo "✓ ANTHROPIC_API_KEY"
        end

        if not set -q GOOGLE_GENERATIVE_AI_API_KEY
            set -l val (op item get z6wvmtuk3l2piffifw42ywd2ti --fields gemini 2>/dev/null)
            test -n "$val"; and set -Ux GOOGLE_GENERATIVE_AI_API_KEY $val; and echo "✓ GOOGLE_GENERATIVE_AI_API_KEY"
        end

        if not set -q BRAVE_SEARCH_API_KEY
            set -l val (op item get "Brave Search API" --fields credential --reveal 2>/dev/null)
            test -n "$val"; and set -Ux BRAVE_SEARCH_API_KEY $val; and echo "✓ BRAVE_SEARCH_API_KEY"
        end
    end

    # --- Bitwarden session + keys (bwr not installed on this machine — placeholder) ---
    if type -q bw
        if not set -q BW_SESSION; or test -z "$BW_SESSION"
            set -gx BW_SESSION (security find-generic-password -s "bw" -a "keita.atticot@gmail.com" -w 2>/dev/null | bw unlock --raw 2>/dev/null)
            and echo "✓ BW_SESSION (unlocked)"
        end
    end

    echo "Done — keys are now available for pi and other tools."
end

set -gx PATH $PATH /opt/homebrew/opt/difftastic/bin


# Added by Antigravity CLI installer
set -gx PATH "/Users/keita/.local/bin" $PATH

fish_add_path -a "/Users/keita/.foundry/bin"
