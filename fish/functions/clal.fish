#
# NAME
#   clal - Run Claude AI assistant with Linear MCP integration
#
# SYNOPSIS
#   clal [OPTIONS] [ARGS...]
#
# DESCRIPTION
#   Wrapper function that runs claude with Linear MCP (Model Context Protocol)
#   configuration and dangerous mode enabled. This provides Claude with access
#   to Linear project management functionality for issue tracking, task management,
#   and team collaboration workflows.
#
# OPTIONS
#   All options are passed through to the underlying claude command.
#
# CONFIGURATION
#   Uses MCP configuration file: /Users/keita/.mcp-linear.json
#
# EXAMPLES
#   clal "Create a new issue in Linear for the bug we found"
#   clal "Show me all open issues assigned to me"
#   clal "Update the status of issue ABC-123 to In Progress"
#
# CAUTION
#   This function skips permission checks which may be a security risk.
#
# SEE ALSO
#   cla(1) clad(1) claf(1) cladr(1)
#
function clal --description "Run Claude AI assistant with Linear MCP integration"
    claude --dangerously-skip-permissions --mcp-config /Users/keita/.mcp-linear.json $argv
end