local conf = {
  -- Customize shown content
  content = {
    filter = nil, -- Predicate for which file system entries to show
    prefix = nil, -- Prefix to show to the left of file system entry
    sort = nil, -- Custom sorting for file system entries
  },

  -- Key mappings for the MiniFiles explorer
  mappings = {
    close = 'q', -- Close the explorer
    go_in = '<Right>', -- Enter a directory
    go_out = '<Left>', -- Exit a directory
    mark_goto = "'", -- Go to a marked file
    mark_set = 'm', -- Set a mark
    reset = '<BS>', -- Reset the view
    reveal_cwd = '@', -- Reveal the current working directory
    show_help = 'g?', -- Show help for key mappings
    synchronize = '=', -- Synchronize files
    trim_left = '<', -- Trim the left side
    trim_right = '>', -- Trim the right side
  },

  -- General options
  options = {
    permanent_delete = false, -- Move to trash instead of permanent delete
    use_as_default_explorer = true, -- Set MiniFiles as the default file explorer
  },

  -- Explorer window settings
  windows = {
    max_number = math.huge, -- Maximum number of side-by-side windows
    preview = false, -- Disable preview for files/directories
    width_focus = 50, -- Width of the focused window
    width_nofocus = 15, -- Width of non-focused windows
    width_preview = 25, -- Width of the preview window
  },
}

-- Plugin Configuration
return {
  'echasnovski/mini.nvim',
  version = '*', -- Use the latest version of MiniFiles

  config = function()
    -- Set up MiniFiles with the defined configuration
    require('mini.files').setup(conf)

    -- Key mappings for MiniFiles functionality
    vim.keymap.set('n', '<leader>e', '<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>', {
      desc = 'Open Mini.files',
      noremap = true,
      silent = true,
    })

    vim.keymap.set('n', '<CR>', function()
      require('mini.files').synchronize()
      require('mini.files').go_in()
    end, {
      desc = 'Enter directory and auto-save',
      noremap = true,
      silent = true,
    })
  end,
}
