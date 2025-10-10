#
# NAME
#   anthropic - Set or unset Anthropic API environment variables
#
# SYNOPSIS
#   anthropic set
#   anthropic unset
#
# DESCRIPTION
#   Manages Anthropic API environment variables for accessing Claude API through
#   a custom endpoint. Uses 1Password for secure API key retrieval and stores
#   variables in the universal Fish shell store.
#
# COMMANDS
#   set
#       Set ANTHROPIC_BASE_URL and ANTHROPIC_API_KEY environment variables.
#       Base URL is configured for Moonshot API endpoint. API key is retrieved
#       securely from 1Password item 'n5osdjjwf7tkhyq7lfjkimp4ju' field 'api-key'.
#
#   unset
#       Remove both ANTHROPIC_BASE_URL and ANTHROPIC_API_KEY from current session
#       and universal store.
#
# ENVIRONMENT VARIABLES
#   ANTHROPIC_BASE_URL
#       API endpoint URL (set to https://api.moonshot.ai/anthropic)
#   ANTHROPIC_API_KEY
#       API authentication key retrieved from 1Password
#
# DEPENDENCIES
#   op (1Password CLI)
#
# EXAMPLES
#   anthropic set          # Configure API credentials
#   anthropic unset        # Remove API credentials
#
# SECURITY
#   API key is stored in universal Fish variables and retrieved from 1Password.
#   Ensure 1Password is properly configured and authenticated.
#
# SEE ALSO
#   op(1) cla(1) claude(1)
#
function anthropic --description "Set or unset Anthropic API environment variables"
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
