local wezterm = require 'wezterm'

local M = {}

function M.apply(config)
  config.color_scheme = 'Catppuccin Mocha'
  
  config.font = wezterm.font('JetBrains Mono', { weight = 'Medium' })
  config.font_size = 10.0
  config.line_height = 1.3
  config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }
  
  config.window_background_opacity = 0.93
  config.window_decorations = "RESIZE"
  config.window_close_confirmation = 'AlwaysPrompt'
  config.window_padding = {
    left = 10,
    right = 20,
    top = 10,
    bottom = 20,
  }
  
  config.default_cursor_style = 'BlinkingUnderline'
  config.cursor_blink_rate = 400
  
  config.hide_tab_bar_if_only_one_tab = false
  config.tab_bar_at_bottom = true
  config.use_fancy_tab_bar = true
  config.tab_max_width = 32
  switch_to_last_active_tab_when_closing_tab = true
    
  config.max_fps = 60
  config.animation_fps = 60
  
  config.audible_bell = 'Disabled'
  config.visual_bell = {
    fade_in_duration_ms = 75,
    fade_out_duration_ms = 75,
    target = 'CursorColor',
  }
  
  config.scrollback_lines = 10000
  
  config.hyperlink_rules = {
    -- HTTP/HTTPS URLs
    {
      regex = 'https?://\\S+',
      format = '$0',
    },
    -- Archivos locales
    {
      regex = 'file://\\S+',
      format = '$0',
    },
    -- Git URLs
    {
      regex = 'git@\\S+',
      format = '$0',
    },
    -- Localhost con puertos
    {
      regex = 'localhost:[0-9]+',
      format = 'http://$0',
    },
  }
end

return M