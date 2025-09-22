# Applied Neovim Config Changes

- **File Explorer**: Swapped to `oil.nvim` as the default explorer, mapped `<leader>e` to `:Oil`, and removed the `mini.files` plugin/configuration entirely.
- **Gitsigns**: Removed the Kickstart gitsigns import via the consolidated plugin import and kept the custom `git.lua`, adding Snacks `gitbrowse` to preserve `<leader>gb`.
- **LSP**: Removed the redundant `nvim-lspconfig` spec from `autocompletion.lua` and funneled blink.cmp capabilities through the primary LSP setup in `ide.lua`.
- **Autopairs**: Dropped the unused `nvim-cmp` dependency/integration so autopairs runs standalone.
- **Cursor Restore**: Replaced the last-position autocmd with the safer `nvim_buf_get_mark` check before jumping back.
- **Obsidian**: Moved the `conceallevel = 2` setting into `ftplugin/markdown.lua` so every Markdown buffer inherits it.
- **Flash.nvim**: Remapped the primary jump key to `S` to keep the default `s` behavior intact.
- **Lazy Imports**: Collapsed individual `custom.plugins.*` imports into a single `{ import = 'custom.plugins' }` entry in `init.lua`.
- **Autoformat**: Guarded Treesitter detection, fixed the `<leader>f` mapping mode, and corrected the boolean fallback flag for Conform.
- **Completion Icons**: Initialised `mini.icons` via the `mini.nvim` config and wrapped Blink’s menu renderers with safe fallbacks.
- **Git Blame**: Removed the standalone plugin and mapped `<leader>gt` to `Gitsigns toggle_current_line_blame` for inline blame on demand.
- **Indent Detection**: Adopted `guess-indent.nvim` for faster, Lua-native indentation heuristics.
- **Commenting**: Swapped `mini.comment` for `Comment.nvim` to unlock richer motions and Treesitter-aware toggles.
- **Statusline**: Introduced `lualine.nvim` with LSP, diagnostics, and Git components while keeping `mini.nvim` for textobjects/surround.
- **Themes**: Added `catppuccin/nvim` to the palette alongside Tokyo Night, Nightfox, and OneDark.

These notes capture the code edits made from `NEOVIM_CHANGE_PLAN.md`.

## Review Snapshot

- Completed: Plan item 1 — `guess-indent.nvim` now provides Lua-native indentation detection.
- Completed: Plan item 2 — `Comment.nvim` replaces `mini.comment` for advanced motions.
- Completed: Plan item 3 — `lualine.nvim` handles the statusline while `mini.statusline` stays disabled.
- Completed: Plan item 4 — Gitsigns owns inline blame via `<leader>gt`; `git-blame.nvim` is gone.
- Completed: Plan item 5 — `catppuccin/nvim` joined the theme roster.
- Pending: Plan item 6 — Run `:Lazy sync`/`:Lazy update` when you are ready to refresh `lazy-lock.json`.
