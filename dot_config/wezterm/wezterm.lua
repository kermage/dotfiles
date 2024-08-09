local wezterm = require "wezterm"
local config = wezterm.config_builder()

config:set_strict_mode(true)

config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.window_padding = {
    left = 20,
    right = 0,
    top = 20,
    bottom = 0,
}

config.color_scheme = "Catppuccin Macchiato"
config.font = wezterm.font("JetBrainsMono Nerd Font", {weight = "Bold"})
config.font_size = 15.0
config.line_height = 1.25
--config.disable_default_key_bindings = true

local binding = require("keymaps")

config.leader = binding.leader
config.keys = binding.keys
config.key_tables = binding.key_tables

wezterm.on('update-right-status', function(window, pane)
    local label = window:active_key_table()
    if label then
        label = "KeyTable: " .. label
    else
        label = "WorkSpace: " .. window:active_workspace()
    end
    window:set_right_status(label)
end)

return config
