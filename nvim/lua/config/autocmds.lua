-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

---- Run nvm use 18 when opening a new terminal
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup("nvm"),
  callback = function()
    vim.api.nvim_exec("silent !nvm use 18", false)
  end,
})

-- Set conceal level to 2 globally
vim.o.conceallevel = 2
