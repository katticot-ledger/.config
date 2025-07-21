# .config

Personal configuration files for development environment

## Overview

This repository contains my complete development environment configuration, including:

- **Fish Shell** - Configuration, functions, and completions
- **Neovim** - Editor configuration with lazy.nvim plugins
- **Tmux** - Terminal multiplexer with custom plugins
- **Git** - Version control settings
- **Zed** - Modern code editor settings
- **Google Cloud SDK** - Development tool configurations
- **Various CLI Tools** - Starship, Raycast, window managers, etc.

## Quick Setup After Computer Reset

### 1. Prerequisites

Install essential tools first:

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Git and SSH tools
brew install git openssh

# Install Fish shell
brew install fish

# Make Fish the default shell
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)
```

### 2. Clone This Repository

```bash
# Clone to ~/.config
git clone git@github.com:katticot-ledger/.config.git ~/.config

# Or if SSH keys aren't set up yet:
git clone https://github.com/katticot-ledger/.config.git ~/.config
```

### 3. Essential Post-Clone Setup

```bash
# Install additional tools
brew install neovim tmux starship eza fzf

# Install Bun (JavaScript runtime)
curl -fsSL https://bun.sh/install | bash

# Install pnpm
npm install -g pnpm

# Start Fish shell to load configuration
fish
```

### 4. Tool-Specific Setup

- **Neovim**: Launch `nvim` - plugins will install automatically via lazy.nvim
- **Tmux**: Start tmux - plugins in `tmux/plugins/` are included
- **Google Cloud**: Run `gcloud auth login` and configure projects
- **1Password**: Install and configure for secret management
- **SSH Keys**: Generate new keys and add to GitHub

### 5. Additional Configurations

Some files need manual setup:

- **Sensitive Credentials**: Re-authenticate with Google Cloud, 1Password, etc.
- **SSH Keys**: Generate and configure new keys for GitHub access
- **Shell History**: Will rebuild over time
- **Application-Specific**: Raycast, window managers may need reconfiguration

## Structure

```
.config/
├── fish/           # Fish shell configuration
├── nvim/           # Neovim configuration  
├── tmux/           # Tmux configuration and plugins
├── git/            # Git configuration
├── zed/            # Zed editor settings
├── gcloud/         # Google Cloud SDK configs
├── starship.toml   # Prompt configuration
└── ...             # Other tool configurations
```

## Security Notes

- Sensitive files (credentials, tokens) are excluded via `.gitignore`
- SSH keys are NOT backed up - generate new ones after reset
- Re-authenticate with services after restore
