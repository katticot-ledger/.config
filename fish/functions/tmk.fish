#
# NAME
#   tmk - Tmux Kill session
#
# SYNOPSIS
#   tmk
#
# DESCRIPTION
#   Interactive session killer using fzf. Select one or multiple
#   sessions to kill. Shows session details to help you choose.
#
# EXAMPLES
#   tmk    # Opens interactive session killer
#
# SEE ALSO
#   tmux(1), fzf(1)
#
function tmk --description "Interactive tmux session killer"
    if not tmux list-sessions 2>/dev/null
        echo "No tmux sessions found."
        return
    end

    # Get list of sessions with details
    set -l sessions (tmux list-sessions -F "#{session_name}: #{session_windows} windows, #{session_attached} attached (created #{session_created_string})" | fzf --multi --prompt="Select session(s) to kill (TAB for multi): " --height=40% --reverse --border)
    
    if test -z "$sessions"
        return
    end

    # Confirm before killing
    set -l session_count (echo "$sessions" | wc -l | string trim)
    read -P "Kill $session_count session(s)? (y/n): " -l response
    
    if test "$response" = "y"
        for session in $sessions
            set -l session_name (echo $session | cut -d: -f1)
            tmux kill-session -t "$session_name"
            echo "Killed session: $session_name"
        end
    else
        echo "Cancelled"
    end
end
