local wezterm = require 'wezterm'

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

config.color_scheme = 'iceberg'
--config.font = wezterm.font("Menlo", { weight = 'Regular', stretch = 'Normal', style = 'Normal' })
config.font_size = 14.0
config.window_background_opacity = 0.7

wezterm.on("update-right-status", function(window)
  local workspace_name = window:active_workspace() or "default"
  window:set_right_status(wezterm.format({
    {Text="Workspace:" .. workspace_name},
  }))
end)

local act = wezterm.action
config.keys = {
  { key = 'n', mods = 'CMD|SHIFT', action = act.SwitchWorkspaceRelative(1) },
  { key = 'p', mods = 'CMD|SHIFT', action = act.SwitchWorkspaceRelative(-1) },
  { key = 'l', mods = 'CMD|SHIFT', action = act.ShowLauncherArgs { flags = 'WORKSPACES' } },
  { key = '[', mods = 'CMD|OPT', action = act.ActivateTabRelative(-1) },
  { key = ']', mods = 'CMD|OPT', action = act.ActivateTabRelative(1) },
  { key = '1', mods = 'CMD|OPT', action = act.ActivateTab(0) },
  { key = '2', mods = 'CMD|OPT', action = act.ActivateTab(1) },
  { key = '3', mods = 'CMD|OPT', action = act.ActivateTab(3) },
  { key = '4', mods = 'CMD|OPT', action = act.ActivateTab(6) },
  { key = '5', mods = 'CMD|OPT', action = act.ActivateTab(5) },
  { key = '6', mods = 'CMD|OPT', action = act.ActivateTab(6) },
  { key = '7', mods = 'CMD|OPT', action = act.ActivateTab(7) },
  { key = '8', mods = 'CMD|OPT', action = act.ActivateTab(8) },
  { key = '9', mods = 'CMD|OPT', action = act.ActivateTab(9) },
  { key = 's', mods = 'CTRL|SHIFT', action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = 'v', mods = 'CTRL|SHIFT', action = act.SplitVertical { domain = "CurrentPaneDomain" } },
  { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentPane { confirm = true } },
  {
    key = 'c',
    mods = 'CMD|SHIFT',
    action = act.PromptInputLine {
      description = wezterm.format {
        { Text = 'Enter name for new workspace' },
      },
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(
            act.SwitchToWorkspace {
              name = line,
            },
            pane
          )
        end
      end),
    },
  },
  {
    key = 'r',
    mods = 'CMD|SHIFT',
    action = act.PromptInputLine {
      description = wezterm.format {
        { Text = 'Rename workspace' },
      },
      action = wezterm.action_callback(function(line)
        if line then
          wezterm.mux.rename_workspace(
            wezterm.mux.get_active_workspace(),
            line
          )
        end
      end),
    },
  },
}

return config
