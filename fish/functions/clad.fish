#
# NAME
#   clad - Run Claude AI assistant with dangerous mode enabled
#
# SYNOPSIS
#   clad [OPTIONS] [ARGS...]
#
# DESCRIPTION
#   Wrapper function that runs claude with the --dangerously-skip-permissions flag.
#   This mode bypasses permission checks and should be used with caution as it
#   may allow Claude to execute commands without explicit confirmation.
#
# OPTIONS
#   All options are passed through to the underlying claude command.
#
# EXAMPLES
#   clad "Help me debug this code"
#   clad --model claude-3-haiku-20240307 "Write a shell script"
#
# CAUTION
#   This function skips permission checks which may be a security risk.
#
# SEE ALSO
#   cla(1) clal(1) claf(1) cladr(1)
#
function clad --description "Run Claude AI assistant with dangerous mode enabled"
    claude --dangerously-skip-permissions $argv
end
