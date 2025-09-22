function anthropic --description "Set or unset Anthropic API environment vars"
    if test (count $argv) -eq 0
        echo "Usage: anthropic set | unset"
        return 1
    end

    switch $argv[1]
        case set
            # Base URL is a constant
            set -Ux ANTHROPIC_BASE_URL https://api.moonshot.ai/anthropic

            # Pull the key securely from 1Password (replace the item ID & field as needed)
            set -Ux ANTHROPIC_API_KEY \
                (op item get n5osdjjwf7tkhyq7lfjkimp4ju --fields api-key)
            echo "Anthropic vars set (universal, exported)"

        case unset
            # Remove them from the current session *and* universal store
            set -e ANTHROPIC_BASE_URL
            set -e ANTHROPIC_API_KEY
            echo "Anthropic vars unset"

        case '*'
            echo "Unknown subcommand: $argv[1]; use set or unset"
            return 1
    end
end
