#
# NAME
#   fvim - Fuzzy find files with ripgrep and open in nvim (compact tmux)
#
# SYNOPSIS
#   fvim [QUERY]
#
# DESCRIPTION
#   Provides a compact file search interface using ripgrep for content search
#   and fzf for fuzzy selection. Opens selected files at the exact line number
#   in nvim. Uses compact tmux layout (70% width).
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
#   - Compact tmux pane layout (70% width)
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
#   fvim                      # Start with empty search
#   fvim "function claude"    # Search for "function claude" in files
#   fvim "import.*react"      # Search with regex pattern
#
# DIFFERENCES FROM ff
#   - Uses 70% tmux width instead of 100%
#   - More compact interface for smaller screens or side-by-side work
#
# SEE ALSO
#   ff(1) fdir(1) rg(1) fzf(1)
#
function fvim --description "Fuzzy find files with ripgrep and open in nvim (compact tmux)"
    # Define the ripgrep prefix
    set rg_prefix "rg --column --line-number --no-heading --color=always --smart-case"

    # Allow passing an initial query, if no query is passed, set to an empty string
    set initial_query "$argv"

    # Run fzf with the given options
    fzf --tmux 70% --ansi --disabled --query "$initial_query" \
        --bind "start:reload:$rg_prefix {q}" \
        --bind "change:reload:sleep 0.1; $rg_prefix {q} || true" \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:become(nvim {1} +{2})'
end
