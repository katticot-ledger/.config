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

      -- :Leaf command to open current Markdown buffer in live watch mode
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

      vim.api.nvim_create_user_command('Leaf', open_leaf, { desc = 'Open current Markdown file in Leaf watch mode' })
      vim.keymap.set('n', '<leader>ml', open_leaf, { desc = '[M]arkdown [L]eaf Preview' })
    end,
  },
}
