return {
  'epwalsh/obsidian.nvim',
  version = '*',
  lazy = true,
  ft = 'markdown',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    workspaces = {
      {
        name = 'vault',
        path = '/Users/keita/Library/Mobile Documents/iCloud~md~obsidian/Documents/obsidian',
      },
    },
  },
}
