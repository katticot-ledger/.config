local M = {}

-- Check if a `.prettierrc` config file exists in the project root
function M.has_config(ctx)
  local config_files = {
    '.prettierrc',
    '.prettierrc.json',
    '.prettierrc.yml',
    '.prettierrc.yaml',
    '.prettierrc.js',
    '.prettierrc.cjs',
    'prettier.config.js',
    'prettier.config.cjs',
  }
  for _, file in ipairs(config_files) do
    if vim.fn.filereadable(vim.fn.fnamemodify(ctx.filename, ':p:h') .. '/' .. file) == 1 then
      return true
    end
  end
  return false
end

-- Check if Treesitter has a parser for the file type
function M.has_parser(ctx)
  return vim.treesitter.get_parser(ctx.bufnr, ctx.ft) ~= nil
end

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = function()
    -- Configuration options
    return {
      notify_on_error = true,
      default_format_opts = {
        timeout_ms = 3000,
        async = false, -- Synchronous formatting by default
        quiet = false, -- Display errors
        lsp_format = 'false', -- Use fallback for unsupported file types
      },
      format_on_save = function(bufnr)
        local non_standard_filetypes = { c = true, cpp = true }
        local format_option = non_standard_filetypes[vim.bo[bufnr].filetype] and 'never' or 'fallback'
        return {
          timeout_ms = 500,
          lsp_format = format_option,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        fish = { 'fish_indent' },
        sh = { 'shfmt' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescriptreact = { 'prettier' },
        markdown = { 'prettierd', 'prettier' },
        json = { 'prettierd', 'prettier', 'jq' },
      },
      formatters = {
        prettier = {
          exe = 'prettier',
          args = { '--stdin-filepath', vim.api.nvim_buf_get_name(0) },
          stdin = true,
          condition = function(_, ctx)
            return M.has_parser(ctx) and (vim.g.lazyvim_prettier_needs_config ~= true or M.has_config(ctx))
          end,
        },
        injected = { options = { ignore_errors = true } },
      },
    }
  end,
}
