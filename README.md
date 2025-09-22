# .config

Personal configuration files for development environment

## Overview

This repository contains my complete development environment configuration with tools organized by function:

### 🖥️ Terminal Emulators & Multiplexers
- **[Ghostty](https://ghostty.org/)** - Fast, native terminal emulator
- **[Kitty](https://sw.kovidgoyal.net/kitty/)** - GPU-accelerated terminal emulator
- **[WezTerm](https://wezfurlong.org/wezterm/)** - GPU-accelerated cross-platform terminal
- **[Tmux](https://github.com/tmux/tmux)** - Terminal multiplexer with custom plugins

### 🐚 Shell & Command Line
- **[Fish](https://fishshell.com/)** - Friendly interactive shell with completions
- **[Starship](https://starship.rs/)** - Cross-shell prompt with customization
- **[Atuin](https://atuin.sh/)** - Shell history replacement with sync
- **[Broot](https://dystroy.org/broot/)** - Interactive tree view file navigator

### 💻 Code Editors
- **[Neovim](https://neovim.io/)** - Hyperextensible Vim-based editor with lazy.nvim

### 🔧 Development Tools
- **[Git](https://git-scm.com/)** - Version control with custom configuration
- **[GitHub CLI](https://cli.github.com/)** - Command-line GitHub integration
- **[GitHub Copilot CLI](https://docs.github.com/en/copilot/github-copilot-in-the-cli)** - AI-powered command suggestions
- **[GitHub Dash](https://github.com/dlvhdr/gh-dash)** - GitHub dashboard in terminal
- **[Google Cloud SDK](https://cloud.google.com/sdk)** - Cloud development and deployment

### 🪟 Window Management (macOS)
- **[Yabai](https://github.com/koekeishiya/yabai)** - Tiling window manager
- **[SKHD](https://github.com/koekeishiya/skhd)** - Simple hotkey daemon
- **[SketchyBar](https://github.com/FelixKratz/SketchyBar)** - Custom macOS menu bar

### 📊 System Monitoring
- **[Btop](https://github.com/aristocratos/btop)** - Resource monitor with beautiful interface
- **[WTF](https://wtfutil.com/)** - Personal information dashboard

### 🚀 Productivity & Utilities
- **[Raycast](https://raycast.com/)** - Extensible launcher and productivity tool
- **[1Password CLI](https://developer.1password.com/docs/cli)** - Password and secrets management
- **Homebrew Package Manager Script** - Custom Python script for package management

### ☁️ Cloud & Infrastructure
- **[AWS CLI](https://aws.amazon.com/cli/)** - AWS management from the terminal
- **[k9s](https://k9scli.io/)** - Terminal UI for Kubernetes clusters
- **[kubectx](https://github.com/ahmetb/kubectx)** - Switch between Kubernetes contexts and namespaces
- **[Tunnelblick](https://tunnelblick.net/)** - OpenVPN client for macOS

### 🔄 Runtime & Package Managers
- **[nvm](https://github.com/nvm-sh/nvm)** - Node.js version manager
- **[Yarn](https://yarnpkg.com/)** - JavaScript package manager
- **[PDM](https://pdm.fming.dev/)** - Python package and environment manager

### ⌨️ Hardware Configuration
- **[Glove80](https://www.moergo.com/collections/glove80-keyboards)** - Ergonomic keyboard layout and configuration

## Quick Setup After Computer Reset

### 1. Prerequisites

Install essential tools first:

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Git, SSH tools, and Python3
brew install git openssh python3

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

### 3. Install Development Tools

#### Option A: Automated Installation (Recommended)

Use the included Python installation script for an interactive setup or direct CLI control:

```bash
# Run the comprehensive installation tool
cd ~/.config
python3 main.py
```

The script now supports both an interactive menu and command-line flags:

```
Usage: python3 main.py [options]

Optional arguments:
  --list             List categories and packages
  --install CATEGORY Install a single category (can be repeated)
  --install-all      Install every category without prompts
  --post-install     Run the post-installation helpers (bun, pnpm, fish shell)
  --update-brew      Run `brew update` and upgrade installed formulae
```

Interactive mode (run without flags) lets you:

- 📦 Install every category
- 🗂️ Install a single category
- 📋 List packages before installing
- 🔧 Run the post-install helpers (bun, pnpm, fish shell)
- 🔄 Update Homebrew

#### Option B: Manual Installation by Category

```bash
# 🖥️ Terminal Emulators & Multiplexers
brew install --cask ghostty
brew install kitty
brew install --cask wezterm
brew install tmux

# 🐚 Shell & Command Line Tools
brew install fish starship atuin broot eza fzf

# 💻 Code Editors
brew install neovim

# 🔧 Development Tools
brew install git gh
gh extension install github/gh-copilot
gh extension install dlvhdr/gh-dash
brew install --cask google-cloud-sdk

# ☁️ Cloud & Infrastructure
brew install awscli k9s kubectx
brew install --cask tunnelblick

# 🪟 Window Management (macOS)
brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd
brew tap FelixKratz/formulae
brew install sketchybar

# 📊 System Monitoring
brew install btop
brew install wtfutil

# 🚀 Productivity & Utilities
brew install --cask raycast
brew install 1password-cli

# 🔄 Runtime & Package Managers
brew install nvm yarn pdm

# JavaScript Runtime (alternate install method)
curl -fsSL https://bun.sh/install | bash
npm install -g pnpm

# Make Fish the default shell
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)

# Start Fish shell to load configuration
fish
```

### 4. Tool-Specific Setup

#### 🖥️ Terminal Configuration
- **Ghostty/Kitty/WezTerm**: Configurations will be loaded automatically
- **Tmux**: Start tmux - plugins in `tmux/plugins/` are included

#### 🐚 Shell Setup
- **Fish**: Configuration loads automatically with completions and functions
- **Starship**: Prompt configuration from `starship.toml`
- **Atuin**: Run `atuin register` and `atuin login` for history sync

#### 💻 Editor Setup  
- **Neovim**: Launch `nvim` - plugins install automatically via lazy.nvim

#### 🔧 Development Tools
- **GitHub CLI**: Run `gh auth login` to authenticate
- **GitHub Copilot**: Run `gh copilot auth` after installing extension  
- **Google Cloud**: Run `gcloud auth login` and configure projects

#### 🪟 Window Management (macOS)
- **Yabai**: May require System Integrity Protection adjustments
- **SKHD**: Start with `brew services start skhd`  
- **SketchyBar**: Start with `brew services start sketchybar`

#### 🚀 Productivity Tools
- **Raycast**: Import settings and extensions manually
- **1Password**: Run `op signin` and configure vault access

### 5. Additional Configurations

Some files need manual setup:

- **Sensitive Credentials**: Re-authenticate with Google Cloud, 1Password, etc.
- **SSH Keys**: Generate and configure new keys for GitHub access
- **Shell History**: Will rebuild over time
- **Application-Specific**: Raycast, window managers may need reconfiguration

## Directory Structure

```
.config/
├── 🖥️ Terminal Emulators & Multiplexers
│   ├── ghostty/            # Ghostty terminal configuration
│   ├── kitty/              # Kitty terminal configuration  
│   ├── wezterm/            # WezTerm configuration
│   └── tmux/               # Tmux config and plugins
├── 🐚 Shell & Command Line
│   ├── fish/               # Fish shell config, functions, completions
│   ├── atuin/              # Shell history configuration
│   ├── broot/              # Interactive file tree navigator
│   └── starship.toml       # Cross-shell prompt configuration
├── 💻 Code Editors  
│   └── nvim/               # Neovim configuration with lazy.nvim
├── 🔧 Development Tools
│   ├── git/                # Git configuration and aliases
│   ├── gh/                 # GitHub CLI configuration
│   ├── gh-copilot/         # GitHub Copilot CLI settings
│   ├── gh-dash/            # GitHub dashboard configuration
│   └── gcloud/             # Google Cloud SDK configs
├── 🪟 Window Management (macOS)
│   ├── yabai/              # Tiling window manager config
│   ├── skhd/               # Hotkey daemon configuration
│   └── sketchybar/         # Custom macOS menu bar
├── 📊 System Monitoring
│   ├── btop/               # System resource monitor theme
│   └── wtf/                # Personal dashboard configuration
├── 🚀 Productivity & Utilities
│   ├── raycast/            # Launcher and productivity settings
│   ├── op/                 # 1Password CLI configuration
│   └── main.py             # Homebrew package management script
├── ⌨️ Hardware Configuration
│   └── glove80/            # Ergonomic keyboard layouts
├── 🔄 Shell Integration
│   └── zprofile            # Homebrew environment setup
└── 📚 Documentation
    └── README.md           # This comprehensive guide
```

## Security Notes

- Sensitive files (credentials, tokens) are excluded via `.gitignore`
- SSH keys are NOT backed up - generate new ones after reset
- Re-authenticate with services after restore
