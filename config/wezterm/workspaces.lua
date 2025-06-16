-- config/workspaces.lua - Configuración de workspaces para diferentes proyectos
local wezterm = require 'wezterm'

local M = {}

function M.apply(config)
  -- =====================================
  -- CONFIGURACIÓN INICIAL DE WORKSPACES
  -- =====================================
  wezterm.on('gui-startup', function(cmd)
    -- Obtener el directorio home del usuario en Windows
    local home_dir = os.getenv('USERPROFILE') or os.getenv('HOME')
    
    -- Workspace principal - Terminal general
    local main_tab, main_pane, main_window = wezterm.mux.spawn_window {
      workspace = 'main',
      cwd = home_dir,
    }
    main_tab:set_title('Terminal')
    
    -- Workspace de desarrollo - Directorio de proyectos
    local dev_workspace_dir = home_dir .. '\\Documents\\Projects'
    -- Verificar si existe el directorio, si no usar Documents
    local dev_dir = dev_workspace_dir
    local f = io.open(dev_workspace_dir, 'r')
    if f == nil then
      dev_dir = home_dir .. '\\Documents'
    else
      f:close()
    end
    
    local dev_tab, dev_pane, dev_window = wezterm.mux.spawn_window {
      workspace = 'dev',
      cwd = dev_dir,
    }
    dev_tab:set_title('Development')
    
    -- Workspace de testing - Para pruebas y debugging
    local test_tab, test_pane, test_window = wezterm.mux.spawn_window {
      workspace = 'test',
      cwd = dev_dir,
    }
    test_tab:set_title('Testing')
    
    -- Workspace de producción - Para deployment y monitoreo
    local prod_tab, prod_pane, prod_window = wezterm.mux.spawn_window {
      workspace = 'prod',
      cwd = dev_dir,
    }
    prod_tab:set_title('Production')
    
    -- Configurar el tamaño de ventana inicial
    main_window:gui_window():set_inner_size(1200, 800)
    
    -- Activar el workspace principal
    wezterm.mux.set_active_workspace('main')
  end)
  
  -- =====================================
  -- CONFIGURACIÓN ESPECÍFICA POR WORKSPACE
  -- =====================================
  
  -- Configurar variables de entorno específicas por workspace
  wezterm.on('new-tab-button-click', function(window, pane, button, default_action)
    local workspace = window:active_workspace()
    
    -- Configuraciones específicas por workspace
    local workspace_configs = {
      ['dev'] = {
        cwd = os.getenv('USERPROFILE') .. '\\Documents\\Projects',
        title = 'Dev Terminal',
      },
      ['test'] = {
        cwd = os.getenv('USERPROFILE') .. '\\Documents\\Projects',
        title = 'Test Terminal',
      },
      ['prod'] = {
        cwd = os.getenv('USERPROFILE') .. '\\Documents\\Projects',
        title = 'Prod Terminal',
      },
      ['main'] = {
        cwd = os.getenv('USERPROFILE'),
        title = 'Main Terminal',
      },
    }
    
    local workspace_config = workspace_configs[workspace] or workspace_configs['main']
    
    -- Crear nueva tab con configuración específica del workspace
    if button == 'Left' then
      window:perform_action(
        wezterm.action.SpawnTab {
          CurrentPaneDomain = {
            cwd = workspace_config.cwd,
          },
        },
        pane
      )
      return false -- Prevenir la acción por defecto
    end
    
    return default_action
  end)
  
  -- =====================================
  -- UTILIDADES DE WORKSPACE
  -- =====================================
  
  -- Función para cambiar rápidamente entre workspaces con un menú
  wezterm.on('show-launcher', function(window, pane)
    local workspaces = {
      { id = 'main', label = '🏠 Main - Terminal general' },
      { id = 'dev', label = '💻 Development - Programación' },
      { id = 'test', label = '🧪 Testing - Pruebas y debugging' },
      { id = 'prod', label = '🚀 Production - Deployment' },
    }
    
    local choices = {}
    for _, ws in ipairs(workspaces) do
      table.insert(choices, {
        id = ws.id,
        label = ws.label,
      })
    end
    
    window:perform_action(
      wezterm.action.InputSelector {
        action = wezterm.action_callback(function(window, pane, id, label)
          if not id then
            return
          end
          window:perform_action(
            wezterm.action.SwitchToWorkspace {
              name = id,
            },
            pane
          )
        end),
        title = 'Seleccionar Workspace',
        choices = choices,
        fuzzy = true,
      },
      pane
    )
  end)
  
  -- =====================================
  -- LAYOUTS PREDEFINIDOS POR WORKSPACE
  -- =====================================
  
  -- Función para configurar layouts específicos cuando se activa un workspace
  wezterm.on('window-focus-changed', function(window, pane)
    local workspace = window:active_workspace()
    
    -- Layouts específicos por workspace
    if workspace == 'dev' then
      -- En el workspace de desarrollo, configurar para tener editor + terminal
      -- Esta configuración se puede expandir según necesidades
    elseif workspace == 'test' then
      -- En el workspace de testing, configurar para logs + tests
    elseif workspace == 'prod' then
      -- En el workspace de producción, configurar para monitoreo
    end
  end)
  
  -- =====================================
  -- SHORTCUTS ADICIONALES PARA WORKSPACES
  -- =====================================
  
  -- Agregar shortcuts adicionales específicos para workspaces
  local additional_keys = {
    -- Launcher de workspaces
    {
      key = 'l',
      mods = 'CTRL|SHIFT',
      action = wezterm.action_callback(function(window, pane)
        wezterm.emit('show-launcher', window, pane)
      end),
    },
    
    -- Crear workspace nuevo
    {
      key = 'w',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.PromptInputLine {
        description = 'Nombre del nuevo workspace:',
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:perform_action(
              wezterm.action.SwitchToWorkspace {
                name = line,
                spawn = {
                  cwd = os.getenv('USERPROFILE'),
                },
              },
              pane
            )
          end
        end),
      },
    },
  }
  
  -- Agregar las teclas adicionales a la configuración
  if not config.keys then
    config.keys = {}
  end
  
  for _, key in ipairs(additional_keys) do
    table.insert(config.keys, key)
  end
end

return M