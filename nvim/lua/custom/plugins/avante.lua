return {
  {
    'yetone/avante.nvim',
    version = false, -- Never set to '*'! avante.nvim under rapid development
    event = 'VeryLazy',
    build = vim.fn.has('win32') ~= 0
        and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false'
        or 'make',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
      { 'folke/snacks.nvim', optional = true },
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
    opts = {
      provider = 'opencode',
      auto_suggestions_provider = 'opencode',
      behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        minimize_diff = true,
        enable_token_counting = true,
        auto_add_current_file = true,
        auto_approve_tool_permissions = true,
        acp_follow_agent_locations = true,
      },
      -- ACP: use opencode as the agent with DeepSeek V4 Flash Free
      acp_providers = {
        opencode = {
          command = 'opencode',
          args = { 'acp', '--model', 'opencode/deepseek-v4-flash-free' },
        },
      },
      windows = {
        position = 'right',
        wrap = true,
        width = 40,
        sidebar_header = {
          enabled = true,
          align = 'center',
          rounded = true,
        },
        input = {
          prefix = '> ',
          height = 8,
        },
      },
      mappings = {
        submit = {
          normal = '<CR>',
          insert = '<C-s>',
        },
        sidebar = {
          apply_all = 'A',
          apply_cursor = 'a',
          retry_user_request = 'r',
          edit_user_request = 'e',
          switch_windows = '<Tab>',
          remove_file = 'd',
          add_file = '@',
          close = 'q',
        },
      },
      highlights = {
        diff = {
          current = 'DiffText',
          incoming = 'DiffAdd',
        },
      },
      diff = {
        autojump = true,
        override_timeoutlen = 500,
      },
      hints = { enabled = true },
    },
    keys = {
      { '<leader>aa', '<cmd>AvanteAsk<CR>', desc = 'Ask avante (OpenCode ACP)' },
      { '<leader>at', '<cmd>AvanteToggle<CR>', desc = 'Toggle avante sidebar' },
      { '<leader>ar', '<cmd>AvanteRefresh<CR>', desc = 'Refresh avante' },
      { '<leader>af', '<cmd>AvanteFocus<CR>', desc = 'Focus avante sidebar' },
      { '<leader>an', '<cmd>AvanteAsk<CR>', desc = 'New ask' },
      { '<leader>ae', '<cmd>AvanteEdit<CR>', desc = 'Edit selected blocks', mode = 'x' },
    },
  },
}
