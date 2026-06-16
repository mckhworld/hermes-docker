#!/bin/bash
echo "========================================="
echo "Initializing Hermes Agent Isolated Sandbox..."
echo "========================================="

# Ensure data and host repos directories exist with current user permissions
mkdir -p ./hermes_data
mkdir -p ./repos

# Start the docker containers
docker compose up -d

echo "========================================="
echo "Hermes Agent has been started successfully!"
echo "The './repos' folder is mounted with Write Access."
echo "========================================="
