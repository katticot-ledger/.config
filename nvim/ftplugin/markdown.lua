vim.opt_local.conceallevel = 2

local function open_leaf()
  local file = vim.fn.expand '%:p'
  if file == '' then
    vim.notify('No file associated with current buffer', vim.log.levels.WARN)
    return
  end

  -- Ensure the file exists on disk for Leaf to read
  if vim.bo.modified or vim.fn.filereadable(file) == 0 then
    local ok, err = pcall(vim.cmd, 'write')
    if not ok then
      vim.notify('Save the file before opening Leaf: ' .. tostring(err), vim.log.levels.ERROR)
      return
    end
  end

  if vim.env.TMUX then
    vim.fn.jobstart({ 'tmux', 'split-window', '-h', 'leaf', '-w', file }, { detach = true })
  elseif vim.fn.has 'mac' == 1 and vim.fn.isdirectory '/Applications/Ghostty.app' == 1 then
    vim.fn.jobstart({ 'open', '-na', 'Ghostty.app', '--args', '-e', 'leaf', '-w', file }, { detach = true })
  else
    vim.cmd('vsplit | term leaf -w ' .. vim.fn.fnameescape(file))
  end
end

vim.api.nvim_buf_create_user_command(0, 'Leaf', open_leaf, { desc = 'Open current Markdown file in Leaf watch mode' })
vim.keymap.set('n', '<leader>ml', open_leaf, { buffer = true, desc = '[M]arkdown [L]eaf Preview' })

