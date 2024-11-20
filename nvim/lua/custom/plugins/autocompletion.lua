return {
  {
    'saghen/blink.cmp',
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = 'rafamadriz/friendly-snippets',

    -- use a release tag to download pre-built binaries
    version = 'v0.*',
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- see the "default configuration" section below for full documentation on how to define
      -- your own keymap.
      keymap = { preset = 'default' },

      highlight = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = true,
      },
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',

      -- experimental auto-brackets support
      -- accept = { auto_brackets = { enabled = true } }

      -- experimental signature help support
      -- trigger = { signature_help = { enabled = true } }
    },
    -- allows extending the enabled_providers array elsewhere in your config
    -- without having to redefining it
    opts_extend = { 'sources.completion.enabled_providers' },
  },
  -- LSP servers and clients communicate what features they support through "capabilities".
  --  By default, Neovim support a subset of the LSP specification.
  --  With blink.cmp, Neovim has *more* capabilities which are communicated to the LSP servers.
  --  Explanation from TJ: https://youtu.be/m8C0Cq9Uv9o?t=1275
  --
  -- This can vary by config, but in general for nvim-lspconfig:

  {
    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp' },
    config = function(_, opts)
      local lspconfig = require 'lspconfig'
      for server, config in pairs(opts.servers or {}) do
        config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'onsails/lspkind-nvim', -- Adds icons to completion items
      {
        'L3MON4D3/LuaSnip', -- Snippet engine
        build = (function()
          -- Build step needed for regex support in snippets.
          -- Skips this step on Windows or if `make` is not available.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- Uncomment to load pre-made snippets for various languages
          -- 'rafamadriz/friendly-snippets',
          -- config = function()
          --   require('luasnip.loaders.from_vscode').lazy_load()
          -- end,
        },
      },
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'saadparwaiz1/cmp_luasnip', -- LuaSnip completion source for nvim-cmp
      'hrsh7th/cmp-nvim-lsp', -- LSP completion source
      'hrsh7th/cmp-path', -- Filesystem path completion
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local lspkind = require 'lspkind'

      -- Basic Luasnip configuration
      luasnip.config.setup {}

      -- nvim-cmp setup
      cmp.setup {
        formatting = {
          expandable_indicator = true, -- Optional indicator for expandable items
          fields = { 'kind', 'abbr', 'menu' }, -- Fields to display in the menu
          format = lspkind.cmp_format {
            mode = 'symbol_text', -- Show both symbol and text
            maxwidth = 50, -- Limit max width of completion items
            ellipsis_char = '...', -- Ellipsis for truncated items
            before = function(entry, vim_item)
              -- Customize the Copilot icon
              if entry.source.name == 'copilot' then
                vim_item.kind = 'Copilot'
                vim_item.kind_hl_group = 'CmpItemKindCopilot'
              end
              return vim_item
            end,
          },
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- Key mappings for nvim-cmp
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          -- Select the [p]revious item
          ['<C-n>'] = cmp.mapping.select_next_item(), -- Next item
          ['<C-p>'] = cmp.mapping.select_prev_item(), -- Previous item
          ['<C-b>'] = cmp.mapping.scroll_docs(-4), -- Scroll docs back
          ['<C-f>'] = cmp.mapping.scroll_docs(4), -- Scroll docs forward
          ['<C-y>'] = cmp.mapping.confirm { select = true }, -- Confirm selection
          ['<CR>'] = cmp.mapping.confirm { select = true }, -- Confirm selection with Enter
          ['<Tab>'] = cmp.mapping.select_next_item(), -- Tab for next item
          ['<S-Tab>'] = cmp.mapping.select_prev_item(), -- Shift-Tab for previous item
          ['<C-Space>'] = cmp.mapping.complete(), -- Manually trigger completion

          -- Snippet expansion/jumping with <C-l> and <C-h>
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },

        sources = {
          { name = 'lazydev', group_index = 0 }, -- Lazydev source for LuaLS
          { name = 'nvim_lsp' }, -- LSP source
          { name = 'luasnip' }, -- Snippet source
          { name = 'path' }, -- Filesystem path source
          { name = 'copilot', group_index = 2 }, -- GitHub Copilot source
        },
      }
    end,
  },
  {
    'hrsh7th/cmp-cmdline',
    config = function()
      local cmp = require 'cmp'

      -- Setup for `/` command-line completion
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }, -- Buffer source for searching within the current buffer
        },
      })

      -- Setup for `:` command-line completion
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }, -- Path source for filesystem navigation
        }, {
          { name = 'cmdline', option = { ignore_cmds = { 'Man', '!' } } }, -- Command-line source with ignored commands
        }),
      })
    end,
  },
  { 'github/copilot.vim' }, -- GitHub Copilot plugin
}
