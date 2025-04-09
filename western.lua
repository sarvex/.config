
-- Pull in the wezterm API
local wezterm = require 'wezterm'


-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  local title = basename(pane.foreground_process_name)
  return {
    { Text = " " .. title .. " " },
  }
end)

local launch_menu = {
  { label = "Nushell", args = { "nu.exe" } },
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  table.insert(launch_menu, {
    label = "PowerShell Core",
    args = { "pwsh.exe", "-NoLogo" },
  })

  -- Find installed visual studio version(s) and add their compilation
  -- environment command prompts to the menu
  for _, vsvers in ipairs(wezterm.glob("Microsoft Visual Studio/20*", "C:/Program Files (x86)")) do
    local year = vsvers:gsub("Microsoft Visual Studio/", "")
    table.insert(launch_menu, {
      label = "x64 Native Tools VS " .. year,
      args = {
        "cmd.exe",
        "/k",
        "C:/Program Files (x86)/" .. vsvers .. "/BuildTools/VC/Auxiliary/Build/vcvars64.bat",
      },
    })
  end
end

-- This table will hold the configuration.
local config = {}
-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config = {
  font = wezterm.font('Delugia', { weight = 'DemiLight' }),
  window_background_opacity = 0.7,
  use_fancy_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  check_for_updates = true,
  color_scheme = "AdventureTime",
  tab_bar_at_bottom = true,
  font_size = 11.0,
  launch_menu = launch_menu,
  default_prog = { "pwsh.exe", "-NoLogo" },
  -- default_prog = { "nu.exe" },
}

-- and finally, return the configuration to wezterm
return config
