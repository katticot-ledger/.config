local blink_cmp_opts = {
  -- Keymap presets: 'super-tab' for vscode-like, 'enter' for using Enter to accept
  keymap = { preset = 'enter' },

  -- Highlighting configuration
  highlight = {
    use_nvim_cmp_as_default = true, -- Use nvim-cmp highlight groups as defaults
  },
  windows = {
    autocomplete = {
      -- Width of the autocomplete window
      width = 60,
      -- Height of the autocomplete window
      height = 15,
      border = 'rounded', -- Border style of the autocomplete window
    },
  },

  -- Font variant: 'mono' for Nerd Font Mono or 'normal' for Nerd Font
  nerd_font_variant = 'mono',
  -- Experimental signature help support
  trigger = { signature_help = { enabled = true } },
}

-- Blink LSP configuration
local lspconfig_config = function(_, opts)
  local lspconfig = require 'lspconfig'

  -- Iterate over servers and set up their configurations
  for server, config in pairs(opts.servers or {}) do
    config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
    lspconfig[server].setup(config)
  end
end

-- CMP command-line configuration
local cmp_cmdline_config = function()
  local cmp = require 'cmp'

  -- Setup for `/` command-line completion
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }, -- Search within the current buffer
    },
  })

  -- Setup for `:` command-line completion
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }, -- Filesystem path source
    }, {
      { name = 'cmdline', option = { ignore_cmds = { 'Man', '!' } } }, -- Command-line source with ignored commands
    }),
  })
end

return {
  {
    'saghen/blink.cmp',
    lazy = false,
    dependencies = 'rafamadriz/friendly-snippets',
    version = 'v0.*',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = blink_cmp_opts, -- Use the defined Blink CMP options

    -- Allows extending the enabled_providers array elsewhere
    opts_extend = { 'sources.completion.enabled_providers' },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp' },
    config = lspconfig_config, -- Use the defined LSP configuration function
  },
  {
    'hrsh7th/cmp-cmdline',
    config = cmp_cmdline_config, -- Use the defined CMP command-line configuration function
  },
  { 'github/copilot.vim' },
}
