# Neovim Change Plan (Next Steps Checklist)

Tick `[x]` beside any item you want me to implement, then let me know. I’ll only touch the sections you approve.

Contents
- [1. Indent detection: modernise sleuth](#1-indent-detection-modernise-sleuth)
- [2. Comment toggles: richer motions](#2-comment-toggles-richer-motions)
- [3. Statusline: upgrade the UI](#3-statusline-upgrade-the-ui)
- [4. Git blame: collapse into gitsigns](#4-git-blame-collapse-into-gitsigns)
- [5. Themes & visuals: curated swaps](#5-themes--visuals-curated-swaps)
- [6. Notifications: noice vs lightweight](#6-notifications-noice-vs-lightweight)
- [7. Markdown preview: live/rendered views](#7-markdown-preview-liverendered-views)
- [8. Zettelkasten workflow: obsidian vs telekasten](#8-zettelkasten-workflow-obsidian-vs-telekasten)

---

## 1. Indent detection: modernise sleuth

Current state
- `tpope/vim-sleuth` lives in `init.lua:214` for automatic indentation detection.

Options
- [ ] Option A (recommended): replace Sleuth with `NMAC427/guess-indent.nvim` — pure Lua, byte-compiler friendly, and exposes an autocommand you can call manually.
- [ ] Option B: keep Sleuth, accept the Vimscript dependency.

Impact
- Minor speed gains and zero Vimscript dependencies if we adopt Option A.

---

## 2. Comment toggles: richer motions

Current state
- `echasnovski/mini.comment` is configured in `init.lua:440`.

Options
- [ ] Option A (recommended): swap to `numToStr/Comment.nvim` for motions like commenting the line above/below, `gcA` append mode, and better treesitter awareness.
- [ ] Option B: keep `mini.comment` and its minimal feature set.

Impact
- Option A improves comment ergonomics with negligible overhead.

---

## 3. Statusline: upgrade the UI

Current state
- `mini.statusline` (configured around `init.lua:460`) handles the statusline.

Options
- [ ] Option A (recommended): migrate to `nvim-lualine/lualine.nvim` for richer sections, component ecosystem, and extensions (LSP, diagnostics, Git, breadcrumbs).
- [ ] Option B: keep `mini.statusline` for maximum simplicity.

Impact
- Option A gives a more informative statusline; Option B keeps zero-config simplicity.

---

## 4. Git blame: collapse into gitsigns

Current state
- `f-person/git-blame.nvim` is defined in `lua/custom/plugins/git.lua:191` solely for virtual text blame.

Options
- [ ] Option A (recommended): remove the plugin and rely on `:Gitsigns toggle_current_line_blame`, which already ships with similar inline output.
- [ ] Option B: keep both if you prefer the dedicated namespace/commands.

Impact
- Option A trims one plugin and keeps blame functionality via Gitsigns.

---

## 5. Themes & visuals: curated swaps

Current state
- Active palette: `folke/tokyonight.nvim` (moon variant). Additional themes installed: `EdenEast/nightfox.nvim`, `navarasu/onedark.nvim`.

Options
- [ ] Option A: introduce `catppuccin/nvim` for cohesive highlights across popular plugins.
- [ ] Option B: introduce `rebelot/kanagawa.nvim` for warmer contrast and readable markdown.
- [ ] Option C: upgrade `navarasu/onedark.nvim` to `olimorris/onedarkpro.nvim` for more variants while keeping the familiar palette.
- [ ] Option D: keep the current trio; no action required.

Impact
- Purely aesthetic: any new theme adds Lua config but can co-exist with the current setup.

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
