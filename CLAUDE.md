# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository managed with GNU Stow. Each top-level directory represents a separate configuration package that can be independently installed using `stow [config dir]`.

## Installation

To install a configuration package:
```bash
stow [config dir]
```

For example, to install nvim configs: `stow nvim`

Stow creates symlinks from the package directory structure to the home directory. Files in `nvim/.config/nvim/` will be linked to `~/.config/nvim/`.

## Configuration Packages

- **nvim**: Neovim configuration with Lua-based setup
- **zsh**: Zsh shell configuration with Zim framework
- **git**: Git configuration files
- **kitty**: Kitty terminal emulator config
- **ghostty**: Ghostty terminal emulator config
- **bat**: Bat (cat alternative) configuration
- **idea**: IntelliJ IDEA configuration

## Neovim Configuration Architecture

The nvim config uses lazy.nvim for plugin management and is organized as follows:

### Key Structure

- `init.lua`: Entry point that bootstraps lazy.nvim and requires `gpetryk` module
- `lua/gpetryk/`: Core configuration modules
  - `init.lua`: Orchestrates plugin loading and autocommands
  - `lazy.lua`: Plugin specifications for lazy.nvim
  - `set.lua`: Vim options and settings
  - `keymaps.lua`: Key mappings
  - `commands.lua`: Custom commands
  - `abbrev.lua`: Abbreviations
  - `autosave.lua`: Auto-save functionality
- `lua/plugins/`: Plugin-specific configurations (colors, telescope, lsp, etc.)
- `lua/specs/`: Additional plugin specs
- `after/`: Filetype-specific configurations
- `ftplugin/`: Language-specific settings
- `queries/`: Tree-sitter query overrides
- `nvim/plugins/`: Local plugin development directory with git submodules

### Plugin Management

- Uses lazy.nvim with lazy loading for most plugins
- Plugin specs are split between `lua/gpetryk/lazy.lua` (main plugins) and `lua/specs/` (specialized configs)
- Custom/forked plugins are developed in `nvim/plugins/` as git submodules and loaded via `dev.path`
- Lock file is stored at `.lazy-lock.json` in the nvim config directory

### Python Environment

The nvim config directory contains its own Python environment (`.venv/`) managed by uv:
- `pyproject.toml`: Declares neovim Python package dependency
- `uv.lock`: Locked dependencies
- Required for Neovim's Python provider

To update the Python environment:
```bash
cd nvim/.config/nvim
uv sync
```

## Zsh Configuration

Uses the Zim framework for plugin management with:
- `.zimrc`: Zim module configuration (not in this repo, managed by Zim)
- `.zshrc`: Main zsh configuration
- `.p10k.zsh`: Powerlevel10k theme configuration
- `theme/`: Custom zsh theme files

Key features:
- Powerlevel10k prompt
- fzf integration with fd for file finding
- direnv integration
- fnm (Fast Node Manager) for Node.js version management
- uv shell completion

## Git Submodules

This repository uses git submodules for custom/forked nvim plugins in `nvim/plugins/`:
- rose-pine (custom color scheme fork)
- diagflow.nvim
- nvim-tree.lua
- nvim-java-test

To update submodules:
```bash
git submodule update --remote
```

## Important Notes

- When modifying nvim configs, understand that plugins load lazily based on events, filetypes, or keys
- The nvim config expects certain external tools: fd, fzf, ripgrep, tree-sitter CLI
- Stow will fail if target files already exist (not symlinks) - remove them first
