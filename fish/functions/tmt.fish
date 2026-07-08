#
# NAME
#   tmt - Tmux Template creator
#
# SYNOPSIS
#   tmt [TEMPLATE_NAME]
#
# DESCRIPTION
#   Creates tmux window layouts from predefined templates.
#   Each template sets up multiple panes with specific layouts.
#
# TEMPLATES
#   dev      - Developer layout (editor + terminal + logs)
#   split    - Simple 2-pane horizontal split
#   vsplit   - Simple 2-pane vertical split
#   triple   - 3 panes horizontal
#   quad     - 4 panes in grid
#   main     - Main pane + 2 side panes
#
# EXAMPLES
#   tmt           # Interactive template selector
#   tmt dev       # Create dev layout directly
#   tmt split     # Create split layout directly
#
# SEE ALSO
#   tmux(1), tml
#
function tmt --description "Tmux template creator"
    if not test -n "$TMUX"
        echo "Error: Not in a tmux session"
        return 1
    end

    set -l templates \
        "split|2 panes horizontal (50/50)" \
        "vsplit|2 panes vertical (50/50)" \
        "triple|3 panes horizontal" \
        "quad|4 panes in grid" \
        "dev|Developer (1 large + 2 small)" \
        "main|Main pane + 2 side panes"

    set -l template ""

    # If argument provided, use it; otherwise show selector
    if test (count $argv) -ge 1
        set template $argv[1]
    else
        set -l selection (printf "%s\n" $templates | sed 's/|/ - /' | fzf --prompt="Select template: " --height=40% --reverse --border)
        if test -z "$selection"
            return
        end
        set template (echo $selection | awk '{print $1}')
    end

    # Get current pane count
    set -l pane_count (tmux display-message -p '#{window_panes}')
    
    # If more than 1 pane exists, ask to clear
    if test $pane_count -gt 1
        read -P "Multiple panes exist. Clear them first? (y/n): " -l response
        if test "$response" = "y"
            # Kill all panes except current
            tmux kill-pane -a
        else
            echo "Cancelled - please clear panes first"
            return
        end
    end

    # Apply template
    switch $template
        case split
            tmux split-window -h
            tmux select-layout even-horizontal
            echo "✓ Created: 2 panes horizontal"

        case vsplit
            tmux split-window -v
            tmux select-layout even-vertical
            echo "✓ Created: 2 panes vertical"

        case triple
            tmux split-window -h
            tmux split-window -h
            tmux select-layout even-horizontal
            echo "✓ Created: 3 panes horizontal"

        case quad
            tmux split-window -h
            tmux split-window -v
            tmux select-pane -t 0
            tmux split-window -v
            tmux select-layout tiled
            echo "✓ Created: 4 panes in grid"

        case dev
            # Large main pane (editor) + 2 small panes on right
            tmux split-window -h -p 30
            tmux split-window -v
            tmux select-pane -t :.0
            echo "✓ Created: Developer layout (main + terminal + logs)"

        case main
            # Main pane on left, 2 stacked on right
            tmux split-window -h -p 40
            tmux split-window -v
            tmux select-layout main-vertical
            tmux select-pane -t :.0
            echo "✓ Created: Main pane + 2 side panes"

        case '*'
            echo "Unknown template: $template"
            echo "Available: split, vsplit, triple, quad, dev, main"
            return 1
    end
end
