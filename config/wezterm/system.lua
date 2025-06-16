-- config/system.lua - Configuración específica del sistema (Windows)
local wezterm = require 'wezterm'

local M = {}

function M.apply(config)

    local gitbash_path = 'C:\\Users\\Edu\\scoop\\apps\\git\\current\\bin\\bash.exe'
    local gitbash_args = {gitbash_path, '--login', '-i'}
    -- Shell por defecto
    config.default_prog = gitbash_args

    -- Alternativas de shell disponibles en el menú
    config.launch_menu = {{
        label = 'Git Bash',
        args = gitbash_args
    }, {
        label = 'PowerShell',
        args = {'powershell.exe', '-NoLogo'}
    }, {
        label = 'Command Prompt',
        args = {'cmd.exe'}
    }, {
        label = 'PowerShell Core',
        args = {'pwsh.exe', '-NoLogo'}
    }}
end

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {}) 

  window:gui_window():maximize()
end)

return M

--[[ 
-- config/system.lua - Configuración específica del sistema (Windows)
local wezterm = require 'wezterm'

local M = {}

function M.apply(config)
  -- =====================================
  -- DETECCIÓN DEL SISTEMA OPERATIVO
  -- =====================================
  local function is_windows()
    return wezterm.target_triple:find('windows') ~= nil
  end
  
  local function is_wsl()
    -- Verificar si estamos en WSL
    local handle = io.popen('uname -r 2>nul')
    if handle then
      local result = handle:read('*a') or ''
      handle:close()
      return result:lower():find('microsoft') ~= nil or result:lower():find('wsl') ~= nil
    end
    return false
  end
  
  -- =====================================
  -- CONFIGURACIÓN ESPECÍFICA DE WINDOWS
  -- =====================================
  if is_windows() then

    local gitbash_path = 'C:\\Users\\Edu\\scoop\\apps\\git\\current\\git-bash.exe'
    local gitbash_args = { gitbash_path, '--login', '-i' }
    -- Shell por defecto
    config.default_prog = gitbash_args
    
    -- Alternativas de shell disponibles en el menú
    config.launch_menu = {
      {
        label = 'Git Bash',
        args = gitbash_args,
      },
      -- {
      --   label = 'PowerShell',
      --   args = { 'powershell.exe', '-NoLogo' },
      -- },
      -- {
      --   label = 'Command Prompt',
      --   args = { 'cmd.exe' },
      -- },
      -- {
      --   label = 'PowerShell Core',
      --   args = { 'pwsh.exe', '-NoLogo' },
      -- },
    }
    
    -- Detectar y agregar WSL si está disponible
    local wsl_distros = {
      'Ubuntu',
      'Ubuntu-20.04',
      'Ubuntu-22.04',
      'Debian',
      'kali-linux',
      'openSUSE-Leap-15-3',
    }
    
    for _, distro in ipairs(wsl_distros) do
      local handle = io.popen('wsl.exe -l -q 2>nul')
      if handle then
        local wsl_list = handle:read('*a') or ''
        handle:close()
        if wsl_list:find(distro) then
          table.insert(config.launch_menu, {
            label = 'WSL - ' .. distro,
            args = { 'wsl.exe', '-d', distro },
          })
        end
      end
    end
    
    -- Agregar Git Bash si está instalado
    -- local git_bash_paths = {
    --   'C:\\Users\\Edu\\scoop\\apps\\git\\current\\git-bash.exe',
    -- }
    
    -- for _, path in ipairs(git_bash_paths) do
    --   local f = io.open(path, 'r')
    --   if f ~= nil then
    --     f:close()
    --     table.insert(config.launch_menu, {
    --       label = 'Git Bash',
    --       args = { path },
    --     })
    --     break
    --   end
    -- end
  end
  
  -- =====================================
  -- CONFIGURACIÓN DE VARIABLES DE ENTORNO
  -- =====================================
  config.set_environment_variables = {
    -- Terminal type
    TERM = 'wezterm',
    
    -- Habilitar colores en herramientas de línea de comandos
    CLICOLOR = '1',
    COLORTERM = 'truecolor',
    
    -- Editor por defecto (ajustar según preferencia)
    EDITOR = 'code', -- Visual Studio Code
    -- EDITOR = 'nvim', -- Neovim (descomenta si prefieres)
    
    -- Configuración específica de Windows
    PYTHONIOENCODING = 'utf-8',
    
    -- Mejorar la experiencia con PowerShell
    POWERSHELL_TELEMETRY_OPTOUT = '1',
  }
  
  -- =====================================
  -- CONFIGURACIÓN DE FUENTES PARA WINDOWS
  -- =====================================
  
  -- Lista de fuentes recomendadas para desarrollo (en orden de preferencia)
  local preferred_fonts = {
    'JetBrains Mono',
    'Cascadia Code',
    'Fira Code',
    'Source Code Pro',
    'Consolas',
    'Courier New',
  }
  
  -- Intentar usar la primera fuente disponible
  for _, font_name in ipairs(preferred_fonts) do
    config.font = wezterm.font(font_name, { weight = 'Medium' })
    -- Si quieres verificar disponibilidad, descomenta:
    -- local fonts = wezterm.font_with_fallback({ font_name })
    -- if fonts then
    --   config.font = fonts
    --   break
    -- end
  end
  
  -- =====================================
  -- CONFIGURACIÓN DE RENDIMIENTO
  -- =====================================
  
  -- Optimizaciones para Windows
  config.webgpu_power_preference = 'HighPerformance'
  config.front_end = 'WebGpu' -- Mejor rendimiento en Windows moderno
  
  -- Configuración de memoria
  config.max_fps = 60
  config.animation_fps = 60
  
  -- =====================================
  -- INTEGRACIÓN CON EXPLORADOR DE WINDOWS
  -- =====================================
  
  -- Configurar acciones personalizadas
  wezterm.on('open-in-explorer', function(window, pane)
    local cwd = pane:get_current_working_dir()
    if cwd then
      local path = cwd.file_path
      if path then
        -- Abrir el directorio actual en el Explorador de Windows
        wezterm.run_child_process({ 'explorer.exe', path })
      end
    end
  end)
  
  -- Agregar shortcut para abrir explorador
  table.insert(config.keys or {}, {
    key = 'e',
    mods = 'CTRL|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      wezterm.emit('open-in-explorer', window, pane)
    end),
  })
  
  -- =====================================
  -- CONFIGURACIÓN DE PROXY (SI ES NECESARIO)
  -- =====================================
  
  -- Descomenta y configura si trabajas detrás de un proxy corporativo
  --
  -- config.http_proxy = 'http://proxy.empresa.com:8080'
  -- config.https_proxy = 'http://proxy.empresa.com:8080'
  --
  
  -- =====================================
  -- CONFIGURACIÓN DE SPAWNING
  -- =====================================
  
  -- Configurar comportamiento al crear nuevas ventanas/tabs
  config.default_domain = 'local'
  
  -- Configurar el directorio de trabajo inicial
  local user_profile = os.getenv('USERPROFILE')
  if user_profile then
    config.default_cwd = user_profile
  end
  
  -- =====================================
  -- CONFIGURACIÓN DE NOTIFICACIONES
  -- =====================================
  
  -- Configurar notificaciones de Windows
  config.window_background_opacity = 0.95
  config.win32_system_backdrop = 'Acrylic' -- Efecto moderno de Windows 11
  
  -- =====================================
  -- HOTKEYS ESPECÍFICOS DE WINDOWS
  -- =====================================
  
  local windows_keys = {
    -- Abrir menú de shells
    {
      key = 's',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.ShowLauncher,
    },
    
    -- Abrir directorio actual en VS Code
    {
      key = 'c',
      mods = 'CTRL|ALT',
      action = wezterm.action_callback(function(window, pane)
        local cwd = pane:get_current_working_dir()
        if cwd then
          local path = cwd.file_path
          if path then
            wezterm.run_child_process({ 'code', path })
          end
        end
      end),
    },
    
    -- Restart WezTerm (útil durante desarrollo de configuración)
    {
      key = 'r',
      mods = 'CTRL|ALT',
      action = wezterm.action.ReloadConfiguration,
    },
  }
  
  -- Agregar las teclas específicas de Windows
  config.keys = config.keys or {}
  for _, key in ipairs(windows_keys) do
    table.insert(config.keys, key)
  end
  
  -- =====================================
  -- CONFIGURACIÓN DE LOGGING (PARA DEBUG)
  -- =====================================
  
  -- Habilitar logging para debugging (comentar en producción)
  -- config.log_unknown_escape_sequences = true
end

return M
 ]]
