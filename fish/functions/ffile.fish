#
# NAME
#   ffile - Fuzzy find files in current directory and open in nvim
#
# SYNOPSIS
#   ffile
#
# DESCRIPTION
#   Provides a file discovery interface for the current directory using fd for
#   file finding and fzf for interactive selection. Features custom color scheme
#   and opens selected files in nvim with bat previews.
#
# FEATURES
#   - Searches current directory recursively
#   - Excludes .git and raycast directories
#   - Custom dark color scheme (bg+:#1d1f21, fg:#c5c8c6)
#   - Rounded borders and margins
#   - OneHalfDark bat theme with grid layout
#   - 60% right preview window
#
# DEPENDENCIES
#   fd (find replacement)
#   fzf-tmux (fuzzy finder with tmux integration)
#   bat (syntax highlighter)
#   nvim (editor)
#
# KEYBOARD BINDINGS
#   - Enter: Open selected file in nvim
#   - ESC: Cancel without opening
#
# EXAMPLES
#   ffile                    # Find and open files from current directory
#
# COLOR SCHEME
#   Uses custom dark theme optimized for terminal readability:
#   - Background+: #1d1f21 (dark gray)
#   - Foreground: #c5c8c6 (light gray)
#   - Highlighted foreground: #ffffff (white)
#   - Base background: #282a36 (dracula dark)
#
# SEE ALSO
#   fdir(1) ff(1) fvim(1) fconf(1)
#
function ffile --description "Fuzzy find files in current directory and open in nvim"
    FZF_DEFAULT_OPTS="--color=bg+:#1d1f21,fg:#c5c8c6,fg+:#ffffff,bg:#282a36 --border=rounded --margin=0,0" set selected_file (fd --exclude .git --exclude .svn --exclude .hg --exclude CVS --exclude node_modules --exclude bower_components --exclude vendor --exclude .pnpm-store --exclude __pycache__ --exclude .mypy_cache --exclude .pytest_cache --exclude .venv --exclude venv --exclude env --exclude target --exclude build --exclude dist --exclude out --exclude bin --exclude obj --exclude .next --exclude .idea --exclude .vscode --exclude .history --exclude log --exclude logs --exclude tmp --exclude temp --exclude coverage --exclude .cache --exclude .npm --exclude .yarn --exclude raycast --type f . | fzf-tmux -u 60% --layout=reverse --preview "bat --theme='OneHalfDark' --style=grid,numbers --color=always --line-range=:500 {}" --preview-window=right:60%:wrap)
    if test -n "$selected_file"
        nvim "$selected_file"
    end
end
