#
# NAME
#   ff - Fuzzy find content in files with ripgrep and open in nvim
#
# SYNOPSIS
#   ff [QUERY]
#
# DESCRIPTION
#   Provides a powerful file content search interface using ripgrep for searching
#   and fzf-tmux for interactive selection. Opens selected files at the exact
#   line number in nvim.
#
# OPTIONS
#   QUERY
#       Initial search query for ripgrep (optional)
#
# FEATURES
#   - Live ripgrep search as you type
#   - Custom dark color scheme
#   - Rounded borders and 60% tmux popup layout
#   - Syntax highlighted previews with bat (OneHalfDark theme)
#   - Line number highlighting in previews
#
# DEPENDENCIES
#   rg (ripgrep)
#   fzf (fuzzy finder)
#   bat (syntax highlighter)
#   nvim (editor)
#
# EXAMPLES
#   ff                        # Start with empty search
#   ff "function claude"      # Search for "function claude" in files
#
function ff --description "Fuzzy find content in files with ripgrep and open in nvim"
    set rg_prefix "rg --column --line-number --no-heading --color=always --smart-case"
    FZF_DEFAULT_OPTS="--color=bg+:#1d1f21,fg:#c5c8c6,fg+:#ffffff,bg:#282a36 --border=rounded --margin=0,0" set selected (fzf-tmux -u 60% --layout=reverse --ansi --disabled --query "$argv" \
        --bind "start:reload:$rg_prefix {q} || true" \
        --bind "change:reload:sleep 0.1; $rg_prefix {q} || true" \
        --delimiter : \
        --preview "bat --theme='OneHalfDark' --style=grid,numbers --color=always --highlight-line {2} {1}" \
        --preview-window "right:60%:wrap")

    if test -n "$selected"
        set parts (string split : $selected)
        nvim $parts[1] +$parts[2]
    end
end
