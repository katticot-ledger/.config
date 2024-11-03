-- Pull in the wezterm API
local wezterm = require("wezterm")
-- This will hold the configuration.
--
-- Function to check for existing tmux sessions
local function start_or_attach_tmux()
  -- Run `tmux ls` to check for active sessions
  local result = os.execute("tmux ls > /dev/null 2>&1")

  if result == 0 then
    -- If no sessions are found, start a new tmux session
    return { "/opt/homebrew/bin/tmux" }
  else
    -- If `tmux ls` succeeded, attach to the first available session
    return { "/opt/homebrew/bin/tmux", "a" }
  end
end
-- This will hold the configuration.
local config = wezterm.config_builder()

-- Apply the tmux command logic to default_prog
config.default_prog = start_or_attach_tmux()
-- This is where you actually apply your config choices

-- my coolnight colorscheme
--
--tokyonight_storm
--Catppuccin Mocha
local mycoolnight = {
  foreground = "#CBE0F0", -- Light cyan for good contrast with dark background
  background = "#011423", -- Dark blue to keep it subtle and easy on the eyes
  cursor_bg = "#FFFFFF", -- White cursor for better visibility
  cursor_border = "#FFFFFF", -- White border to complement the cursor
  cursor_fg = "#011423", -- Dark background to make the cursor standout
  selection_bg = "#083D5F", -- A slightly brighter blue for selections to stand out
  selection_fg = "#FFFFFF", -- White text on selection for high contrast

  ansi = {
    "#214969", -- Dark blue for basic text
    "#FF5F5F", -- Brighter red for errors
    "#44FFB1", -- Bright green for success messages
    "#FFD700", -- Yellow for warnings
    "#0FC5ED", -- Cyan for info messages
    "#A277FF", -- Purple for variables or important text
    "#24EAF7", -- Bright blue for directories or links
    "#E0E0E0", -- Light gray for neutral information
  },

  brights = {
    "#34688D", -- Slightly brighter blue for focus
    "#FF8080", -- Light red for brighter emphasis
    "#55FFBF", -- Bright green for highlights
    "#FFEB86", -- Softer yellow for less harsh warnings
    "#9A77FF", -- Brighter purple for key text
    "#C4A5FF", -- Light lavender for emphasis
    "#5BEAF7", -- Lighter cyan for directories
    "#FFFFFF", -- Pure white for emphasis on neutral text
  },
}
config.color_scheme = "Darcula (base16)"
config.window_background_image = "/Users/keita.atticot/Documents/Image/wallpaper/idea.jpg"
--config.colors = mycoolnight
config.font = wezterm.font("CaskaydiaCove Nerd Font")
config.font_size = 20

config.enable_tab_bar = false

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.85
config.macos_window_background_blur = 10
config.initial_cols = 260
config.initial_rows = 70
-- and finally, return the configuration to wezterm
--
return config
