#!/usr/bin/env bash
# Bootstraps bb settings sync: installs the settings-sync plugin from
# github.com/pierosavi/bb-plugins. That plugin then syncs my other plugins and
# bb settings with every machine through github.com/pierosavi/bb-settings
# (see bb-plugin-settings-sync/README.md in bb-plugins).
# A settings-sync installed from a local path (the machine I develop it on) is
# left alone.
set -uo pipefail
export PATH="$HOME/.local/bin:$HOME/.bb/bin:$PATH"

REPO="git:https://github.com/pierosavi/bb-plugins.git@main"

if ! command -v bb >/dev/null 2>&1; then
  echo "bb-plugins: bb is not installed, skipping"
  exit 0
fi
if ! bb plugin list --json >/dev/null 2>&1; then
  echo "bb-plugins: bb server is not running, skipping"
  exit 0
fi

# The repo is private and bb clones it over HTTPS, so git needs GitHub
# credentials. Reuse the gh login through mise, which survives gh upgrades.
if [ -z "$(git config --global --get-all credential.https://github.com.helper)" ]; then
  git config --global credential.https://github.com.helper \
    "!$HOME/.local/bin/mise exec gh -- gh auth git-credential"
fi

if ! bb plugin source settings-sync --json >/dev/null 2>&1; then
  echo "bb-plugins: installing settings-sync"
  bb plugin install "$REPO" --subdirectory bb-plugin-settings-sync --yes >/dev/null ||
    echo "bb-plugins: settings-sync failed to install; run 'bb plugin list' for details" >&2
fi
exit 0
