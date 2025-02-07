-- Blink configuration
local blink_cmp_opts = {
  -- Keymap presets: 'super-tab' for vscode-like, 'enter' for using Enter to accept
  keymap = { preset = 'enter' },
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    },
    menu = {
      draw = {
        components = {
          kind_icon = {
            ellipsis = false,
            text = function(ctx)
              local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
              return kind_icon
            end,
            -- Optionally, you may also use the highlights from mini.icons
            highlight = function(ctx)
              local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
              return hl
            end,
          },
        },
      },
    },
  },
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

return {
  {
    'saghen/blink.cmp',
    lazy = false,
    dependencies = 'rafamadriz/friendly-snippets',
    version = '*',

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
}
