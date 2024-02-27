-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
map("n", "<leader><tab>r", "<cmd>ObsidianQuickSwitch<cr>", { desc = "ObsidianQuickSwitch" })
map("n", "<leader><tab>t", "<cmd>ObsidianToday<cr>", { desc = "ObsidianToday" })
map("n", "<leader><tab>n", "<cmd>ObsidianNew<cr>", { desc = "ObsidianNew" })
map("n", "<leader><tab>h", "<cmd>put =strftime('%c')<CR>", { desc = "Insert current date and time" })
