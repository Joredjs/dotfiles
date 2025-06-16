# 🚀 Dotfiles

> Cross-platform development configuration with auto-setup, health monitoring, and zero manual configuration.

![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macos%20%7C%20windows-blue)
![Shell](https://img.shields.io/badge/shell-bash-green)
![License](https://img.shields.io/badge/license-MIT-orange)
![Version](https://img.shields.io/badge/version-3.0-brightgreen)

## ✨ Features

- 🎯 **Zero Configuration**: Auto-detects paths and settings during installation
- 🖥️ **Cross-Platform**: Linux, macOS, Windows (Git Bash/WSL)
- 🔗 **Smart Symlinks**: Updates automatically with `git pull`
- 🎨 **Themeable**: Multiple prompt themes and color schemes
- 📁 **XDG Compliant**: Uses `~/.config` for modern organization
- 🔒 **Safe Installation**: Automatic backups with rollback capability
- 🏥 **Health Monitoring**: Built-in diagnostics and auto-repair
- 🔄 **Easy Updates**: One-command updates with conflict detection
- 🛠️ **Extensible**: Modular design for easy customization

## 🚀 Quick Start

```bash
# Clone repository
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Auto-install with wizard
./install.sh

# Check health
dotfiles-doctor

# Get help
f1
```

## 📋 Requirements

- **Essential**: Git, Bash 4.0+
- **Recommended**: curl, modern terminal with 256-color support

**Platform-specific recommendations:**

- **Linux**: `sudo apt install git curl` (Debian/Ubuntu)
- **macOS**: Install [Homebrew](https://brew.sh/) first
- **Windows**: Install [Scoop](https://scoop.sh/) or use Git Bash

## 🎯 Installation Options

The installer provides multiple modes:

1. **Full Installation** (recommended) - Everything included
2. **Home Dotfiles Only** - Basic shell configuration
3. **Config Files Only** - XDG config directory setup
4. **Work Structure Only** - Directory organization
5. **Dependencies Only** - Install required tools

**Advanced options:**

```bash
./install.sh --dry-run          # Preview changes
./install.sh --health-check     # Verify existing setup
./install.sh --uninstall        # Remove and restore backups
```

**Environment variables:**

```bash
DOTFILES_SKIP_WIZARD=1    # Skip configuration wizard
DOTFILES_AUTO_YES=1       # Auto-answer yes to prompts
```

## 📁 Structure

```
~/.dotfiles/
├── install.sh                    # ✨ Smart installer with wizard
├── config/
│   ├── dotfiles.conf.template    # Configuration template
│   ├── bash/                     # Modular bash configuration
│   │   ├── colors.bash           # ✨ Theme system & colors
│   │   ├── aliases.bash          # Command shortcuts
│   │   ├── functions.bash        # Useful functions
│   │   ├── prompt.bash           # ✨ Customizable prompts
│   │   └── help.bash            # Integrated help system
│   ├── git/                     # Git configuration
│   └── wezterm/                 # ✨ Terminal configuration
├── home/                        # Files for ~/
│   ├── .bashrc                  # Main shell config
│   ├── .inputrc                 # ✨ Enhanced bash editing
│   └── .gitconfig              # Git settings
└── bin/                         # ✨ Management scripts
    ├── dotfiles-update          # Update from git
    └── dotfiles-doctor          # Health check & diagnostics
```

## ⚙️ Configuration

### Auto-Configuration

The installer wizard automatically:

- Detects your OS and environment
- Finds editors and tools
- Sets up directory structure
- Configures Git if requested

### Manual Customization

Create `config/bash/local.bash` for machine-specific settings:

```bash
# Private configurations (ignored by git)
export SECRET_API_KEY="your_key_here"
export CUSTOM_PATH="/opt/special/bin"

# Override theme
export DOTFILES_THEME="dark"
export PROMPT_STYLE="fancy"
```

### Available Themes

- `default` - Balanced colors and info
- `minimal` - Clean, simple appearance  
- `dark` - High contrast for dark terminals
- `light` - Optimized for light terminals
- `fancy` - Rich colors with extra symbols

## 🔧 Daily Usage

### Quick Commands

```bash
f1              # Show help system
f1 -a           # List all aliases
f1 -f           # Show functions
f1 -g           # Git help

# Navigation
home            # Go to personal directory
work            # Go to work directory  
dots            # Go to dotfiles config

# Git shortcuts
gs              # git status
gac "message"   # add all & commit
gacp "message"  # add, commit & push
gpp             # pull then push
```

### Maintenance

```bash
dotfiles-update          # Update from git repo
dotfiles-doctor          # Check system health
dotfiles-doctor --fix    # Auto-fix common issues

# Manual reload
f5              # or source ~/.bashrc
```

## 🏥 Health & Diagnostics

The built-in health system monitors:

- ✅ Symlink integrity
- ✅ Configuration syntax
- ✅ Directory structure
- ✅ Git configuration
- ✅ PATH and executables
- ✅ File permissions
- ✅ Environment variables

**Example health check:**

```bash
$ dotfiles-doctor
╔═══════════════════════════════════════╗
║           DOTFILES DOCTOR             ║
╚═══════════════════════════════════════╝

[✓] .bashrc correctly linked
[✓] Git configuration valid
[⚠] Optional tool 'eza' not installed
[✗] Broken symlink: ~/.broken_link

Overall health: 85%
```

## 🔄 Updates & Maintenance

### Automatic Updates

```bash
dotfiles-update                    # Interactive update
dotfiles-update --check-only       # Check for updates only
dotfiles-update --force            # Update without prompts
```

### Version Migration

The system handles breaking changes automatically:

- Detects configuration format changes
- Prompts for manual review when needed
- Provides migration instructions

### Backup System

- Automatic backups before major changes
- Timestamped backup directories
- Easy rollback with `--uninstall`

## 🎨 Customization

### Adding New Features

1. **New aliases**: Edit `config/bash/aliases.bash`
2. **New functions**: Edit `config/bash/functions.bash`  
3. **New applications**: Create `config/myapp/` directory
4. **OS-specific**: Use `config/bash/linux.bash`, etc.

### Theme Development

Create custom themes by modifying color variables in `colors.bash`:

```bash
# Custom theme colors
export PS1_USER_COLOR="$CYAN"
export PS1_HOST_COLOR="$PURPLE"
export PS1_GIT_COLOR="$YELLOW"
```

## 🚨 Troubleshooting

### Common Issues

**Configuration errors:**

```bash
dotfiles-doctor --fix    # Auto-fix common problems
```

**Broken symlinks:**

```bash
# Remove and reinstall
rm ~/.bashrc
cd ~/.dotfiles && ./install.sh
```

**Git conflicts during update:**

```bash
cd ~/.dotfiles
git stash              # Save local changes
dotfiles-update        # Update dotfiles
git stash pop          # Restore changes
```

**Permission issues:**

```bash
# Fix script permissions
chmod +x ~/.local/bin/dotfiles-*
```

### Getting Help

1. Run `f1` for integrated help
2. Use `dotfiles-doctor` for diagnostics  
3. Check `~/.dotfiles_backup/` for recent backups
4. Review logs in installation output

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Test with `dotfiles-doctor`
4. Commit changes: `git commit -m 'Add amazing feature'`
5. Push: `git push origin feature/amazing-feature`
6. Open Pull Request

### Development

```bash
# Test installation
./install.sh --dry-run

# Run health checks
dotfiles-doctor

# Test on clean environment
docker run -it --rm ubuntu:latest bash
```

## 🗺️ Roadmap

- [ ] Zsh support alongside Bash
- [ ] Package manager integration (brew, apt, scoop)
- [ ] IDE configuration sync (VSCode, Neovim)
- [ ] Cloud backup integration
- [ ] Team configuration sharing
- [ ] Plugin system for community extensions

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

## 🙏 Acknowledgments

Inspired by the dotfiles community:

- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
- [holman/dotfiles](https://github.com/holman/dotfiles)  
- [thoughtbot/dotfiles](https://github.com/thoughtbot/dotfiles)

---

⭐ **Star this repo if it helps you!** | 🐛 **Issues welcome** | 💡 **Ideas appreciated**
