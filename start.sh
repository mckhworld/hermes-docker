#!/bin/bash
echo "========================================="
echo "Initializing Hermes Agent Isolated Sandbox..."
echo "========================================="

# Ensure data and host repos directories exist with current user permissions
mkdir -p ./hermes_data

# Start the docker containers
docker compose up -d

echo "========================================="
