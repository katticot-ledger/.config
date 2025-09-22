-- Helper to fetch icons from mini.icons while handling the module not being available yet
local function get_mini_icon(kind)
  local ok, mini_icons = pcall(require, 'mini.icons')
  if not ok then
    return nil, nil
  end
  local icon, hl = mini_icons.get('lsp', kind)
  return icon, hl
end

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
              local kind_icon = get_mini_icon(ctx.kind)
              return kind_icon or ''
            end,
            -- Optionally, you may also use the highlights from mini.icons
            highlight = function(ctx)
              local _, hl = get_mini_icon(ctx.kind)
              return hl
            end,
          },
        },
      },
    },
  },
}

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
}
