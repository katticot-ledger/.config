# .config

Personal configuration files for development environment

## Overview

This repository contains my complete development environment configuration with tools organized by function:

### 🖥️ Terminal Emulators & Multiplexers
- **[Ghostty](https://ghostty.org/)** - Fast, native terminal emulator
- **[Kitty](https://sw.kovidgoyal.net/kitty/)** - GPU-accelerated terminal emulator
- **[Tmux](https://github.com/tmux/tmux)** - Terminal multiplexer with custom plugins

### 🐚 Shell & Command Line
- **[Fish](https://fishshell.com/)** - Friendly interactive shell with completions
- **[Atuin](https://atuin.sh/)** - Shell history replacement with sync
- **[Eza](https://eza.rocks/)** - Modern `ls` replacement with git integration
- **[Fzf](https://github.com/junegunn/fzf)** - Fuzzy finder
- **[Zoxide](https://github.com/ajeetdsouza/zoxide)** - Smarter `cd` command
- **[Bat](https://github.com/sharkdp/bat)** - `cat` clone with syntax highlighting
- **[Ripgrep](https://github.com/BurntSushi/ripgrep)** - Line-oriented search tool
- **[Dust](https://github.com/bootandy/dust)** - More intuitive `du`

### 💻 Code Editors
- **[Neovim](https://neovim.io/)** - Hyperextensible Vim-based editor with lazy.nvim
- **[Zed](https://zed.dev/)** - High-performance, multiplayer code editor

### 🔧 Development Tools
- **[Git](https://git-scm.com/)** - Version control with custom configuration
- **[GitHub CLI](https://cli.github.com/)** - Command-line GitHub integration
- **[Google Cloud SDK](https://cloud.google.com/sdk)** - Cloud development and deployment
- **[Lazygit](https://github.com/jesseduffield/lazygit)** - Terminal UI for git
- **[Difftastic](https://github.com/Wilfred/difftastic)** - Structural diff tool
- **[Jq](https://jqlang.org/)** - Command-line JSON processor

### 🛠️ AI & Coding Agents
- **[Pi](https://pi.earendil.dev/)** - Coding agent with Fish integration (pic, pig, pim, piz, piup commands)
- **[OpenCode](https://opencode.ai/)** - AI coding assistant CLI

### 📂 File Management
- **[Yazi](https://yazi-rs.github.io/)** - Blazing fast terminal file manager
- **[Ytctl](https://github.com/katticot/ytctl)** - YouTube controller CLI

### 🚀 Productivity & Utilities
- **[Raycast](https://raycast.com/)** - Extensible launcher and productivity tool
- **[1Password CLI](https://developer.1password.com/docs/cli)** - Password and secrets management
- **[Todoist CLI](https://github.com/sachaos/todoist)** - Task management from terminal
- **[Notion CLI](https://github.com/notion-cli/notion)** - Notion workspace management
- **[Resend](https://resend.com/)** - Email API CLI
- **Homebrew Package Manager Script** - Custom Python script for package management
- **Herdr+** - Terminal workspace manager with projects, quick-actions, and worktrees

### 📊 System Monitoring
- **[Btop](https://github.com/aristocratos/btop)** - Resource monitor with beautiful interface

### ☁️ Cloud & Infrastructure
- **[AWS CLI](https://aws.amazon.com/cli/)** - AWS management from the terminal
- **[Google Workspace CLI (gws)](https://github.com/katticot/gws)** - Gmail, Calendar, Drive from terminal

### 🔄 Runtime & Package Managers
- **[Bun](https://bun.sh/)** - Fast JavaScript runtime and package manager
- **[Yarn](https://yarnpkg.com/)** - JavaScript package manager

### 🔐 Security & Auth
- **[Yubikey](https://www.yubico.com/)** - Hardware SSH/GPG signing key
- **[GnuPG](https://gnupg.org/)** - OpenPGP encryption and signing

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
brew install tmux

# 🐚 Shell & Command Line Tools
brew install fish atuin eza fzf zoxide bat ripgrep dust

# 💻 Code Editors
brew install neovim
brew install --cask zed

# 🔧 Development Tools
brew install git gh lazygit jq gnupg
brew install --cask google-cloud-sdk

# 📊 System Monitoring
brew install btop

# 🚀 Productivity & Utilities
brew install --cask raycast
brew install 1password-cli

# ☁️ Cloud & Infrastructure
brew install awscli

# 🔄 Runtime & Package Managers
curl -fsSL https://bun.sh/install | bash
npm install -g yarn

# Make Fish the default shell
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)

# Start Fish shell to load configuration
fish
```

### 4. Tool-Specific Setup

#### 🖥️ Terminal Configuration
- **Ghostty/Kitty**: Configurations will be loaded automatically
- **Tmux**: Start tmux — plugins install automatically via TPM

#### 🐚 Shell Setup
- **Fish**: Configuration loads automatically with completions and functions
- **Atuin**: Run `atuin register` and `atuin login` for history sync

#### 💻 Editor Setup
- **Neovim**: Launch `nvim` — plugins install automatically via lazy.nvim
- **Zed**: Import config from `~/.config/zed/`

#### 🔧 Development Tools
- **GitHub CLI**: Run `gh auth login` to authenticate
- **Google Cloud**: Run `gcloud auth login` and configure projects
- **Yubikey**: Configure SSH signing key at `~/.ssh/id_ed25519_sk.pub`

#### 🚀 Productivity Tools
- **Raycast**: Import settings and extensions manually
- **1Password**: Run `op signin` and configure vault access
- **Todoist**: Configure via `td auth login`
- **Notion**: Set up workspace in `notion/config.json`

#### 🤖 Pi Coding Agent
- Run `load_pi_keys` in Fish to load API keys from 1Password
- Use `pic`, `pig`, `pim`, `piz`, `piup` for quick pi commands
- Configured in `agents/`

#### 🗂️ Herdr+ Workspace Manager
- Install herdr: `brew install herdr`
- Configs in `herdr/` — projects, quick-actions, worktrees
- Trigger with herdr command + fuzzy picker

### 5. Additional Configurations

Some files need manual setup:

- **Sensitive Credentials**: Re-authenticate with Google Cloud, 1Password, etc.
- **SSH Keys**: Generate and configure Yubikey-backed keys for GitHub access
- **Shell History**: Will rebuild over time
- **Application-Specific**: Raycast, window managers may need reconfiguration

## Directory Structure

```
.config/
├── 🖥️ Terminal Emulators & Multiplexers
│   ├── ghostty/            # Ghostty terminal configuration
│   ├── kitty/              # Kitty terminal configuration
│   └── tmux/               # Tmux config and plugins
├── 🐚 Shell & Command Line
│   ├── fish/               # Fish shell config, functions, completions
│   └── atuin/              # Shell history configuration
├── 💻 Code Editors
│   ├── nvim/               # Neovim configuration with lazy.nvim
│   └── zed/                # Zed editor settings and keymap
├── 🔧 Development Tools
│   ├── git/                # Git configuration and aliases
│   ├── gh/                 # GitHub CLI configuration
│   └── gcloud/             # Google Cloud SDK configs
├── 🛠️ AI & Coding Agents
│   └── agents/             # Pi agent skills and references
├── 🗂️ File & Task Management
│   ├── yazi/               # Terminal file manager with plugins
│   ├── ytctl/              # YouTube controller CLI
│   ├── todoist-cli/        # Todoist task management
│   └── notion/             # Notion workspace config
├── 📊 System Monitoring
│   └── btop/               # System resource monitor theme
├── 🚀 Productivity & Utilities
│   ├── herdr/              # Terminal workspace manager configs
│   ├── raycast/            # Launcher and productivity settings
│   ├── op/                 # 1Password CLI configuration
│   ├── resend/             # Email API CLI
│   ├── openspec/           # OpenSpec configuration
│   ├── qmd/                # QMD tool configuration
│   ├── alchemy/            # Alchemy blockchain CLI config
│   └── main.py             # Homebrew package management script
├── 🔄 Shell Integration
│   └── zprofile            # Homebrew environment setup
└── 📚 Documentation
    └── README.md           # This comprehensive guide
```

## Security Notes

- Sensitive files (API keys, credentials, tokens) are excluded via `.gitignore`
- SSH keys are NOT backed up — regenerate with Yubikey after reset
- Re-authenticate with services after restore
- GPG signing uses Yubikey (`id_ed25519_sk.pub`)
