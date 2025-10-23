#!/bin/bash

# Simple WordPress Docker Setup
# Usage: ./setup.sh

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

log() { echo -e "${GREEN}[INFO]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

log "Setting up WordPress Docker environment..."

# Check Docker
if ! command -v docker &> /dev/null; then
    error "Docker not found. Please install Docker Desktop"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    error "Docker Compose not found. Please install Docker Compose"
    exit 1
fi

# Create .env if not exists
if [ ! -f .env ]; then
    log "Creating .env file..."
    cp environment.env .env
    log "Please edit .env file with your settings"
fi

# Start services
log "Starting WordPress services..."
docker-compose up -d

log "WordPress is starting up..."
log "WordPress: http://localhost:8080"
log "phpMyAdmin: http://localhost:8081"
log "Admin: http://localhost:8080/wp-admin"

log "Setup complete!"