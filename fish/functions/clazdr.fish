#
# NAME
#   clazdr - Run Claude AI assistant with dangerous mode, resume capability, and Z AI endpoint
#
# SYNOPSIS
#   clazdr [OPTIONS] [ARGS...]
#
# DESCRIPTION
#   Wrapper function that runs claude with both --dangerously-skip-permissions
#   and --resume flags, plus Z AI endpoint. This enables dangerous mode while also
#   allowing resumption of previous sessions or conversations, routing through the
#   Z AI proxy endpoint.
#
# OPTIONS
#   All options are passed through to the underlying claude command.
#
# CONFIGURATION
#   Uses Z AI endpoint: https://api.z.ai/api/anthropic
#
# EXAMPLES
#   clazdr "Continue where we left off"
#   clazdr --session-id abc123 "Resume our previous conversation"
#
# CAUTION
#   This function skips permission checks which may be a security risk.
#
# SEE ALSO
#   cla(1) clad(1) clal(1) claf(1) claz(1)
#
function clazdr --description "Run Claude AI assistant with dangerous mode, resume capability, and Z AI endpoint"
    # Export env vars only for this invocation
    set -lx ANTHROPIC_AUTH_TOKEN 'cc697eb7f30047ebb9bc388abb0c35f0.urarJjNwJ4EnoUzm'
    set -lx ANTHROPIC_BASE_URL 'https://api.z.ai/api/anthropic'

    claude --dangerously-skip-permissions --resume $argv
end