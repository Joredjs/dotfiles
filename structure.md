# Suggested structure

dotfiles/
├── install.sh              # Script de instalación principal
├── README.md              # Documentación mejorada
├── .gitignore             # Ignorar archivos sensibles
├── Makefile               # Comandos de instalación alternativos
│
├── config/                # Configuraciones para ~/.config (XDG)
│   ├── dotfiles.conf      # Configuración centralizada
│   ├── bash/              # Configuración modular de bash
│   │   ├── aliases.bash
│   │   ├── colors.bash
│   │   ├── functions.bash
│   │   ├── prompt.bash
│   │   └── help.bash
│   ├── git/               # Configuración de git
│   │   └── config
│   ├── wezterm/           # Tu configuración de wezterm
│   │   └── wezterm.lua
│   └── nvim/              # Ejemplo: configuración de neovim
│       └── init.lua
│
├── home/                  # Archivos que van en ~
│   ├── .bashrc
│   ├── .bash_profile
│   ├── .inputrc
│   └── .editorconfig
│
├── bin/                   # Scripts ejecutables personales
│   └── dotfiles-update
│
├── templates/             # Templates para diferentes OS/entornos
│   ├── .bashrc.linux
│   ├── .bashrc.macos
│   └── .bashrc.windows
│
└── docs/                  # Documentación adicional
    ├── INSTALL.md
    └── CUSTOMIZATION.md