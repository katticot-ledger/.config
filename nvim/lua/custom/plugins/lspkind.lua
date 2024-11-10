return {
  {
    'onsails/lspkind-nvim',
    event = 'LspAttach', -- Load when LSP attaches
    config = function()
      local lspkind = require 'lspkind'

      lspkind.init {
        symbol_map = {
          Copilot = '',
        },
      }

      -- Set the highlight color for Copilot completion items
      vim.api.nvim_set_hl(0, 'CmpItemKindCopilot', { fg = '#6CC644' })
    end,
  },
}
