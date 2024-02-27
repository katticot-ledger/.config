return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = false,
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
  --   "BufReadPre path/to/my-vault/**.md",
  --   "BufNewFile path/to/my-vault/**.md",
  -- },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    daily_notes = {
      folder = "Inbox",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      template = nil,
    },
    -- Optional, customize how names/IDs for new notes are created.
    note_id_func = function(title)
      -- Create note IDs with the current date and time, followed by the note title.
      local date_time = os.date("%Y%m%d%H%M%S") -- Date and time in 'YYYYMMDDHHMMSS' format
      local suffix = ""
      if title ~= nil then
        -- If title is given, transform it into a valid file name.
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- If title is nil, just add a random suffix.
        suffix = string.char(math.random(65, 90), math.random(65, 90), math.random(65, 90), math.random(65, 90))
      end
      return suffix
    end,

    workspaces = {
      {
        name = "ledger",
        path = "/Users/keita.atticot/Google Drive/My Drive/obsidian",
      },
      {
        name = "work",
        path = "~/vaults/work",
      },
    },

    -- see below for full list of options 👇
  },
}
