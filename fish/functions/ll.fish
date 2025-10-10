#
# NAME
#   ll - Enhanced directory listing with eza
#
# SYNOPSIS
#   ll [DIRECTORY...]
#
# DESCRIPTION
#   Provides an enhanced directory listing using eza (modern ls replacement) with
#   icons, colors, and detailed information. Shows hidden files and displays sizes
#   in binary format for better readability.
#
# OPTIONS
#   DIRECTORY...
#       One or more directories to list (defaults to current directory)
#
# FEATURES
#   - Long format with detailed file information
#   - File and directory icons (always enabled)
#   - Enhanced color-coded output with gradient scaling
#   - Color-coded file sizes (no age coloring since dates are hidden)
#   - Hidden files shown (dotfiles)
#   - Binary file sizes (KB, MB, GB)
#   - Group directories first
#   - Header with column titles
#   - No user/permission columns (cleaner output)
#   - No date/time columns (compact display)
#
# DEPENDENCIES
#   eza (modern ls replacement)
#
# EXAMPLES
#   ll                       # List current directory
#   ll ~/.config             # List config directory
#   ll src docs              # List multiple directories
#
# OUTPUT COLUMNS
#   - Permissions (simplified)
#   - File size (binary format)
#   - Filename with icons
#
# SEE ALSO
#   ls(1) eza(1) la(1) l(1)
#
function ll --wraps=ls --description "Enhanced directory listing with eza"
    eza -la --binary --group-directories-first --header --no-user --no-permissions \
        --color=always --color-scale=size --color-scale-mode=gradient \
        --icons=always --no-time $argv
end
