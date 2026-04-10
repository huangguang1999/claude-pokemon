#!/usr/bin/env bash
# One-line installer for Claude Pokemon
# Usage: curl -fsSL https://raw.githubusercontent.com/huangguang1999/claude-pokemon/main/scripts/install.sh | bash

set -euo pipefail

REPO="huangguang1999/claude-pokemon"
APP_NAME="ClaudePokemon.app"
ZIP_NAME="ClaudePokemon.app.zip"
INSTALL_DIR="/Applications"
TMP_DIR=$(mktemp -d)

cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

echo "==> Claude Pokemon installer"

# Sanity checks
if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "Error: this installer only supports macOS." >&2
  exit 1
fi

# Fetch latest release asset URL
echo "==> Fetching latest release..."
ASSET_URL=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" \
  | grep -o "\"browser_download_url\": *\"[^\"]*${ZIP_NAME}\"" \
  | head -1 \
  | sed -E 's/.*"([^"]+)"$/\1/')

if [[ -z "${ASSET_URL}" ]]; then
  echo "Error: could not find ${ZIP_NAME} in latest release." >&2
  exit 1
fi

echo "==> Downloading ${ZIP_NAME}..."
curl -fsSL -o "${TMP_DIR}/${ZIP_NAME}" "${ASSET_URL}"

echo "==> Extracting..."
ditto -x -k "${TMP_DIR}/${ZIP_NAME}" "${TMP_DIR}/"

if [[ ! -d "${TMP_DIR}/${APP_NAME}" ]]; then
  echo "Error: ${APP_NAME} not found in archive." >&2
  exit 1
fi

# Strip quarantine attribute so Gatekeeper allows the ad-hoc signed app
xattr -dr com.apple.quarantine "${TMP_DIR}/${APP_NAME}" 2>/dev/null || true

# Close any running instance
pkill -f "${APP_NAME}" 2>/dev/null || true

echo "==> Installing to ${INSTALL_DIR}..."
rm -rf "${INSTALL_DIR}/${APP_NAME}"
ditto "${TMP_DIR}/${APP_NAME}" "${INSTALL_DIR}/${APP_NAME}"

echo "==> Launching..."
open "${INSTALL_DIR}/${APP_NAME}"

echo ""
echo "✅ Installed. Look for the Pokemon in your notch."
echo "   To uninstall: rm -rf '${INSTALL_DIR}/${APP_NAME}'"
