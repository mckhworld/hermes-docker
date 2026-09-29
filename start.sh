#!/bin/bash
echo "========================================="
echo "Initializing Hermes Agent Isolated Sandbox..."
echo "========================================="

# Ensure data and host repos directories exist with current user permissions
mkdir -p ./hermes_data
mkdir -p ./workspace

# Container file ownership: match host user so files are readable/writable on host
export HERMES_UID=$(id -u)
export HERMES_GID=$(id -g)

# Build image if Dockerfile/context changed, then start containers
docker compose --env-file ./.env up --build -d

echo "========================================="
