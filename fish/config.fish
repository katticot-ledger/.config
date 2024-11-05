#Aliases

# Initialize zoxide for fish shell
fish_add_path /opt/homebrew/sbin
fish_add_path /opt/homebrew/bin
zoxide init fish | source
# Initialize starship prompt for fish shell
starship init fish | source

# Global Git configuration for excludes file
git config --global core.excludesfile ~/.config/.gitignore

# Set environment variable for VAULT_WORKSPACE_DIR
set VAULT_WORKSPACE_DIR /Users/keita.atticot/Code/Ledger/vault
bind \cn nvims
bind \cg 'git diff; commandline -f repaint'
bind \cl clear-screen


# Set Jira secrets
set -Ux JIRA_USERNAME keita.atticot@ledger.fr 
# Check if the environment variable for JIRA_API_TOKEN is already set
if not set -q JIRA_API_TOKEN
    # If it's not set, retrieve the JIRA API token from 1Password and store it as a universal variable
    set -Ux JIRA_API_TOKEN (op item get ocj3glcbzdaxevswcn2kvrmx3i --fields token)
end

# Set Github token
# Check if the environment variable for GH_TOKEN is already set
if not set -q GH_TOKEN
    # If it's not set, retrieve the GitHub token from 1Password and store it as a universal variable
    set -Ux GH_TOKEN (op item get hit73pl5zuvp7ct5zvkrrqrwn4 --fields token)
end

# Set other environment variables

# Extend PATH with Python binaries directory
set -gx PATH /Users/keita.atticot/Library/Python/3.9/bin $PATH

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "/Users/keita.atticot/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# pnpm
set -gx PNPM_HOME "/Users/keita.atticot/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
#

eval "$(/opt/homebrew/bin/brew shellenv)"
