#
# NAME
#   clazd - Run Claude AI assistant with dangerous mode enabled and Z AI endpoint
#
# SYNOPSIS
#   clazd [OPTIONS] [ARGS...]
#
# DESCRIPTION
#   Wrapper function that runs claude with the --dangerously-skip-permissions flag
#   and Z AI endpoint. This mode bypasses permission checks and should be used with
#   caution as it may allow Claude to execute commands without explicit confirmation,
#   routing through the Z AI proxy endpoint.
#
# OPTIONS
#   All options are passed through to the underlying claude command.
#
# CONFIGURATION
#   Uses Z AI endpoint: https://api.z.ai/api/anthropic
#
# EXAMPLES
#   clazd "Help me debug this code"
#   clazd --model claude-3-haiku-20240307 "Write a shell script"
#
# CAUTION
#   This function skips permission checks which may be a security risk.
#
# SEE ALSO
#   cla(1) clad(1) clal(1) claf(1) claz(1)
#
function clazd --description "Run Claude AI assistant with dangerous mode enabled and Z AI endpoint"
    # Export env vars only for this invocation
    set -lx ANTHROPIC_AUTH_TOKEN 'cc697eb7f30047ebb9bc388abb0c35f0.urarJjNwJ4EnoUzm'
    set -lx ANTHROPIC_BASE_URL 'https://api.z.ai/api/anthropic'

    claude --dangerously-skip-permissions $argv
end