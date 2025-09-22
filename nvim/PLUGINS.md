# Neovim Plugins

This document lists all the plugins currently installed in your Neovim configuration.

## Core Plugins (from init.lua)

### Essential Tools
- **NMAC427/guess-indent.nvim** - Automatically detect indentation settings
- **L3MON4D3/LuaSnip** - Snippet engine for Neovim

### Key Management
- **folke/which-key.nvim** - Show pending keybinds and key mappings

### Fuzzy Finding & Search
- **nvim-telescope/telescope.nvim** - Fuzzy finder for files, LSP, etc.
  - **nvim-lua/plenary.nvim** - Required dependency
  - **nvim-telescope/telescope-fzf-native.nvim** - FZF native sorting
  - **nvim-telescope/telescope-ui-select.nvim** - UI select replacement

### LSP & Development
- **folke/lazydev.nvim** - Lua LSP configuration for Neovim development
- **Bilal2453/luvit-meta** - Meta files for luvit library

### Color Schemes
- **folke/tokyonight.nvim** - Tokyo Night color scheme (active: tokyonight-moon)
- **EdenEast/nightfox.nvim** - Nightfox color scheme family
- **navarasu/onedark.nvim** - One Dark color scheme
- **catppuccin/nvim** - Catppuccin theme collection

### Code Enhancement
- **folke/todo-comments.nvim** - Highlight and search TODO comments
- **numToStr/Comment.nvim** - Comment toggles with rich motions
- **echasnovski/mini.nvim** - Collection of mini plugins
  - **mini.ai** - Better text objects
  - **mini.surround** - Add/delete/replace surroundings

### UI & Statusline
- **nvim-lualine/lualine.nvim** - Feature-rich statusline with LSP and Git integration

### Kickstart Plugins (enabled)
- **kickstart.plugins.indent_line** - Indentation guides
- **kickstart.plugins.autopairs** - Auto-closing brackets and quotes

## Custom Plugins (lua/custom/plugins/)

### File Management
- **stevearc/oil.nvim** - File explorer (replaces netrw)

### Git Integration
- **tpope/vim-fugitive** - Comprehensive Git wrapper
- **lewis6991/gitsigns.nvim** - Git signs and hunks in gutter
- **sindrets/diffview.nvim** - Beautiful diff and merge conflict UI
- **akinsho/git-conflict.nvim** - Specialized merge conflict resolution

### Additional Custom Plugins
- **alpha.lua** - Dashboard/start screen
- **autocompletion.lua** - Completion configuration
- **flash.lua** - Quick navigation
- **ide.lua** - IDE-like features
- **lazygit.lua** - LazyGit integration
- **markdown.lua** - Markdown enhancements
- **noice.lua** - Better UI for messages/cmdline
- **obsidian.lua** - Obsidian vault integration
- **oil.lua** - File operations
- **autoformat.lua** - Automatic code formatting

## Kickstart Plugins (available but not enabled)
- **kickstart.plugins.debug** - Debug adapter protocol
- **kickstart.plugins.lint** - Linting configuration
- **kickstart.plugins.neo-tree** - File explorer alternative
- **kickstart.plugins.gitsigns** - Git integration (replaced by custom version)

## Plugin Manager
- **folke/lazy.nvim** - Modern plugin manager for Neovim

---

*Total plugins: dozens with their various dependencies and sub-modules*
