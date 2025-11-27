# Neovim Change Plan (Next Steps Checklist)

Tick `[x]` beside any item you want me to implement, then let me know. I’ll only touch the sections you approve.

Contents
- [x] [1. Indent detection: modernise sleuth](#1-indent-detection-modernise-sleuth)
- [x] [2. Comment toggles: richer motions](#2-comment-toggles-richer-motions)
- [x] [3. Statusline: upgrade the UI](#3-statusline-upgrade-the-ui)
- [x] [4. Git blame: collapse into gitsigns](#4-git-blame-collapse-into-gitsigns)
- [x] [5. Themes & visuals: curated swaps](#5-themes--visuals-curated-swaps)
- [ ] [6. Notifications: noice vs lightweight](#6-notifications-noice-vs-lightweight)
- [ ] [7. Markdown preview: live/rendered views](#7-markdown-preview-liverendered-views)
- [ ] [8. Zettelkasten workflow: obsidian vs telekasten](#8-zettelkasten-workflow-obsidian-vs-telekasten)

---

## 1. Indent detection: modernise sleuth

Current state
- `NMAC427/guess-indent.nvim` (see `init.lua:212`) now handles automatic indentation detection; Sleuth has been removed.

Options
- [x] Option A (implemented): replaced Sleuth with `NMAC427/guess-indent.nvim` for a pure Lua, byte-compiler friendly solution that still exposes a manual autocommand.
- [ ] Option B: revert to Sleuth and accept the Vimscript dependency.

Impact
- Option A already delivers minor speed gains and removes Vimscript dependencies; Option B would undo that.

---

## 2. Comment toggles: richer motions

Current state
- `numToStr/Comment.nvim` (configured in `init.lua:459`) handles comment toggles with Treesitter-aware motions.

Options
- [x] Option A (implemented): swapped to `numToStr/Comment.nvim` for motions like commenting the line above/below, `gcA` append mode, and better Treesitter awareness.
- [ ] Option B: revert to `mini.comment` and its minimal feature set.

Impact
- Option A already improves comment ergonomics with negligible overhead; Option B would shed those ergonomics.

---

## 3. Statusline: upgrade the UI

Current state
- `nvim-lualine/lualine.nvim` (see `lua/custom/plugins/statusline.lua`) drives the statusline, while `mini.statusline` stays disabled.

Options
- [x] Option A (implemented): migrated to `nvim-lualine/lualine.nvim` for richer sections, component ecosystem, and extensions (LSP, diagnostics, Git, breadcrumbs).
- [ ] Option B: revert to `mini.statusline` for maximum simplicity.

Impact
- Option A already delivers a more informative statusline; Option B would reinstate zero-config simplicity.

---

## 4. Git blame: collapse into gitsigns

Current state
- `f-person/git-blame.nvim` has been removed; `<leader>gt` now calls `:Gitsigns toggle_current_line_blame` via `lua/custom/plugins/git.lua:88`.

Options
- [x] Option A (implemented): removed the standalone plugin and rely on `:Gitsigns toggle_current_line_blame`, which already ships with similar inline output.
- [ ] Option B: reintroduce the plugin if you prefer the dedicated namespace/commands.

Impact
- Option A already trims one plugin and keeps blame functionality via Gitsigns; Option B would add the extra dependency back.

---

## 5. Themes & visuals: curated swaps

Current state
- Active palette: `folke/tokyonight.nvim` (moon variant). Additional themes installed: `EdenEast/nightfox.nvim`, `navarasu/onedark.nvim`, and the newly added `catppuccin/nvim` (configured in `init.lua:439`).

Options
- [x] Option A (implemented): introduced `catppuccin/nvim` for cohesive highlights across popular plugins.
- [ ] Option B: add `rebelot/kanagawa.nvim` for warmer contrast and readable markdown.
- [ ] Option C: upgrade `navarasu/onedark.nvim` to `olimorris/onedarkpro.nvim` for more variants while keeping the familiar palette.
- [ ] Option D: keep the current roster; no further action required.

Impact
- Option A already expanded the palette with Catppuccin; additional themes remain a purely aesthetic choice that add Lua config but can co-exist with the current setup.

---

## 6. Notifications: noice vs lightweight

Current state
- `folke/noice.nvim` + `rcarriga/nvim-notify` provide message/command-line enhancements (`lua/custom/plugins/noice.lua`).

Options
- [ ] Option A: keep Noice for advanced cmdline and LSP UI overlays.
- [ ] Option B: remove Noice, keep only `nvim-notify` (or default messages) for lower overhead and simpler visuals.

Impact
- Option A keeps the rich UI; Option B marginally improves responsiveness by trimming a UI layer.

---

## 7. Markdown preview: live/rendered views

Current state
- Markdown rendering handled by `MeanderingProgrammer/render-markdown.nvim` (buffer decorations, no live preview).

Options
- [ ] Option A: add `iamcco/markdown-preview.nvim` (browser live preview) — requires Node.js.
- [ ] Option B: add `ellisonleao/glow.nvim` for terminal previews without external browser.
- [ ] Option C: keep the current in-buffer rendering only.

Impact
- Options A/B add tooling for documentation workflows; Option C keeps the setup lean.

---

## 8. Zettelkasten workflow: obsidian vs telekasten

Current state
- `epwalsh/obsidian.nvim` (see `lua/custom/plugins/obsidian.lua`) targets a single Obsidian vault in iCloud Drive.

Options
- [ ] Option A: stay with `obsidian.nvim` — best choice if you live in the Obsidian app.
- [ ] Option B: experiment with `renerocksai/telekasten.nvim` for an app-agnostic markdown Zettelkasten inside Neovim.
- [ ] Option C: disable the vault integration if it’s no longer in use.

Impact
- Option B shifts workflows out of Obsidian; Option C reduces plugin load.

---

Let me know which boxes to tick, or adjust any proposal before implementation.
