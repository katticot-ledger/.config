#
# NAME
#   fconf - Blazing-fast fuzzy find and edit config files
#
# SYNOPSIS
#   fconf [DIRECTORY] [QUERY...]
#
# DESCRIPTION
#   Provides an ultra-fast interface for finding and editing configuration files
#   using fd for file discovery and fzf for fuzzy selection with bat previews.
#   Optimized for performance with minimal dependencies and fast file operations.
#
# OPTIONS
#   DIRECTORY
#       Base directory to search (defaults to $XDG_CONFIG_HOME or ~/.config)
#
#   QUERY...
#       Initial search terms for fzf (everything after first argument)
#
# FEATURES
#   - Hidden file discovery with symlink following
#   - Excludes .git, node_modules, raycast directories
#   - Live file previews with syntax highlighting
#   - Multi-select support
#   - Keyboard shortcuts:
#     * Alt-p: Toggle preview
#     * Ctrl-y: Copy path to clipboard
#     * Ctrl-o: Reveal in Finder
#
# DEPENDENCIES
#   fd (find replacement)
#   fzf (fuzzy finder)
#   bat (syntax highlighter)
#   pbcopy (macOS clipboard)
#
# ENVIRONMENT VARIABLES
#   EDITOR
#       Preferred editor (defaults to nvim > vim > vi)
#
# EXAMPLES
#   fconf                    # Search ~/.config with default editor
#   fconf ~/.config          # Search specific directory
#   fconf ~/.config fish     # Search with initial query "fish"
#   fconf /etc nginx         # Search system nginx configs
#
# KEYBOARD BINDINGS
#   In fzf interface:
#   - Tab/Shift-Tab: Navigate multi-selection
#   - Enter: Edit selected files
#   - Alt-p: Toggle preview panel
#   - Ctrl-y: Copy file path
#   - Ctrl-o: Open containing folder
#
# SEE ALSO
#   fd(1) fzf(1) bat(1) eza(1)
#
function fconf --description "Blazing-fast fuzzy find and edit config files"
    # Base dir: arg > $XDG_CONFIG_HOME > ~/.config
    set -l base_dir (test -n "$argv[1"]; and echo $argv[1]; or echo (test -n "$XDG_CONFIG_HOME"; and echo $XDG_CONFIG_HOME; or echo ~/.config))

    # Quick deps check (fast fail)
    for cmd in fd fzf bat
        type -q $cmd; or begin
            echo "Missing: $cmd (brew install $cmd)" >&2
            return 1
        end
    end

    # Choose editor quickly
    set -l editor (set -q EDITOR; and echo $EDITOR; or begin
        type -q nvim; and echo nvim; or type -q vim; and echo vim; or echo vi
    end)

    # Optional initial query (everything after the 1st arg)
    set -l query (string join " " $argv[2..-1])

    # Fast file list (hidden, follow symlinks, ignore junk)
    set -l files (fd --hidden --follow --color=never --type f \
        --exclude .git --exclude node_modules --exclude raycast \
        . $base_dir)

    test (count $files) -eq 0; and begin
        echo "No files found in: $base_dir"
        return 1
    end

    # fzf tuned for speed: v2 algo, no sort, preview hidden by default
    set -l selected (printf "%s\n" $files | fzf \
        --query="$query" \
        --algo=v2 \
        --no-sort \
        --tiebreak=begin,index \
        --height=85% --layout=reverse --border \
        --prompt=" config> " \
        --multi --cycle \
        --preview='bat --style=plain --color=always --paging=never --line-range=:300 {}' \
        --preview-window=right,60%,wrap,hidden \
        --bind 'alt-p:toggle-preview' \
        --bind 'ctrl-y:execute-silent(echo -n {} | pbcopy)' \
        --bind 'ctrl-o:execute-silent(open -R {})' \
        --bind 'enter:accept')

    test -z "$selected"; and return

    # Open selection (handles multi-select)
    $editor $selected
end
