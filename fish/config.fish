# Initialize zoxide for fish shell
zoxide init fish | source

# Initialize starship prompt for fish shell
starship init fish | source

# Global Git configuration for excludes file
git config --global core.excludesfile ~/.config/.gitignore

# Set environment variable for VAULT_WORKSPACE_DIR
set VAULT_WORKSPACE_DIR /Users/keita.atticot/Code/Ledger/vault

# Extend PATH with Python binaries directory
set -gx PATH /Users/keita.atticot/Library/Python/3.9/bin $PATH

# Check if OPENAI_API_KEY is already set
if not set -q OPENAI_API_KEY
    # Attempt to set OPENAI_API_KEY from 1Password if it's not set
    set -gx OPENAI_API_KEY (op read op://private/OpenAI/credential --no-newline)

    # Additional check to see if OPENAI_API_KEY was successfully set
    if not set -q OPENAI_API_KEY
        echo "Error: OPENAI_API_KEY is not set. Please ensure it is available."
    end
end

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
# Prepend Rancher Desktop binaries to PATH
set --export --prepend PATH "/Users/keita.atticot/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
