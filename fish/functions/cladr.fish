#
# NAME
#   cladr - Run Claude AI assistant with dangerous mode and resume capability
#
# SYNOPSIS
#   cladr [OPTIONS] [ARGS...]
#
# DESCRIPTION
#   Wrapper function that runs claude with both --dangerously-skip-permissions
#   and --resume flags. This enables dangerous mode while also allowing resumption
#   of previous sessions or conversations.
#
# OPTIONS
#   All options are passed through to the underlying claude command.
#
# EXAMPLES
#   cladr "Continue where we left off"
#   cladr --session-id abc123 "Resume our previous conversation"
#
# CAUTION
#   This function skips permission checks which may be a security risk.
#
# SEE ALSO
#   cla(1) clad(1) clal(1) claf(1)
#
function cladr --description "Run Claude AI assistant with dangerous mode and resume capability"
    claude --dangerously-skip-permissions --resume $argv
end
