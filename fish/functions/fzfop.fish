#
# NAME
#   fzfop - Fuzzy find 1Password items and copy ID to clipboard
#
# SYNOPSIS
#   fzfop
#
# DESCRIPTION
#   Provides an interactive fzf interface for browsing 1Password items and copying
#   their IDs to the clipboard. Displays item titles and vault names for easy
#   selection while keeping the ID handy for API operations.
#
# FEATURES
#   - Lists all accessible 1Password items with titles and vault names
#   - Fuzzy search for quick item discovery
#   - Copies item ID to clipboard on selection (macOS pbcopy)
#   - Secure authentication requirement before access
#
# OUTPUT FORMAT
#   Display: Title<TAB>Vault Name
#   Copied: Item ID (to clipboard)
#
# DEPENDENCIES
#   op (1Password CLI)
#   jq (JSON processor)
#   fzf (fuzzy finder)
#   pbcopy (macOS clipboard utility)
#
# PREREQUISITES
#   - Must be signed in to 1Password with 'op signin'
#   - 1Password CLI must be configured
#
# EXAMPLES
#   fzfop                     # Launch 1Password item selector
#
# WORKFLOW
#   1. Verify 1Password authentication
#   2. Fetch items via 'op item list'
#   3. Parse JSON to extract title, vault, and ID
#   4. Display in fzf with title and vault columns
#   5. Copy selected item's ID to clipboard
#
# KEYBOARD BINDINGS
#   - Enter: Copy ID to clipboard and exit
#   - ESC: Cancel without copying
#   - Arrow keys: Navigate selection
#
# SECURITY NOTES
#   - Requires 1Password authentication
#   - Only copies item IDs, not passwords or sensitive data
#   - IDs are useful for API operations with op CLI
#
# ERROR HANDLING
#   - Checks for 1Password sign-in status
#   - Handles empty vault gracefully
#   - Provides feedback on successful copy operation
#
# SEE ALSO
#   op(1) opai(1) anthropic(1)
#
function fzfop --description "Fuzzy find 1Password items and copy ID to clipboard"
    # Ensure signed in
    if not op account get >/dev/null 2>&1
        echo "You must sign in to 1Password first using 'op signin'"
        return 1
    end

    # Build list: title<TAB>vault<TAB>id  (vault may be empty)
    set -l list (op item list --format json | jq -r '.[] | "\(.title)\t\(.vault.name // "-")\t\(.id)"')

    if test (count $list) -eq 0
        echo "No 1Password items found."
        return 1
    end

    # FZF: show Title & Vault only, copy ID on Enter (macOS pbcopy)
    printf "%s\n" $list | fzf \
        --with-nth=1,2 \
        --delimiter='\t' \
        --prompt="Select 1Password item > " \
        --bind 'enter:execute-silent(echo {3} | pbcopy)+abort'

    and echo "✅ Item ID copied to clipboard."
end
