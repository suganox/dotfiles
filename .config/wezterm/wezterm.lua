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
  { key = 'LeftArrow', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = 'RightArrow', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(1) },
  { key = 'i', mods = 'CMD|SHIFT', action = act.SpawnTab('DefaultDomain') },
  { key = 'x', mods = 'CMD|SHIFT', action = act.CloseCurrentTab {confirm=true} },
  { key = 'UpArrow', mods = 'CMD|SHIFT', action = act.SwitchWorkspaceRelative(1) },
  { key = 'DownArrow', mods = 'CMD|SHIFT', action = act.SwitchWorkspaceRelative(-1) },
  {
    key = 'c',
    mods = 'CMD|SHIFT',
    action = act.PromptInputLine {
      description = "(wezterm) Create new workspace:",
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
      description = '(wezterm) Set workspace title:',
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
  {-- List workspace
    key = 'l',
    mods = 'CMD|SHIFT',
    action = wezterm.action_callback (function(win, pane)
      local workspaces = {}
      for i, name in ipairs(wezterm.mux.get_workspace_names()) do
        table.insert(workspaces, {
          id = name,
          label = string.format("%d. %s", i, name),
        })
      end
      local current = wezterm.mux.get_active_workspace()
      win:perform_action(act.InputSelector {
        action = wezterm.action_callback(function(_, _, id)
        win:perform_action(act.SwitchToWorkspace { name = id }, pane)
        end),
        title = "Select workspace",
        choices = workspaces,
        fuzzy = true,
        fuzzy_description = string.format("Current workspace: %s ", current),
      }, pane)
    end),
  },
}

return config
