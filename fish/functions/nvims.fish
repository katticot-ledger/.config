#
# NAME
#   nvims - Fuzzy find files and open in nvim with tmux integration
#
# SYNOPSIS
#   nvims
#
# DESCRIPTION
#   Provides a simple file selection interface using fzf-tmux and opens the
#   selected file in nvim. Uses bat for file previews with the TwoDark theme
#   and integrates with tmux for a clean interface.
#
# FEATURES
#   - tmux integration for pane management
#   - File previews with syntax highlighting
#   - TwoDark color theme for comfortable viewing
#   - 70% height with reverse layout
#   - Line numbers in previews
#
# DEPENDENCIES
#   fzf-tmux (fuzzy finder with tmux support)
#   bat (syntax highlighter)
#   nvim (editor)
#   tmux (terminal multiplexer)
#
# PREVIEW CONFIGURATION
#   - Theme: TwoDark
#   - Style: Numbers with line highlighting
#   - Lines: First 500 lines for performance
#   - Layout: Reverse (search at bottom)
#   - Height: 70% of tmux pane
#
# KEYBOARD BINDINGS
#   - Enter: Open selected file in nvim
#   - ESC: Cancel without opening
#   - Arrow keys/Ctrl-p/n: Navigate selection
#
# EXAMPLES
#   nvims                    # Launch file selector and open in nvim
#
# USAGE NOTES
#   - Searches from current directory recursively
#   - Follows gitignore and other standard exclusions via fzf defaults
#   - Preview automatically updates as selection changes
#
# DIFFERENCES FROM OTHER FUZZY FINDERS
#   - Simpler than ff/fvim (no ripgrep search)
#   - tmux-native interface
#   - Focused on file discovery, not content search
#
# SEE ALSO
#   ff(1) fvim(1) fdir(1) fzf(1) bat(1) nvim(1)
#
function nvims --description "Fuzzy find files and open in nvim with tmux integration"
    nvim $(fzf-tmux --preview "bat --theme  TwoDark --color=always  --style=numbers --line-range=:500 {}" --height 70% --reverse)
end
