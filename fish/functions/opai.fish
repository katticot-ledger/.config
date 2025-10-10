#
# NAME
#   opai - Set OpenAI API key from 1Password
#
# SYNOPSIS
#   opai
#
# DESCRIPTION
#   Retrieves the OpenAI API key from 1Password and sets it as an exported
#   environment variable in the current Fish shell session. Uses the 1Password
#   CLI to securely access credentials without exposing them in plaintext files.
#
# 1PASSWORD VAULT
#   Vault: private
#   Item: OpenAI
#   Field: credential
#
# ENVIRONMENT VARIABLES
#   OPENAI_API_KEY
#       Set globally and exported for the current session
#
# DEPENDENCIES
#   op (1Password CLI)
#   1Password desktop app (must be unlocked)
#
# EXAMPLES
#   opai                     # Set OpenAI API key for current session
#
# USAGE NOTES
#   - Requires 1Password CLI to be configured and authenticated
#   - API key is available for the duration of the shell session
#   - Key is not persisted across shell restarts for security
#   - Use in shell startup files for automatic configuration
#
# SECURITY
#   This method is more secure than storing API keys in plain text files
#   or shell configuration files. The key is retrieved securely from
#   1Password's encrypted vault on demand.
#
# SEE ALSO
#   op(1) anthropic(1) cla(1)
#
function opai --wraps='OPENAI_API_KEY' --description 'Set OpenAI API key from 1Password'
    set -gx OPENAI_API_KEY (op read op://private/OpenAI/credential --no-newline)
end
