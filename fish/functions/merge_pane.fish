#
# NAME
#   merge_pane - Merge a pane from another window horizontally
#
# SYNOPSIS
#   merge_pane WINDOW_NUMBER [PANE_NUMBER]
#
# DESCRIPTION
#   Joins a pane from the specified window into the current window,
#   arranged horizontally (side by side) by default.
#
# ARGUMENTS
#   WINDOW_NUMBER    The window number to merge from (required)
#   PANE_NUMBER      Specific pane number within the window (optional)
#
# EXAMPLES
#   merge_pane 4              # Merge first pane from window 4 horizontally
#   merge_pane 4 1            # Merge pane 1 from window 4 horizontally
#   merge_pane 2              # Merge first pane from window 2 horizontally
#
# SEE ALSO
#   tmux(1), join-pane
#
function merge_pane --description "Merge a pane from another window horizontally"
    if test (count $argv) -eq 0
        echo "Usage: merge_pane WINDOW_NUMBER [PANE_NUMBER]"
        echo "Example: merge_pane 4       # Merge pane from window 4"
        echo "Example: merge_pane 4 1     # Merge pane 1 from window 4"
        return 1
    end

    set -l window $argv[1]
    
    if test (count $argv) -eq 2
        set -l pane $argv[2]
        tmux join-pane -h -s $window.$pane
    else
        tmux join-pane -h -s $window
    end
end
