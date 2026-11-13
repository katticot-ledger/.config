# ===========================================
# 🌍 Environment & Path Setup (Global)
# ===========================================

# 🍺 Static Homebrew Setup (Eliminates `brew shellenv` fork for ~20ms faster startup)
if test -d /opt/homebrew
    set -gx HOMEBREW_PREFIX "/opt/homebrew"
    set -gx HOMEBREW_CELLAR "/opt/homebrew/Cellar"
    set -gx HOMEBREW_REPOSITORY "/opt/homebrew"
    fish_add_path --global --move --path "/opt/homebrew/bin" "/opt/homebrew/sbin"
    if not set -q INFOPATH
        set -gx INFOPATH "/opt/homebrew/share/info:"
    else
        set -gx INFOPATH "/opt/homebrew/share/info" $INFOPATH
    end
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
# Opencode
fish_add_path $HOME/.opencode/bin
# Obsidian CLI
fish_add_path /Applications/Obsidian.app/Contents/MacOS

# Fast Node Manager (fnm)
type -q fnm && fnm env --use-on-cd | source

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
    echo node_modules/ >~/.config/.gitignore
    echo '.DS_Store' >>~/.config/.gitignore
    echo '*.log' >>~/.config/.gitignore
end

# ===========================================
# 🖥️ Interactive Session Settings
# ===========================================
if status is-interactive
    # 📭 Disable system mail check
    set -e MAIL

    # 🤫 No welcome greeting (avoids stacking in restored TUIOS scrollback)
    set -g fish_greeting ""

    # 🚀 Tools Initialization
    type -q zoxide && zoxide init fish | source

    # ⌨️ Keybindings & Vi Mode
    fish_vi_key_bindings
    # Modal cursor shapes (Beam in Insert, Block in Normal/Visual)
    set -g fish_cursor_default block
    set -g fish_cursor_insert line
    set -g fish_cursor_visual block
    set -g fish_cursor_replace_one underscore

    # Quick normal mode escape: 'jk' in insert mode
    bind -M insert jk "commandline -f repaint; set fish_bind_mode default"

    bind \cn nvims
    bind \cg 'git diff; commandline -f repaint'
    bind \cl clear-screen

    # 🎨 Completion Pager Styling (Interactive fuzzy contrast)
    set -g fish_pager_color_prefix cyan --bold --underline
    set -g fish_pager_color_completion normal
    set -g fish_pager_color_description yellow
    set -g fish_pager_color_progress brwhite --background=cyan
    set -g fish_pager_color_selected_background --background=brblack

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
    alias linear 'npx @schpet/linear-cli'

    # 🌐 SSH shortcuts
    alias hostinger-vpc 'ssh hostinger-vpc'
    alias root-hostinger-vpc 'ssh root-hostinger-vpc'
    abbr -a hv ssh hostinger-vpc
    abbr -a rhv ssh root-hostinger-vpc

    # ⚡ AI Agents YOLO Mode (Skip Permissions / Approvals)
    abbr -a agy-yolo 'agy --dangerously-skip-permissions'
    abbr -a agyy 'agy --dangerously-skip-permissions'
    abbr -a ay 'agy --dangerously-skip-permissions'

    abbr -a claude-yolo 'claude --dangerously-skip-permissions'
    abbr -a claudey 'claude --dangerously-skip-permissions'
    abbr -a cy 'claude --dangerously-skip-permissions'

    abbr -a codex-yolo 'codex --dangerously-bypass-approvals-and-sandbox'
    abbr -a codexy 'codex --dangerously-bypass-approvals-and-sandbox'
    abbr -a cdy 'codex --dangerously-bypass-approvals-and-sandbox'


end

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

# Claude Code - named Powerhive accounts
function cyt --description "Run Claude Code with the tech@powerhive.com account"
    env CLAUDE_CONFIG_DIR="$HOME/.claude-tech-pow" claude $argv
end

function cyk --description "Run Claude Code with the keita@powerhive.com account"
    env CLAUDE_CONFIG_DIR="$HOME/.claude-keita-pow" claude $argv
end

abbr -a gwp gws-powerhive
abbr -a gws-per gws-personal

# 🔄 Lazy API key loader — call once before running pi to avoid blocking shell startup
function load_pi_keys --description "Load API keys from pass (password store) for pi & other tools"
    if not type -q pass
        echo "⚠️  pass not found — install it or add keys manually"
        return 1
    end

    if not set -q BRAVE_SEARCH_API_KEY
        set -l val (pass BRAVE_SEARCH_API_KEY 2>/dev/null)
        test -n "$val"; and set -Ux BRAVE_SEARCH_API_KEY $val; and echo "✓ BRAVE_SEARCH_API_KEY"
    end

    if not set -q DEEPSEEK_API_KEY
        set -l val (pass DEEPSEEK_API_KEY 2>/dev/null)
        test -n "$val"; and set -Ux DEEPSEEK_API_KEY $val; and echo "✓ DEEPSEEK_API_KEY"
    end

    if not set -q ZAI_API_KEY
        set -l val (pass zai/api-key 2>/dev/null)
        test -n "$val"; and set -Ux ZAI_API_KEY $val; and echo "✓ ZAI_API_KEY"
    end

    if not set -q MISTRAL_API_KEY
        set -l val (pass MISTRAL_API_KEY 2>/dev/null)
        test -n "$val"; and set -Ux MISTRAL_API_KEY $val; and echo "✓ MISTRAL_API_KEY"
    end

    if not set -q TYPESAFE_API_KEY
        set -l val (pass typesafe/api-key 2>/dev/null)
        test -n "$val"; and set -Ux TYPESAFE_API_KEY $val; and echo "✓ TYPESAFE_API_KEY"
    end

    echo "Done — keys are now available for pi and other tools."
end

set -gx PATH $PATH /opt/homebrew/opt/difftastic/bin

fish_add_path -a "/Users/keita/.foundry/bin"


# pi-ask-user: allow optional comment on ask_user prompts
set -gx PI_ASK_USER_ALLOW_COMMENT true

# 🔄 Graceful reboot helper (cleanly saves tuios before rebooting)
function graceful-reboot --description "Gracefully stop tuios and reboot macOS"
    if type -q tuios
        echo "Saving sessions and stopping tuios daemon..."
        tuios kill-server 2>/dev/null
        sleep 2
    end
    echo "Rebooting system..."
    sudo shutdown -r now
end

# ===========================================
# ⚡ POSIX & Bash Interop Bridge
# ===========================================
function shc --description "Run raw command in bash subshell (for POSIX snippets)"
    bash -c "$argv"
end

function source-env --description "Load .env or bash exports into fish using bass"
    if functions -q bass
        bass source $argv
    else
        echo "bass function not found in ~/.config/fish/functions"
        return 1
    end
end

