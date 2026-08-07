-- Parsers previously built by the master branch, minus `jsonc` and `tmux`,
-- which the main branch does not ship (see the notes below the list).
local parsers = {
  'astro', 'bash', 'c', 'css', 'csv', 'diff', 'dockerfile', 'fish',
  'git_config', 'git_rebase', 'gitcommit', 'gitignore', 'hjson', 'html',
  'htmldjango', 'javascript', 'json', 'lua', 'luadoc', 'make', 'markdown',
  'markdown_inline', 'python', 'query', 'rust', 'sql', 'ssh_config',
  'svelte', 'toml', 'tsx', 'typescript', 'vim', 'vimdoc', 'xml', 'yaml',
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false, -- upstream: "This plugin does not support lazy-loading."
    build = ':TSUpdate',
    config = function()
      -- install_dir must be passed explicitly: it is the only path through which
      -- nvim-treesitter prepends the directory to 'runtimepath'.
      require('nvim-treesitter').setup {
        install_dir = vim.fs.joinpath(vim.fn.stdpath 'data', 'site'),
      }
      require('nvim-treesitter').install(parsers)

      -- jsonc has no parser on main; reuse the json parser for it.
      vim.treesitter.language.register('json', 'jsonc')

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('user-treesitter', { clear = true }),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          -- language.add() returns false/nil instead of throwing when the parser
          -- is missing; vim.treesitter.start() asserts, so guard first.
          if not lang or not vim.treesitter.language.add(lang) then
            return
          end
          vim.treesitter.start(ev.buf, lang)
          if vim.treesitter.query.get(lang, 'indents') then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    lazy = false,
    init = function()
      -- Required by upstream: the textobject keymaps below are global, and
      -- built-in ftplugins (python, vim, ...) would otherwise re-map ]m / [m
      -- buffer-locally after startup and win.
      vim.g.no_plugin_maps = true
    end,
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = { lookahead = true },
        move = { set_jumps = true },
      }

      local select = require 'nvim-treesitter-textobjects.select'
      local move = require 'nvim-treesitter-textobjects.move'
      local swap = require 'nvim-treesitter-textobjects.swap'

      for lhs, capture in pairs {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      } do
        vim.keymap.set({ 'x', 'o' }, lhs, function()
          select.select_textobject(capture, 'textobjects')
        end, { desc = 'Select ' .. capture })
      end

      for lhs, spec in pairs {
        [']m'] = { move.goto_next_start, '@function.outer' },
        [']]'] = { move.goto_next_start, '@class.outer' },
        [']M'] = { move.goto_next_end, '@function.outer' },
        [']['] = { move.goto_next_end, '@class.outer' },
        ['[m'] = { move.goto_previous_start, '@function.outer' },
        ['[['] = { move.goto_previous_start, '@class.outer' },
        ['[M'] = { move.goto_previous_end, '@function.outer' },
        ['[]'] = { move.goto_previous_end, '@class.outer' },
      } do
        local fn, capture = spec[1], spec[2]
        vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
          fn(capture, 'textobjects')
        end, { desc = 'Move to ' .. capture })
      end

      vim.keymap.set('n', '<leader>a', function()
        swap.swap_next '@parameter.inner'
      end, { desc = 'Swap next parameter' })
      vim.keymap.set('n', '<leader>A', function()
        swap.swap_previous '@parameter.inner'
      end, { desc = 'Swap previous parameter' })
    end,
  },
}
