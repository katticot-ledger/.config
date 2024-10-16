-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3"]])
vim.cmd([[let &t_Ce = "\e[4:0"]])
vim.opt_local.conceallevel = 2
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.b.copilot_enabled = 0
  end,
})
