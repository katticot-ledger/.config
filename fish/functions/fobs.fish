#
# NAME
#   fobs - Fuzzy find and edit Obsidian vault files
#
# SYNOPSIS
#   fobs
#
# DESCRIPTION
#   Provides a fuzzy finding interface for files in the Obsidian vault located at
#   ~/Library/Mobile Documents/iCloud~md~obsidian/Documents/obsidian. Uses fd for
#   file discovery and fzf for interactive selection with bat previews.
#
# FEATURES
#   - Automatically navigates to Obsidian vault directory
#   - Excludes raycast directory from search
#   - Live file previews with syntax highlighting
#   - Opens selected files in nvim
#
# DEPENDENCIES
#   fd (find replacement)
#   fzf (fuzzy finder)
#   bat (syntax highlighter)
#   nvim (editor)
#
# KEYBOARD BINDINGS
#   In fzf interface:
#   - Ctrl-/: Toggle preview
#   - Enter: Open selected file in nvim
#   - ESC: Cancel without opening
#
# EXAMPLES
#   fobs                     # Open Obsidian vault file selector
#
# NOTES
#   Function changes the current working directory to the Obsidian vault
#   before file selection. File paths are relative to the vault root.
#
# SEE ALSO
#   fconf(1) fd(1) fzf(1) bat(1) nvim(1)
#
function fobs --description "Fuzzy find and edit Obsidian vault files"
    set base_dir '/Users/keita/Library/Mobile Documents/iCloud~md~obsidian/Documents/obsidian'

    cd $base_dir
    set selected_file (fd --exclude raycast --type f . | \
       fzf --preview "bat --style=numbers --color=always --line-range=:500 {}" \
       --height 40% \
       --border rounded \
       --preview-window right:60% \
       --bind 'ctrl-/:toggle-preview')

    if test $selected_file
        nvim "$selected_file"
    end
end
