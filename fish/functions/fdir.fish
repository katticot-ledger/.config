#
# NAME
#   fdir - Fuzzy find directories in current directory and cd into it
#
# SYNOPSIS
#   fdir
#
# DESCRIPTION
#   Provides a directory discovery interface for the current directory using fd
#   for directory finding and fzf for interactive selection. Features the same
#   custom color scheme as ffile and previews directory contents with eza.
#
# FEATURES
#   - Searches current directory recursively for directories
#   - Excludes .git and raycast directories
#   - Custom dark color scheme (bg+:#1d1f21, fg:#c5c8c6)
#   - Rounded borders and margins
#   - eza tree preview with icons and colors
#   - 60% right preview window
#
# DEPENDENCIES
#   fd (find replacement)
#   fzf-tmux (fuzzy finder with tmux integration)
#   eza (modern ls replacement)
#
# KEYBOARD BINDINGS
#   - Enter: cd into selected directory
#   - ESC: Cancel without changing directory
#
# EXAMPLES
#   fdir                     # Find and cd into a directory from current path
#
# COLOR SCHEME
#   Uses custom dark theme optimized for terminal readability:
#   - Background+: #1d1f21 (dark gray)
#   - Foreground: #c5c8c6 (light gray)
#   - Highlighted foreground: #ffffff (white)
#   - Base background: #282a36 (dracula dark)
#
# SEE ALSO
#   ffile(1) ff(1) fvim(1) fconf(1)
#
function fdir --description "Fuzzy find directories in current directory and cd into it"
    FZF_DEFAULT_OPTS="--color=bg+:#1d1f21,fg:#c5c8c6,fg+:#ffffff,bg:#282a36 --border=rounded --margin=0,0" set selected_dir (fd --exclude .git --exclude .svn --exclude .hg --exclude CVS --exclude node_modules --exclude bower_components --exclude vendor --exclude .pnpm-store --exclude __pycache__ --exclude .mypy_cache --exclude .pytest_cache --exclude .venv --exclude venv --exclude env --exclude target --exclude build --exclude dist --exclude out --exclude bin --exclude obj --exclude .next --exclude .idea --exclude .vscode --exclude .history --exclude log --exclude logs --exclude tmp --exclude temp --exclude coverage --exclude .cache --exclude .npm --exclude .yarn --exclude raycast --type d . | fzf-tmux -u 60% --layout=reverse --preview "eza --tree --level=2 --long --git --color=always --icons --group-directories-first --header --time-style=relative --no-user --no-permissions {}" --preview-window=right:60%:wrap)
    if test -n "$selected_dir"
        cd "$selected_dir"
    end
end
