-- config/keybindings.lua - Configuración de atajos de teclado para Windows
local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}

function M.apply(config)
  -- =====================================
  -- KEYBINDINGS PARA WINDOWS
  -- =====================================
  config.keys = {
    -- ===== GESTIÓN DE TABS =====
    -- Crear nueva tab
    { key = 't', mods = 'CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
    -- Cerrar tab actual
    { key = 'w', mods = 'CTRL', action = act.CloseCurrentTab { confirm = true } },
    -- Navegar entre tabs
    { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
    { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
    -- Ir a tab específica (usando Alt + número como en muchos programas de Windows)
    { key = '1', mods = 'ALT', action = act.ActivateTab(0) },
    { key = '2', mods = 'ALT', action = act.ActivateTab(1) },
    { key = '3', mods = 'ALT', action = act.ActivateTab(2) },
    { key = '4', mods = 'ALT', action = act.ActivateTab(3) },
    { key = '5', mods = 'ALT', action = act.ActivateTab(4) },
    { key = '6', mods = 'ALT', action = act.ActivateTab(5) },
    { key = '7', mods = 'ALT', action = act.ActivateTab(6) },
    { key = '8', mods = 'ALT', action = act.ActivateTab(7) },
    { key = '9', mods = 'ALT', action = act.ActivateTab(8) },

    -- ===== GESTIÓN DE PANES =====
    -- Dividir horizontalmente
    { key = 'd', mods = 'CTRL', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    -- Dividir verticalmente  
    { key = 'd', mods = 'CTRL|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    -- Navegar entre panes usando Ctrl+Shift+flechas (común en Windows)
    { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Left' },
    { key = 'RightArrow', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Right' },
    { key = 'UpArrow', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Up' },
    { key = 'DownArrow', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Down' },
    -- Redimensionar panes
    { key = 'LeftArrow', mods = 'CTRL|ALT', action = act.AdjustPaneSize { 'Left', 1 } },
    { key = 'RightArrow', mods = 'CTRL|ALT', action = act.AdjustPaneSize { 'Right', 1 } },
    { key = 'UpArrow', mods = 'CTRL|ALT', action = act.AdjustPaneSize { 'Up', 1 } },
    { key = 'DownArrow', mods = 'CTRL|ALT', action = act.AdjustPaneSize { 'Down', 1 } },
    -- Cerrar pane
    { key = 'x', mods = 'CTRL|SHIFT', action = act.CloseCurrentPane { confirm = false } },
    -- Maximizar/restaurar pane
    { key = 'z', mods = 'CTRL|SHIFT', action = act.TogglePaneZoomState },

    -- ===== NAVEGACIÓN Y BÚSQUEDA =====
    -- Buscar en el scrollback (Ctrl+F es estándar en Windows)
    { key = 'f', mods = 'CTRL', action = act.Search 'CurrentSelectionOrEmptyString' },
    -- Copiar/Pegar (usando los estándares de Windows)
    { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo 'Clipboard' },
    { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },
    -- También permitir Ctrl+Insert y Shift+Insert (clásicos de Windows)
    { key = 'Insert', mods = 'CTRL', action = act.CopyTo 'Clipboard' },
    { key = 'Insert', mods = 'SHIFT', action = act.PasteFrom 'Clipboard' },
    -- Seleccionar todo
    -- { key = 'a', mods = 'CTRL', action = act.SelectAll },

    -- ===== UTILIDADES DE DESARROLLO =====
    -- Limpiar pantalla
    { key = 'k', mods = 'CTRL|SHIFT', action = act.ClearScrollback 'ScrollbackAndViewport' },
    -- Recargar configuración
    { key = 'r', mods = 'CTRL|SHIFT', action = act.ReloadConfiguration },
    -- Toggle fullscreen (F11 es común en Windows)
    { key = 'F11', mods = 'NONE', action = act.ToggleFullScreen },
    -- También con Enter como alternativa
    { key = 'Enter', mods = 'ALT', action = act.ToggleFullScreen },
    
    -- ===== WORKSPACE SWITCHING =====
    -- Cambiar entre workspaces usando Ctrl+Win+número
    { key = '1', mods = 'CTRL|WIN', action = act.SwitchToWorkspace { name = 'main' } },
    { key = '2', mods = 'CTRL|WIN', action = act.SwitchToWorkspace { name = 'dev' } },
    { key = '3', mods = 'CTRL|WIN', action = act.SwitchToWorkspace { name = 'test' } },
    { key = '4', mods = 'CTRL|WIN', action = act.SwitchToWorkspace { name = 'prod' } },
    
    -- ===== ATAJOS ADICIONALES PARA PRODUCTIVIDAD =====
    -- Crear nueva ventana
    { key = 'n', mods = 'CTRL|SHIFT', action = act.SpawnWindow },
    -- Cambiar entre ventanas
    { key = '`', mods = 'CTRL', action = act.ActivateLastTab },
    -- Scroll rápido
    { key = 'PageUp', mods = 'SHIFT', action = act.ScrollByPage(-1) },
    { key = 'PageDown', mods = 'SHIFT', action = act.ScrollByPage(1) },
    -- Ir al inicio/final del scrollback
    { key = 'Home', mods = 'CTRL|SHIFT', action = act.ScrollToTop },
    { key = 'End', mods = 'CTRL|SHIFT', action = act.ScrollToBottom },
  }

  -- =====================================
  -- CONFIGURACIÓN DE MOUSE
  -- =====================================
  config.mouse_bindings = {
    -- Clic derecho para pegar (común en terminales de Linux/Windows)
    {
      event = { Down = { streak = 1, button = 'Right' } },
      mods = 'NONE',
      action = act.PasteFrom 'Clipboard',
    },
    -- Ctrl+Clic para abrir URLs
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = act.OpenLinkAtMouseCursor,
    },
    -- Clic medio para pegar (común en Linux, algunos usuarios lo prefieren)
    {
      event = { Down = { streak = 1, button = 'Middle' } },
      mods = 'NONE',
      action = act.PasteFrom 'Clipboard',
    },
    -- Scroll con Ctrl para zoom (común en aplicaciones de Windows)
    {
      event = { Down = { streak = 1, button = { WheelUp = 1 } } },
      mods = 'CTRL',
      action = act.IncreaseFontSize,
    },
    {
      event = { Down = { streak = 1, button = { WheelDown = 1 } } },
      mods = 'CTRL',
      action = act.DecreaseFontSize,
    },
  }
end

return M