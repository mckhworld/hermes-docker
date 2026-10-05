#!/bin/bash
# gws-sync.sh — sync the host's gws OAuth credentials into the container's config dir.
#
# WHY: the container's gws cannot do interactive browser OAuth (no browser) and
# cannot read the host's macOS-keychain-encrypted credentials (no keyring in a
# Linux container). So we export the host's *decrypted* credentials into the
# shared volume the container mounts as /opt/data
# (GOOGLE_WORKSPACE_CLI_CONFIG_DIR=/opt/data/home/.config/gws in docker-compose.yml).
#
# WHEN TO RUN: on the HOST, after `gws auth login`, or whenever the container's
# gws starts failing with an auth error. While the OAuth app is in "Testing"
# mode the refresh token dies every 7 days, so expect to re-run this weekly.
# (Move the app to "In production" in the Cloud Console to stop the 7-day expiry.)
#
# No container restart is needed: gws re-reads credentials.json on each command,
# so the next gws call in the container picks up the fresh refresh token.
set -euo pipefail
cd "$(dirname "$0")"

HOST_GWS_DIR="${HOME}/.config/gws"
CONTAINER_GWS_DIR="hermes_data/home/.config/gws"

command -v gws >/dev/null 2>&1 || { echo "ERROR: gws not found on host PATH"; exit 1; }
[ -d "$HOST_GWS_DIR" ] || { echo "ERROR: host gws config dir not found: $HOST_GWS_DIR — run 'gws auth login' first"; exit 1; }

mkdir -p "$CONTAINER_GWS_DIR"

# 1) Decrypted credentials: refresh token + current OAuth client (client_id/secret).
#    'gws auth export' writes JSON to stdout; the "keyring backend" notice goes to
#    stderr, so the redirect captures clean JSON.
gws auth export --unmasked > "$CONTAINER_GWS_DIR/credentials.json"

# 2) OAuth client config (client_id + project_id). Must match the client the
#    refresh token was issued for, or the token exchange fails.
cp "$HOST_GWS_DIR/client_secret.json" "$CONTAINER_GWS_DIR/client_secret.json"

# Restrict to owner — these hold a live refresh token and the client secret.
chmod 600 "$CONTAINER_GWS_DIR/credentials.json" "$CONTAINER_GWS_DIR/client_secret.json"

echo "Synced gws credentials into $CONTAINER_GWS_DIR"
echo "Verify inside the container:"
docker compose exec -T hermes-agent gws auth status 2>/dev/null \
  | grep -E '"token_valid"|"token_error"' || echo "  (could not query container — is it running?)"
