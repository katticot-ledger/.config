#
# NAME
#   tmux - Terminal multiplexer with custom configuration
#
# SYNOPSIS
#   tmux [OPTIONS] [COMMAND]
#
# DESCRIPTION
#   Wrapper function for tmux that automatically uses the custom configuration
#   file at ~/.config/tmux/tmux.conf. All arguments and options are passed
#   through to the underlying tmux command.
#
# OPTIONS
#   All tmux options are passed through unchanged.
#
# COMMANDS
#   Any tmux command can be used as normal.
#
# CONFIGURATION
#   Uses configuration file: ~/.config/tmux/tmux.conf
#
# EXAMPLES
#   tmux                     # Start tmux with custom config
#   tmux new -s mysession    # Create new session named 'mysession'
#   tmux attach -t session   # Attach to existing session
#   tmux ls                  # List sessions
#
# COMMON TMUX COMMANDS
#   - new -s <name>          Create new session
#   - attach -t <name>       Attach to session
#   - ls                     List sessions
#   - kill-session -t <name> Kill session
#
# CONFIGURATION BENEFITS
#   Using a custom config file allows for:
#   - Custom key bindings
#   - Personalized color schemes
#   - Custom status bar
#   - Plugin management
#   - Session defaults
#
# SEE ALSO
#   tmux(1) tmux.conf(5)
#
function tmux --description "Terminal multiplexer with custom configuration"
    command tmux -f ~/.config/tmux/tmux.conf $argv
end

