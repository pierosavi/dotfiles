# Dotfiles

## Commands

### Init and apply

`sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply pierosavi`

### Add a tool

`mise-add <tool>` — `mise use -g` + syncs the chezmoi source.
Don't run `mise use -g` directly; chezmoi owns `config.toml` and will revert it.

### Update

`chezmoi update`

### Add a new file

`chezmoi add <file>`

## Folders

`~/.config/mise/config.local.toml` for machine specific unsynced tools - https://mise.jdx.dev/registry.html to check available tools

## Why not ...?

### Linux Brew

Casks are unreliable and break unexpectedly on linux.

### Nix

Overkill