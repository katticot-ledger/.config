-- Git plugins for merge conflict resolution and Git workflow
return {
  -- Fugitive - The gold standard for Git in Vim
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'Gdiffsplit', 'Gread', 'Gwrite', 'Ggrep', 'GMove', 'GDelete', 'GBrowse' },
    keys = {
      { '<leader>gs', ':Git<CR>', desc = 'Git status' },
      { '<leader>gd', ':Gdiffsplit<CR>', desc = 'Git diff split' },
      { '<leader>gc', ':Git commit<CR>', desc = 'Git commit' },
      { '<leader>gp', ':Git push<CR>', desc = 'Git push' },
      { '<leader>gl', ':Git pull<CR>', desc = 'Git pull' },
      -- Merge conflict resolution
      { '<leader>gm', ':Gvdiffsplit!<CR>', desc = 'Git merge conflict (3-way)' },
      { '<leader>gh', ':diffget //2<CR>', desc = 'Get from HEAD (left)' },
      { '<leader>gr', ':diffget //3<CR>', desc = 'Get from merge branch (right)' },
    },
  },

  -- Enhanced GitSigns (replaces the kickstart one with more features)
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '│' },
        change = { text = '│' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      current_line_blame = false, -- Toggle with <leader>tb
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 300,
      },
      preview_config = {
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
      },
    },
    keys = {
      -- Navigation
      {
        ']c',
        function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            require('gitsigns').next_hunk()
          end)
          return '<Ignore>'
        end,
        expr = true,
        desc = 'Next git hunk',
      },
      {
        '[c',
        function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            require('gitsigns').prev_hunk()
          end)
          return '<Ignore>'
        end,
        expr = true,
        desc = 'Previous git hunk',
      },
      -- Actions
      { '<leader>hs', ':Gitsigns stage_hunk<CR>', desc = 'Stage hunk' },
      { '<leader>hr', ':Gitsigns reset_hunk<CR>', desc = 'Reset hunk' },
      { '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>', desc = 'Stage buffer' },
      { '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>', desc = 'Undo stage hunk' },
      { '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>', desc = 'Reset buffer' },
      { '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>', desc = 'Preview hunk' },
      { '<leader>hb', '<cmd>Gitsigns blame_line<CR>', desc = 'Blame line' },
      { '<leader>hd', '<cmd>Gitsigns diffthis<CR>', desc = 'Diff this' },
      { '<leader>hD', '<cmd>Gitsigns diffthis ~<CR>', desc = 'Diff this ~' },
      -- Toggles
      { '<leader>gt', '<cmd>Gitsigns toggle_current_line_blame<CR>', desc = 'Toggle Git Blame' },
      { '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>', desc = 'Toggle line blame' },
      { '<leader>td', '<cmd>Gitsigns toggle_deleted<CR>', desc = 'Toggle deleted' },
    },
  },

  {
    'folke/snacks.nvim',
    opts = { gitbrowse = {} },
    keys = {
      { '<leader>gb', function() require('snacks').gitbrowse.open() end, desc = 'Open gitbrowse' },
    },
  },

  -- DiffView - Beautiful diff and merge conflict UI
  {
    'sindrets/diffview.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewFileHistory' },
    keys = {
      { '<leader>do', '<cmd>DiffviewOpen<CR>', desc = 'Open DiffView' },
      { '<leader>dc', '<cmd>DiffviewClose<CR>', desc = 'Close DiffView' },
      { '<leader>dh', '<cmd>DiffviewFileHistory<CR>', desc = 'File history' },
      { '<leader>df', '<cmd>DiffviewToggleFiles<CR>', desc = 'Toggle files panel' },
    },
    config = function()
      require('diffview').setup {
        diff_binaries = false,
        enhanced_diff_hl = false,
        git_cmd = { 'git' },
        use_icons = vim.g.have_nerd_font,
        watch_index = true,
        icons = {
          folder_closed = vim.g.have_nerd_font and '' or '[D]',
          folder_open = vim.g.have_nerd_font and '' or '[O]',
        },
        signs = {
          fold_closed = vim.g.have_nerd_font and '' or '+',
          fold_open = vim.g.have_nerd_font and '' or '-',
          done = vim.g.have_nerd_font and '✓' or 'D',
        },
        view = {
          default = {
            layout = 'diff2_horizontal',
            winbar_info = false,
          },
          merge_tool = {
            layout = 'diff3_horizontal',
            disable_diagnostics = true,
            winbar_info = true,
          },
          file_history = {
            layout = 'diff2_horizontal',
            winbar_info = false,
          },
        },
        file_panel = {
          listing_style = 'tree',
          tree_options = {
            flatten_dirs = true,
            folder_statuses = 'only_folded',
          },
          win_config = {
            position = 'left',
            width = 35,
          },
        },
        file_history_panel = {
          log_options = {
            git = {
              single_file = {
                diff_merges = 'combined',
              },
              multi_file = {
                diff_merges = 'first-parent',
              },
            },
          },
          win_config = {
            position = 'bottom',
            height = 16,
          },
        },
      }
    end,
  },

  -- Git Conflict - Specialized conflict resolution
  {
    'akinsho/git-conflict.nvim',
    event = 'BufReadPre',
    keys = {
      { '<leader>gco', '<Plug>(git-conflict-ours)', desc = 'Conflict: choose ours' },
      { '<leader>gct', '<Plug>(git-conflict-theirs)', desc = 'Conflict: choose theirs' },
      { '<leader>gcb', '<Plug>(git-conflict-both)', desc = 'Conflict: choose both' },
      { '<leader>gc0', '<Plug>(git-conflict-none)', desc = 'Conflict: choose none' },
      { ']x', '<Plug>(git-conflict-next-conflict)', desc = 'Next conflict' },
      { '[x', '<Plug>(git-conflict-prev-conflict)', desc = 'Previous conflict' },
    },
    opts = {
      default_mappings = false, -- We define our own above
      default_commands = true,
      disable_diagnostics = false,
      list_opener = 'copen',
      highlights = {
        incoming = 'DiffAdd',
        current = 'DiffText',
        ancestor = 'DiffChange',
      },
    },
  },

}
