return {
  'epwalsh/obsidian.nvim',
  version = '*',
  lazy = true,
  ft = 'markdown',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    vim.opt_local.conceallevel = 2
  end,
  opts = {
    workspaces = {
      {
        name = 'work',
        path = '/Users/keita.atticot/Library/CloudStorage/GoogleDrive-keita.atticot@ledger.fr/My Drive/obsidian',
      },
    },
  },
}
