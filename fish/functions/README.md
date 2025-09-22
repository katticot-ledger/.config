# Fish Functions Documentation

This directory contains custom Fish shell functions for enhanced command-line productivity and workflow automation.

## File Management & Navigation

### `fconf.fish` - Fuzzy Config Editor
Blazing-fast fuzzy finder for configuration files using `fd`, `fzf`, and `bat`.
- **Usage**: `fconf [base_dir] [query]`
- **Features**: Fast file search, syntax highlighting preview, multi-select support
- **Dependencies**: `fd`, `fzf`, `bat`

### `fdir.fish` - Fuzzy Directory File Selector
Quick file selection and editing with Neovim using fuzzy search.
- **Usage**: `fdir`
- **Features**: File preview with syntax highlighting, opens in Neovim
- **Dependencies**: `fd`, `fzf-tmux`, `bat`, `nvim`

### `fobs.fish` - Obsidian File Selector
Navigate and edit Obsidian notes using fuzzy search.
- **Usage**: `fobs`
- **Features**: Preview with line numbers, opens in Neovim
- **Dependencies**: `fd`, `fzf`, `bat`, `nvim`

### `ll.fish` - Enhanced List
Modern `ls` replacement with icons and improved formatting.
- **Usage**: `ll [directory]`
- **Features**: Icons, file sizes, headers, hidden files, color coding
- **Dependencies**: `eza`

## Search & Text Processing

### `ff.fish` - Fuzzy File Search (Live)
Interactive fuzzy search with live ripgrep integration and file opening.
- **Usage**: `ff [initial_query]`
- **Features**: Live search, syntax highlighting, opens in Neovim at line
- **Dependencies**: `rg`, `fzf`, `bat`, `nvim`

### `fvim.fish` - Fuzzy Vim Search
Similar to `ff` but with smaller tmux window size.
- **Usage**: `fvim [initial_query]`
- **Features**: Compact interface, live search, opens in Neovim
- **Dependencies**: `rg`, `fzf`, `bat`, `nvim`

### `fzfrip.fish` - FZF + Ripgrep
Search with ripgrep and navigate results with fzf.
- **Usage**: `fzfrip <search_term>`
- **Features**: Static search results, file preview, opens in Neovim
- **Dependencies**: `rg`, `fzf`, `bat`, `nvim`

### `rgf.fish` - Ripgrep with FZF
Search for text and open matching files in editor.
- **Usage**: `rgf <search_term>`
- **Features**: Column/line number display, opens in Neovim
- **Dependencies**: `rg`, `fzf-tmux`, `bat`, `nvim`

### `nvims.fish` - Neovim File Selector
Select and open files in Neovim using fzf.
- **Usage**: `nvims`
- **Features**: File preview, opens in Neovim
- **Dependencies**: `fzf-tmux`, `bat`, `nvim`

## Git Utilities

### `gc.fish` - Git Clone Alias
Simple wrapper for `git clone`.
- **Usage**: `gc <repository_url>`

### `gp.fish` - Git Pull Alias
Simple wrapper for `git pull`.
- **Usage**: `gp`

### `git_commit_browser.fish` - Interactive Commit Browser
Browse git commits with preview and actions.
- **Usage**: `git_commit_browser`
- **Features**: Commit details, tag information, opens in browser
- **Dependencies**: `fzf-tmux`, `bat`, `git`

### `last_tag_diff.fish` - Tag Diff Utility
Show commits since last tag and extract VG patterns.
- **Usage**: `last_tag_diff`
- **Features**: Fetches tags, shows diff, copies VG patterns to clipboard
- **Dependencies**: `git`, `pbcopy`

### `open_commit.fish` - Commit URL Opener
Select git tags and commits to open in browser.
- **Usage**: `open_commit`
- **Features**: Tag selection, commit browsing, opens in Arc browser
- **Dependencies**: `git`, `fzf`, Arc browser

## Security & Authentication

### `anthropic.fish` - Anthropic API Key Manager
Manage Anthropic API environment variables using 1Password.
- **Usage**: `anthropic set|unset`
- **Features**: Secure key retrieval from 1Password
- **Dependencies**: `op` (1Password CLI)

### `fzfop.fish` - 1Password FZF Selector
Browse and select 1Password items with fuzzy search.
- **Usage**: `fzfop`
- **Features**: Item selection, copies ID to clipboard
- **Dependencies**: `op`, `fzf`, `jq`, `pbcopy`

### `opai.fish` - OpenAI API Key Setter
Set OpenAI API key from 1Password.
- **Usage**: `opai`
- **Dependencies**: `op` (1Password CLI)

## AI & Machine Learning

### `ai.fish` - Ollama Interactive Interface
Interactive interface for Ollama local AI models with enhanced fuzzy model selection.
- **Usage**: 
  - `ai` - Use default model or show interactive selector
  - `ai -s|--select` - Force model selection via fzf
  - `ai --select "your prompt"` - Select model then run prompt
  - `ai set-model <name>` - Set default model
  - `ai <prompt>` - Run prompt with default model
- **Features**: 
  - Enhanced fzf interface with model details preview
  - TAB key to set selected model as default
  - Keyboard shortcuts (ESC: cancel, ENTER: select, TAB: set default)
  - Model information preview showing first 20 lines of `ollama show`
  - Preserves existing functionality while adding new selection options
- **Dependencies**: `ollama`, `fzf` (required for model selection)

## Development Tools

### `bass.fish` - Bash to Fish Translator
Execute bash commands and translate environment changes to Fish.
- **Usage**: `bass [-d] <bash-command>`
- **Features**: Debug mode available
- **Dependencies**: `python3` or `python`

### `br.fish` - Broot Integration
Directory navigation with broot integration.
- **Usage**: `br [arguments]`
- **Features**: Command execution after navigation
- **Dependencies**: `broot`

### `fisher.fish` - Fish Plugin Manager
Comprehensive plugin management for Fish shell (version 4.4.3).
- **Usage**: `fisher install|remove|update|list [plugins]`
- **Features**: Plugin installation, updates, removal
- **Dependencies**: `curl`, `tar`

### `nvm.fish` - Node Version Manager
Node.js version management integration.
- **Usage**: `nvm [arguments]`
- **Features**: Node version switching
- **Dependencies**: `bass`, `nvm` (installed via Homebrew)

### `tmux.fish` - Tmux Configuration Wrapper
Start tmux with custom configuration.
- **Usage**: `tmux [arguments]`
- **Features**: Uses custom config file
- **Dependencies**: `tmux`

## Work-Specific Tools

### `connect_aws.fish` - AWS Environment Setup
Renew AWS credentials and configure kubectl.
- **Usage**: `connect_aws [environment]`
- **Default**: `sbx` environment
- **Features**: Python script execution, kubectl context switching
- **Dependencies**: `python3`, `kubectx`, `kubectl`

### `jir.fish` - Jira Issue Browser
Browse and interact with Jira issues using fzf.
- **Usage**: `jir`
- **Features**: Issue viewing, status updates, browser opening
- **Dependencies**: `jira` CLI, `fzf-tmux`

### `frontproxy.fish` - Ledger Front Proxy
Start Ledger vault proxy for development.
- **Usage**: `ledger-front-deploy`
- **Dependencies**: `ledger-vault`

### `lbake.fish` - Ledger Deploy and Bake
Deploy and bake Ledger vault instances sequentially.
- **Usage**: `ldeploy-bake`
- **Features**: Background deployment, automatic baking
- **Dependencies**: `ledger-vault`

### `ldeploy.fish` - Ledger Deployment Manager
Comprehensive Ledger vault deployment and management.
- **Usage**: `ldeploy [name] [useTelepresence] [salt]`
- **Features**: Deployment, baking, proxy setup, telepresence integration
- **Dependencies**: `nvm`, `ledger-vault`, `telepresence` (optional)

## FZF Integration Functions
Several utility functions support fzf integration (prefixed with `_fzf_`):
- `_fzf_configure_bindings_help.fish`
- `_fzf_extract_var_info.fish`
- `_fzf_preview_changed_file.fish`
- `_fzf_preview_file.fish`
- `_fzf_report_diff_type.fish`
- `_fzf_report_file_type.fish`
- `_fzf_search_directory.fish`
- `_fzf_search_git_log.fish`
- `_fzf_search_git_status.fish`
- `_fzf_search_history.fish`
- `_fzf_search_processes.fish`
- `_fzf_search_variables.fish`
- `_fzf_wrapper.fish`
- `fzf_configure_bindings.fish`

## Prerequisites

Most functions require one or more of these tools:
- `fzf` - Command-line fuzzy finder
- `fd` - Fast file finder
- `rg` (ripgrep) - Fast text search
- `bat` - Syntax highlighting for file preview
- `nvim` - Neovim text editor
- `eza` - Modern ls replacement
- `op` - 1Password CLI
- `git` - Version control
- `jq` - JSON processor

Install common dependencies on macOS:
```bash
brew install fzf fd ripgrep bat neovim eza
```