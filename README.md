# Dotfiles

Personal configuration files, managed with [dotbot](https://github.com/anishathalye/dotbot).

## Prerequisites

- Git
- Zsh

## Installation

```bash
git clone git@github.com:napanee/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
git submodule update --init --recursive
./dotbot/bin/dotbot -d . -c ./install.config.yml
```

## Updating submodules

```bash
git submodule update --remote
```

Then commit the changes:

```bash
git add .oh-my-zsh .powerlevel10k dotbot
git commit -m "Update submodules"
```

Important: Do not use `--recursive` with `--remote`. This would pull sub-submodules (e.g. `dotbot/lib/pyyaml`) to a commit the parent repo doesn't expect, leaving the submodule in a "dirty" state that cannot be staged.

## Included submodules

| Submodule | Description |
|-----------|-------------|
| [dotbot](https://github.com/anishathalye/dotbot) | Dotfiles installer framework |
| [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) | Zsh framework |
| [powerlevel10k](https://github.com/romkatv/powerlevel10k) | Zsh theme |

## Structure

dotbot symlinks configuration files into the home directory. The mapping is defined in `install.config.yml`. Platform-specific links (macOS/Linux) are applied automatically based on `uname`.
