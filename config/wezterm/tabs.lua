-- config/tabs.lua - Configuración de tabs inteligentes
local wezterm = require 'wezterm'

local M = {}

function M.apply(config)
  -- =====================================
  -- FORMATEO DE TÍTULOS DE TABS
  -- =====================================
  wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    local title = tab.tab_title
    
    -- Si hay un título personalizado, usarlo
    if title and #title > 0 then
      return title
    end
    
    -- Obtener el proceso actual
    local process_name = tab.active_pane.foreground_process_name or ''
    
    -- En Windows, obtener solo el nombre del ejecutable
    local process = process_name:match('([^\\]+)%.exe$') or 
                   process_name:match('([^\\]+)$') or 
                   process_name
    
    -- Convertir a minúsculas para comparación
    process = process:lower()
    
    -- Iconos para diferentes procesos (incluyendo ejecutables de Windows)
    local process_icons = {
      -- Editores
      ['nvim'] = '  ',
      ['vim'] = '  ',
      ['code'] = '  ',
      ['notepad++'] = '  ',
      ['notepad'] = '  ',
      
      -- Desarrollo
      ['git'] = '  ',
      ['node'] = '  ',
      ['npm'] = '  ',
      ['yarn'] = '  ',
      ['pnpm'] = '  ',
      ['python'] = '  ',
      ['py'] = '  ',
      ['java'] = '  ',
      ['javac'] = '  ',
      ['dotnet'] = '  ',
      ['go'] = '  ',
      ['cargo'] = '  ',
      ['rustc'] = '  ',
      
      -- Contenedores y DevOps
      ['docker'] = '  ',
      ['docker-compose'] = '  ',
      ['kubectl'] = '  ',
      ['terraform'] = '  ',
      
      -- Shells de Windows
      ['powershell'] = '  ',
      ['pwsh'] = '  ',
      ['cmd'] = '  ',
      ['wsl'] = '  ',
      ['bash'] = '  ',
      ['zsh'] = '  ',
      ['fish'] = '  ',
      
      -- Herramientas de desarrollo
      ['make'] = '  ',
      ['cmake'] = '  ',
      ['gcc'] = '  ',
      ['clang'] = '  ',
      ['ping'] = '  ',
      ['curl'] = '  ',
      ['wget'] = '  ',
      ['ssh'] = '  ',
      
      -- Bases de datos
      ['mysql'] = '  ',
      ['psql'] = '  ',
      ['sqlite3'] = '  ',
      ['mongo'] = '  ',
      ['redis-cli'] = '  ',
      
      -- Servidores web
      ['nginx'] = '  ',
      ['apache'] = '  ',
      ['httpd'] = '  ',
      
      -- Otros
      ['explorer'] = '  ',
      ['taskmgr'] = '  ',
    }
    
    -- Obtener el icono o usar uno por defecto
    local icon = process_icons[process] or '  '
    
    -- Crear el título de la tab
    local tab_title = icon .. process
    
    -- Truncar si es muy largo
    if #tab_title > max_width - 2 then
      tab_title = string.sub(tab_title, 1, max_width - 5) .. '…'
    end
    
    -- Agregar indicador si la tab está activa
    if tab.is_active then
      return ' ' .. tab_title .. ' '
    else
      return ' ' .. tab_title .. ' '
    end
  end)
  
  -- =====================================
  -- COLORES DE TABS PERSONALIZADOS
  -- =====================================
  wezterm.on('update-status', function(window, pane)
    -- Obtener información del workspace actual
    local workspace = window:active_workspace()
    local date = wezterm.strftime '%Y-%m-%d %H:%M:%S'
    
    -- Colores para diferentes workspaces
    local workspace_colors = {
      ['main'] = { bg = '#1e1e2e', fg = '#cdd6f4' },
      ['dev'] = { bg = '#313244', fg = '#94e2d5' },
      ['test'] = { bg = '#45475a', fg = '#f9e2af' },
      ['prod'] = { bg = '#585b70', fg = '#f38ba8' },
    }
    
    local color = workspace_colors[workspace] or workspace_colors['main']
    
    -- Mostrar workspace y hora en la barra de estado
    window:set_right_status(wezterm.format {
      { Background = { Color = color.bg } },
      { Foreground = { Color = color.fg } },
      { Text = ' ' .. workspace:upper() .. ' | ' .. date .. ' ' },
    })
  end)
  
  -- =====================================
  -- CONFIGURACIÓN ADICIONAL DE TABS
  -- =====================================
  
  -- Mostrar información adicional en tabs cuando hay procesos específicos
  wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
    local zoomed = ''
    if tab.active_pane.is_zoomed then
      zoomed = '[Z] '
    end
    
    local index = ''
    if #tabs > 1 then
      index = string.format('[%d/%d] ', tab.tab_index + 1, #tabs)
    end
    
    return zoomed .. index .. tab.active_pane.title
  end)
end

return M