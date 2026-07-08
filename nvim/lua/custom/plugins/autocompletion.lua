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
            highlight = function(ctx)
              local _, hl = get_mini_icon(ctx.kind)
              return hl
            end,
          },
        },
      },
    },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer', 'avante_commands', 'avante_mentions', 'avante_files' },
    providers = {
      avante_commands = {
        name = 'avante_commands',
        module = 'blink.compat.source',
        score_offset = 90,
        opts = {},
      },
      avante_files = {
        name = 'avante_files',
        module = 'blink.compat.source',
        score_offset = 100,
        opts = {},
      },
      avante_mentions = {
        name = 'avante_mentions',
        module = 'blink.compat.source',
        score_offset = 1000,
        opts = {},
      },
    },
  },
}

return {
  {
    'saghen/blink.cmp',
    lazy = false,
    dependencies = {
      'rafamadriz/friendly-snippets',
      'saghen/blink.compat',
    },
    version = '*',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = blink_cmp_opts,
  },
}
