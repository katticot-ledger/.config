# Initialize zoxide for fish shell
zoxide init fish | source
fish_add_path /opt/homebrew/sbin
# Initialize starship prompt for fish shell
starship init fish | source

# Global Git configuration for excludes file
git config --global core.excludesfile ~/.config/.gitignore

# Set environment variable for VAULT_WORKSPACE_DIR
set VAULT_WORKSPACE_DIR /Users/keita.atticot/Code/Ledger/vault

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
