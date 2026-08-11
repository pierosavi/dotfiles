# Dotfiles

Shared config for a Fedora desktop and a macOS laptop.
`mise` owns every tool, so there is no Brewfile and no dnf package list to keep in sync.

## Install

Run the steps in order. `mise` must exist before `chezmoi init`, because applying
the source runs `mise install`.

### Fedora

1. Prerequisites (`util-linux-user` provides `chsh`):

   ```sh
   sudo dnf install -y git curl zsh util-linux-user
   ```

2. Make Zsh the default shell, then **log out and back in**:

   ```sh
   chsh -s "$(command -v zsh)"
   ```

3. Install mise:

   ```sh
   curl -fsSL https://mise.run | sh
   ```

4. Install chezmoi and apply this repo:

   ```sh
   sh -c "$(curl -fsLS https://get.chezmoi.io/lb)" -- init --apply pierosavi
   ```

### macOS

Zsh is already the default shell, so there is no `chsh` step.

1. Command line tools (provides `git`):

   ```sh
   xcode-select --install
   ```

2. Homebrew — only for casks / GUI apps, no CLI tools:

   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. Install mise:

   ```sh
   curl -fsSL https://mise.run | sh
   ```

4. Install chezmoi and apply this repo:

   ```sh
   sh -c "$(curl -fsLS https://get.chezmoi.io/lb)" -- init --apply pierosavi
   ```

## Commands

### Add a tool

`mise-add <tool>` - `mise use -g` + syncs the chezmoi source.
Don't run `mise use -g` directly; chezmoi owns `config.toml` and will revert it.

#### Add local tool

`mise use -e local <tool>` - adds a local tool to `~/.config/mise/mise.local.toml`.

### Add a new file

`chezmoi add <file>`

## Folders

`~/.config/mise/mise.local.toml` for machine specific unsynced tools - https://mise.jdx.dev/registry.html to check available tools

## Why not ...?

### Linux Brew

Casks are unreliable and break unexpectedly on linux.

### Nix

Overkill
