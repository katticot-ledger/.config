#
# NAME
#   ff - Fuzzy find files with ripgrep and open in nvim (full tmux)
#
# SYNOPSIS
#   ff [QUERY]
#
# DESCRIPTION
#   Provides a powerful file search interface using ripgrep for content search
#   and fzf for fuzzy selection. Opens selected files at the exact line number
#   in nvim. Uses full tmux layout (100% width, 70% height).
#
# OPTIONS
#   QUERY
#       Initial search query for ripgrep (optional)
#
# FEATURES
#   - Live ripgrep search as you type
#   - Line number highlighting in previews
#   - Opens files at exact line matches
#   - Syntax highlighted previews with bat
#   - Full tmux pane layout
#
# DEPENDENCIES
#   rg (ripgrep)
#   fzf (fuzzy finder)
#   bat (syntax highlighter)
#   nvim (editor)
#
# KEYBOARD BINDINGS
#   - Enter: Open file at matched line in nvim
#   - ESC: Cancel search
#
# EXAMPLES
#   ff                        # Start with empty search
#   ff "function claude"      # Search for "function claude" in files
#   ff "import.*react"        # Search with regex pattern
#
# SEARCH SYNTAX
#   Uses ripgrep syntax, supports:
#   - Plain text: "hello world"
#   - Regex: "import.*react"
#   - File patterns: --type py "def main"
#
# SEE ALSO
#   fvim(1) fdir(1) rg(1) fzf(1)
#
function ff --description "Fuzzy find files with ripgrep and open in nvim (full tmux)"
    # Define the ripgrep prefix
    set rg_prefix "rg --column --line-number --no-heading --color=always --smart-case"

    # Allow passing an initial query, if no query is passed, set to an empty string
    set initial_query "$argv"

    # Run fzf with the given options
    fzf --tmux 100%,70% --ansi --disabled --query "$initial_query" \
        --bind "start:reload:$rg_prefix {q}" \
        --bind "change:reload:sleep 0.1; $rg_prefix {q} || true" \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:become(nvim {1} +{2})'
end
