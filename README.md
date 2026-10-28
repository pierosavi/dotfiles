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

### Update the fonts

Monaspace (Nerd Font build, all five families) is an external in `.chezmoiexternal.toml.tmpl`, pinned to a release. It has no `refreshPeriod` because a pinned URL never changes — bump the version by editing the URL.

### bb plugins

`.chezmoiscripts/run_after_20_bb-plugins.sh` installs or updates my bb plugins from
[pierosavi/bb-plugins](https://github.com/pierosavi/bb-plugins) on every apply, so
`chezmoi update` keeps them in sync. It needs bb running and `gh auth login` done.
Plugins installed from a local path (the Mac, where I develop them) are skipped.
To add a plugin, add its name to `PLUGINS` in the script.

## Folders

`~/.config/mise/mise.local.toml` for machine specific unsynced tools - https://mise.jdx.dev/registry.html to check available tools

## Why not ...?

### Linux Brew

Casks are unreliable and break unexpectedly on linux.

### Nix

Overkill

### dnf / brew for CLI tools

`lazygit`, `bat`, `ripgrep`, `fd`, `zoxide` and friends are static binaries from GitHub releases with no system integration. Splitting them out would mean a Brewfile *and* a dnf list *and* the drift between them.

The boundary: **dnf/brew owns what's needed to get the shell running, mise owns what's used inside it.**
