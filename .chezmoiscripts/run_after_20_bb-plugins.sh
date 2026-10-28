#!/usr/bin/env bash
# Installs or updates my bb plugins from github.com/pierosavi/bb-plugins.
# Runs on every apply, so `chezmoi update` pulls the latest plugins too.
# Plugins installed from a local path (the machine I develop them on) are left alone.
set -uo pipefail
export PATH="$HOME/.local/bin:$HOME/.bb/bin:$PATH"

REPO="git:https://github.com/pierosavi/bb-plugins.git@main"
PLUGINS=(
  archive-confetti
  archive-on-merge
  branch-switcher
  copilot-steer-guard
  inbound-queue
  md-list-continue
  pr-row-status
  report-back
  shared-checkout
  title-guard
)

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

failed=0
for id in "${PLUGINS[@]}"; do
  if ! source=$(bb plugin source "$id" --json 2>/dev/null); then
    echo "bb-plugins: installing $id"
    bb plugin install "$REPO" --subdirectory "bb-plugin-$id" --yes >/dev/null || failed=1
  elif grep -q '"resolved": "path:' <<<"$source"; then
    continue
  else
    bb plugin update "$id" --yes >/dev/null || failed=1
  fi
done

if [ "$failed" -ne 0 ]; then
  echo "bb-plugins: some plugins failed; run 'bb plugin list' for details" >&2
fi
exit 0
