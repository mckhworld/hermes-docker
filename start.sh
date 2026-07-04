#!/bin/bash
echo "========================================="
echo "Initializing Hermes Agent Isolated Sandbox..."
echo "========================================="

# Ensure data and host repos directories exist with current user permissions
mkdir -p ./hermes_data
mkdir -p ./workspace

# Start the docker containers
docker compose --env-file ./.env up -d

echo "========================================="
