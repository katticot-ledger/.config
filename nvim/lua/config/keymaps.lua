-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
map("n", "<leader><tab>h", "<cmd>put =strftime('%c')<CR>", { desc = "Insert current date and time" })
-- Buffer navigation with Shift-Tab (Maj-Tab) and Tab
map("n", "<S-Tab>", ":bprev<CR>", { desc = "Previous buffer", noremap = true, silent = true })
map("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer", noremap = true, silent = true })
