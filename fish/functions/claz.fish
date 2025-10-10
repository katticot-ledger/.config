function claz --description "Run Claude with Z AI Anthropic endpoint"
    # Export env vars only for this invocation
    set -lx ANTHROPIC_AUTH_TOKEN 'cc697eb7f30047ebb9bc388abb0c35f0.urarJjNwJ4EnoUzm'
    set -lx ANTHROPIC_BASE_URL 'https://api.z.ai/api/anthropic'

    if type -q claude
        command claude $argv
    else if type -q anthropic
        command anthropic $argv
    else
        echo "Error: 'claude' or 'anthropic' CLI not found in PATH." 1>&2
        echo "Install a CLI and retry (e.g., pipx install anthropic)." 1>&2
        return 127
    end
end
