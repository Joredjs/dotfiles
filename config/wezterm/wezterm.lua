local wezterm = require 'wezterm'
local config = {}


local visual = require 'visual'
local keybindings = require 'keybindings'
local tabs = require 'tabs'
local workspaces = require 'workspaces'
local system = require 'system'

visual.apply(config)
keybindings.apply(config)
tabs.apply(config)
--workspaces.apply(config)
system.apply(config)

return config