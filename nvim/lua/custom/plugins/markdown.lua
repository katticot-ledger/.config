local markdown_filetypes = { 'markdown', 'Avante' }

return {
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.marksman = {}
      opts.servers.markdown_oxide = {}
      opts.servers.harper_ls = {
        filetypes = { 'markdown' },
        settings = {
          ['harper-ls'] = {
            dialect = 'American',
            diagnosticSeverity = 'hint',
          },
        },
      }
      opts.servers.ltex_plus = {
        filetypes = { 'markdown' },
        settings = {
          ltex = {
            language = 'en-US',
          },
        },
      }
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'echasnovski/mini.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    ft = markdown_filetypes,
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      file_types = markdown_filetypes,
      render_modes = { 'n', 'c', 't' },
      max_file_size = 10.0,
      anti_conceal = {
        enabled = true,
      },
      heading = {
        enabled = true,
        sign = true,
        position = 'overlay',
        icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
        signs = { '󰫎 ' },
        width = 'full',
        left_margin = 0,
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = false,
        border_virtual = false,
        border_prefix = false,
        above = '▄',
        below = '▀',
        backgrounds = {
          'RenderMarkdownH1Bg',
          'RenderMarkdownH2Bg',
          'RenderMarkdownH3Bg',
          'RenderMarkdownH4Bg',
          'RenderMarkdownH5Bg',
          'RenderMarkdownH6Bg',
        },
        foregrounds = {
          'RenderMarkdownH1',
          'RenderMarkdownH2',
          'RenderMarkdownH3',
          'RenderMarkdownH4',
          'RenderMarkdownH5',
          'RenderMarkdownH6',
        },
      },
    },
  },
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint-cli2' },
      }

      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost' }, {
        group = vim.api.nvim_create_augroup('markdown-lint', { clear = true }),
        pattern = { '*.md', '*.mdx' },
        callback = function()
          if vim.bo.modifiable then
            lint.try_lint 'markdownlint-cli2'
          end
        end,
      })
    end,
  },
}
