function clear_AI --description "Unset Anthropic/Claude env vars"
    set -l removed 0

    if set -q ANTHROPIC_AUTH_TOKEN
        set -e ANTHROPIC_AUTH_TOKEN
        set removed 1
    end

    if set -q ANTHROPIC_BASE_URL
        set -e ANTHROPIC_BASE_URL
        set removed 1
    end

    if test $removed -eq 1
        echo "Cleared: ANTHROPIC_AUTH_TOKEN and/or ANTHROPIC_BASE_URL."
    else
        echo "No Anthropic env vars were set."
    end
end
