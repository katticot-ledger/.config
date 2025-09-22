local function lsp_component()
  local buf = vim.api.nvim_get_current_buf()
  local clients = {}

  if vim.lsp.get_clients then
    clients = vim.lsp.get_clients { bufnr = buf }
  elseif vim.lsp.get_active_clients then
    for _, client in ipairs(vim.lsp.get_active_clients()) do
      if client.attached_buffers and client.attached_buffers[buf] then
        table.insert(clients, client)
      end
    end
  end

  if #clients == 0 then
    return ''
  end

  local client_names = {}
  for _, client in ipairs(clients) do
    if client.name ~= '' then
      table.insert(client_names, client.name)
    end
  end

  if #client_names == 0 then
    return ''
  end

  return table.concat(client_names, ', ')
end

return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = function()
      local icons_enabled = vim.g.have_nerd_font
      local component_separators = icons_enabled and { left = '', right = '' } or { left = '|', right = '|' }
      local section_separators = icons_enabled and { left = '', right = '' } or { left = '', right = '' }

      return {
        options = {
          theme = 'auto',
          globalstatus = true,
          icons_enabled = icons_enabled,
          component_separators = component_separators,
          section_separators = section_separators,
          disabled_filetypes = { statusline = { 'alpha' } },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = {
            { 'branch', icon = icons_enabled and '' or 'git' },
            { 'diff', symbols = icons_enabled and { added = ' ', modified = ' ', removed = ' ' } or { added = '+', modified = '~', removed = '-' } },
          },
          lualine_c = {
            {
              'filename',
              path = 1,
              symbols = { modified = ' [+]', readonly = ' [-]', unnamed = '[No Name]', newfile = '[New]' },
            },
          },
          lualine_x = {
            { 'diagnostics', sources = { 'nvim_diagnostic' } },
            {
              lsp_component,
              cond = function()
                return lsp_component() ~= ''
              end,
              color = { gui = 'bold' },
            },
            'encoding',
            'filetype',
          },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            {
              'filename',
              path = 1,
              symbols = { modified = ' [+]', readonly = ' [-]', unnamed = '[No Name]', newfile = '[New]' },
            },
          },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { 'quickfix', 'man', 'lazy' },
      }
    end,
  },
}
