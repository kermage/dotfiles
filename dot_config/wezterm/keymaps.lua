local wezterm = require("wezterm")
local act = wezterm.action
local is_mac = string.find(wezterm.target_triple, "apple") ~= nil

local mod = {
    SUPER = "SUPER",
    OPTION = "OPT",
    SUP_REV = "SUPER|SHIFT",
    OPT_REV = "OPT|SHIFT",
}

if not is_mac then
    mod.SUPER = "ALT"
    mod.OPTION = "SUPER"
    mod.SUP_REV = "ALT|SHIFT"
    mod.OPT_REV = "SUPER|SHIFT"
end

local leader = {
    key = " ",
    mods = "CTRL",
    timeout_milliseconds = 3000,
}

local keys = {
    { key = "LeftArrow",  mods = mod.SUPER, action = act.SendString("\x1bOH") },
    { key = "RightArrow", mods = mod.SUPER, action = act.SendString("\x1bOF") },
    { key = "Backspace",  mods = mod.SUPER, action = act.SendString("\x15") },

    { key = "LeftArrow",  mods = mod.OPTION, action = act.SendString("\x1bb") },
    { key = "RightArrow", mods = mod.OPTION, action = act.SendString("\x1bf") },

    { key = "a", mods = "CTRL", action = act.ActivateKeyTable { name = "Panes" } },
    { key = "n", mods = "CTRL|SHIFT", action = act.ShowLauncher },
}

local key_tables = {
    Panes = {
        { key = "q", mods = "CTRL", action = act.CloseCurrentPane({confirm = true}) },
        { key = "v", mods = "CTRL", action = act.SplitHorizontal({domain = "CurrentPaneDomain"}) },
        { key = "s", mods = "CTRL", action = act.SplitVertical({domain = "CurrentPaneDomain"}) },

        { key = "h", mods = "CTRL", action = act.AdjustPaneSize({ "Left", 5 }) },
        { key = "l", mods = "CTRL", action = act.AdjustPaneSize({ "Right", 5 }) },
        { key = "j", mods = "CTRL", action = act.AdjustPaneSize({ "Down", 5 }) },
        { key = "k", mods = "CTRL", action = act.AdjustPaneSize({ "Up", 5 }) },

        { key = "h", action = act.ActivatePaneDirection("Left") },
        { key = "l", action = act.ActivatePaneDirection("Right") },
        { key = "j", action = act.ActivatePaneDirection("Down") },
        { key = "k", action = act.ActivatePaneDirection("Up") },

        {
            key = "e",
            mods = "CTRL",
            action = act.PromptInputLine {
                description = wezterm.format {
                    { Attribute = { Intensity = "Bold" } },
                    { Foreground = { AnsiColor = "Blue" } },
                    { Text = "Rename the active tab" },
                },
                action = wezterm.action_callback(function(window, pane, line)
                    if line then
                        window:active_tab():set_title(line)
                    end
                end),
            },
        },
    },
}

return {
    leader = leader,
    keys = keys,
    key_tables = key_tables,
}
