#
# NAME
#   tm1 - Keep only one tmux pane
#
# SYNOPSIS
#   tm1
#
# DESCRIPTION
#   Kills all panes in the current window except the current one.
#   Useful for quickly clearing a cluttered window layout.
#
# EXAMPLES
#   tm1    # Keep only current pane, kill all others
#
# SEE ALSO
#   tmux(1), kill-pane
#
function tm1 --description "Keep only current pane, kill all others"
    if not test -n "$TMUX"
        echo "Error: Not in a tmux session"
        return 1
    end

    set -l pane_count (tmux display-message -p '#{window_panes}')
    
    if test $pane_count -eq 1
        echo "Already only 1 pane"
        return
    end

    # Kill all panes except current (-a flag)
    tmux kill-pane -a
    echo "✓ Killed $pane_count panes, kept current one"
end
