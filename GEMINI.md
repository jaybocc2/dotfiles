# Dotfiles Project Overview

This repository contains personal configuration files (dotfiles) for various tools, including Zsh, Neovim, Tmux, Git, and more. It is designed to be portable across macOS (Darwin) and Linux (Debian-based distributions).

## Core Technologies
- **Shell:** Zsh with [Oh My Zsh](https://ohmyz.sh/), [ys theme](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes#ys), and several plugins (`gh`, `git`, `vi-mode`, `pyenv`, `nodenv`, `asdf`, `poetry`).
- **Editor:** Neovim configured using [LazyVim](https://www.lazyvim.org/) and [lazy.nvim](https://github.com/folke/lazy.nvim).
- **Terminal Multiplexer:** Tmux with platform-specific configurations (`tmux/Darwin.conf` and `tmux/Linux.conf`).
- **Tool Managers:** Supports `pyenv`, `nodenv`, `rbenv`, `goenv`, `tfenv`, and `rustup`.
- **Package Managers:** Homebrew (macOS) and `apt` (Linux).

## Directory Structure
- `bin/`: Custom scripts and binaries.
- `nvim/`: Neovim configuration (`init.lua`, `lua/config/`, `lua/plugins/`).
- `shlibs/`: Shell libraries for installation, logging, and environment detection.
- `tmux/`: Tmux configurations, including OS-specific overrides.
- `zsh/`: Zsh environment, aliases, functions, and SSH agent setup.
- `install.sh`: The main installation script for dependencies and configuration linking.

## Building and Running

### Installation
The primary entry point for setting up the environment is `install.sh`.

```bash
# General installation (deps + config)
./install.sh install

# Only install configurations (symlinking)
./install.sh config

# Fast installation (skips some prompts)
./install.sh fast-install

# Install only Neovim and its dependencies
./install.sh install-neovim
```

The `install.sh` script performs the following actions:
1. Installs system-level dependencies via Homebrew or `apt`.
2. Sets up tool version managers (`pyenv`, `nodenv`, etc.).
3. Installs Rust, Neovim, and various CLI tools (`ripgrep`, `fd`, `gh`).
4. Symlinks configuration files from the repository to the home directory (e.g., `~/.zshrc`, `~/.tmux.conf`, `~/.config/nvim`).

### Maintenance
- **Purge configurations:** `./install.sh purge` removes the symlinks created by the installer.
- **Update Neovim:** The installer includes a `compile_neovim` function for Linux environments to build from source.

## Development Conventions

- **Shell Scripting:** Shared logic is modularized in `shlibs/`. Use `shlibs/logging.sh` for output and `shlibs/os.sh` for platform detection.
- **Neovim Configuration:** Follows the `LazyVim` structure. Custom plugins should be added to `nvim/lua/plugins/`, and core configurations to `nvim/lua/config/`.
- **Environment Variables:** Managed in `zsh/env.zsh`. Paths and tool initializations should be added there to ensure they are available in the shell.
- **Aliases:** Custom aliases are located in `zsh/aliases.zsh`.
