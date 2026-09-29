#!/bin/bash
echo "========================================="
echo "Initializing Hermes Agent Isolated Sandbox..."
echo "========================================="

# Ensure data and host repos directories exist with current user permissions
mkdir -p ./hermes_data
mkdir -p ./workspace

# Container file ownership: match the host user so files written in the
# container stay readable/writable on the host. Pre-set HERMES_UID/GID in
# the environment (e.g. NAS PUID/PGID) to override the derived values.
export HERMES_UID="${HERMES_UID:-$(id -u)}"
export HERMES_GID="${HERMES_GID:-$(id -g)}"

# Build image if Dockerfile/context changed, then start containers.
# Note: --build re-evaluates the floating base tag nousresearch/hermes-agent:main,
# so upstream :main changes (or a registry outage) affect plain startup.
docker compose --env-file ./.env up --build -d

echo "========================================="
