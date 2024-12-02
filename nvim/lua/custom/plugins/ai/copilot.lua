vim.g.copilot_filetypes = { markdown = false }
local copilotLuaConfig = {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  build = ':Copilot auth',
  opts = {
    suggestion = { enabled = false },
    panel = { enabled = false },
    filetypes = {
      markdown = false,
      help = true,
    },
  },
}

-- Configuration for CopilotChat.nvim with dependencies
local copilotChatConfig = {
  'CopilotC-Nvim/CopilotChat.nvim',
  branch = 'canary',
  dependencies = {
    copilotLuaConfig,
    { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
  },
  build = 'make tiktoken', -- Only applicable on MacOS or Linux
  opts = {
    debug = true, -- Enable debugging
    -- Additional configuration options for CopilotChat can go here
  },
  cmd = { 'Copilot', 'CopilotChat' },
}

local copilot_cmp = {
  'zbirenbaum/copilot-cmp',
  config = function()
    require('copilot_cmp').setup()
  end,
}

local Copilot = { 'github/copilot.vim' }

return {
  copilotChatConfig,
  copilot_cmp,
  Copilot,
}
