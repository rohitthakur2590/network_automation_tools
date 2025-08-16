#!/bin/bash

# Select container engine: podman or docker
ENGINE="podman"  # Change to "docker" if you use Docker

echo "🧹 Cleaning up dangling images..."
$ENGINE images -f "dangling=true" -q | xargs -r $ENGINE rmi -f

echo "🧹 Cleaning up custom EE builds with prefix 'nvc_'..."
$ENGINE images | grep 'nvc_' | awk '{print $3}' | xargs -r $ENGINE rmi -f

echo "🧹 Cleaning up demo/camp EE builds (cfgmgmtcamp25_)..."
$ENGINE images | grep 'cfgmgmtcamp25_' | awk '{print $3}' | xargs -r $ENGINE rmi -f

echo "🧹 Cleaning up network_operation_experience* images..."
$ENGINE images | grep 'network_operation_experience' | awk '{print $3}' | xargs -r $ENGINE rmi -f

echo "✅ Image cleanup completed."

