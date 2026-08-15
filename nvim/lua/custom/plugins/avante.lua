return {
  {
    'yetone/avante.nvim',
    version = false, -- Never set to '*'! avante.nvim under rapid development
    event = 'VeryLazy',
    build = vim.fn.has 'win32' ~= 0 and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false' or 'make',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
      { 'folke/snacks.nvim', optional = true },
      'MeanderingProgrammer/render-markdown.nvim',
    },
    opts = {
      provider = 'opencode', -- Default ACP agent. Switch agent with :AvanteSwitchProvider or set to 'codex'.
      behaviour = {
        auto_suggestions = false, -- ACP agents can't drive suggestions (that path uses API providers only)
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        minimize_diff = true,
        enable_token_counting = true,
        auto_add_current_file = true,
        auto_approve_tool_permissions = true,
        acp_follow_agent_locations = true,
      },
      -- ACP agents (Agent Client Protocol stdio servers).
      -- Both agents advertise models/modes over ACP; pick them in the sidebar
      -- with <leader>aM (model) / <leader>am (mode).
      acp_providers = {
        opencode = {
          command = 'opencode',
          -- NOTE: `opencode acp` has no --model flag (verified on opencode 1.18.11).
          -- An unknown flag makes it print help and exit, killing the ACP session.
          -- Select the model in the sidebar with <leader>aM instead.
          args = { 'acp' },
        },
        codex = {
          -- Official Codex ACP adapter: npm i -g @agentclientprotocol/codex-acp
          -- Reuses `codex login` auth (~/.codex/auth.json); falls back to OPENAI_API_KEY.
          command = 'codex-acp',
          args = {},
          env = {
            NODE_NO_WARNINGS = '1',
            HOME = os.getenv('HOME'),
            PATH = os.getenv('PATH'),
            OPENAI_API_KEY = os.getenv('OPENAI_API_KEY'),
          },
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
        select_acp_model = '<leader>aM', -- Select ACP agent model
        select_acp_mode = '<leader>am', -- Select ACP agent mode (codex: read-only / agent / agent-full-access)
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
    },
    keys = {
      { '<leader>aa', '<cmd>AvanteAsk<CR>', desc = 'Ask avante (ACP agent)' },
      { '<leader>at', '<cmd>AvanteToggle<CR>', desc = 'Toggle avante sidebar' },
      { '<leader>ar', '<cmd>AvanteRefresh<CR>', desc = 'Refresh avante' },
      { '<leader>af', '<cmd>AvanteFocus<CR>', desc = 'Focus avante sidebar' },
      { '<leader>an', '<cmd>AvanteAsk<CR>', desc = 'New ask' },
      { '<leader>ae', '<cmd>AvanteEdit<CR>', desc = 'Edit selected blocks', mode = 'x' },
      { '<leader>ap', '<cmd>AvanteSwitchProvider<CR>', desc = 'Switch avante agent (opencode/codex)' },
    },
  },
}
