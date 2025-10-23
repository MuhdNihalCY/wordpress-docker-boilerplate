#!/bin/bash

# Simple WordPress Docker Setup
# Usage: ./setup.sh

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[INFO]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

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

# Check port availability and find alternative if needed
check_port() {
    # Check if port is available for binding
    ! lsof -Pi :$1 -sTCP:LISTEN -t >/dev/null 2>&1
}

# Check if Docker port is already bound
check_docker_port() {
    ! docker ps --format "table {{.Ports}}" | grep -q ":$1->" 2>/dev/null
}

# Find available ports
find_available_ports() {
    local wp_port=8080
    local phpmyadmin_port=8081
    
    # Find available WordPress port (check both system and Docker)
    while ! check_port $wp_port || ! check_docker_port $wp_port; do
        ((wp_port++))
    done
    
    # Find available phpMyAdmin port (should be different from WordPress port)
    phpmyadmin_port=$((wp_port + 1))
    while ! check_port $phpmyadmin_port || ! check_docker_port $phpmyadmin_port; do
        ((phpmyadmin_port++))
    done
    
    echo "$wp_port $phpmyadmin_port"
}

# Get ports from .env or find available ones
if [ -f .env ]; then
    wp_port=$(grep WORDPRESS_PORT .env | cut -d'=' -f2 2>/dev/null || echo "8080")
    phpmyadmin_port=$(grep PHPMYADMIN_PORT .env | cut -d'=' -f2 2>/dev/null || echo "8081")
    
    # Check if ports are available, if not find alternatives
    if ! check_port $wp_port || ! check_port $phpmyadmin_port || ! check_docker_port $wp_port || ! check_docker_port $phpmyadmin_port; then
        log "Ports in .env are not available (system or Docker conflict), finding alternatives..."
        read wp_port phpmyadmin_port <<< $(find_available_ports)
        
        # Update .env with new ports
        sed -i.bak "s/WORDPRESS_PORT=.*/WORDPRESS_PORT=$wp_port/" .env
        sed -i.bak "s/PHPMYADMIN_PORT=.*/PHPMYADMIN_PORT=$phpmyadmin_port/" .env
        rm .env.bak
        
        log "Updated ports: WordPress=$wp_port, phpMyAdmin=$phpmyadmin_port"
    fi
else
    # Find available ports for new .env
    read wp_port phpmyadmin_port <<< $(find_available_ports)
fi

# Create .env if not exists
if [ ! -f .env ]; then
    log "Creating .env file..."
    cp environment.env .env
    
    # Update .env with available ports
    sed -i.bak "s/WORDPRESS_PORT=8080/WORDPRESS_PORT=$wp_port/" .env
    sed -i.bak "s/PHPMYADMIN_PORT=8081/PHPMYADMIN_PORT=$phpmyadmin_port/" .env
    rm .env.bak
    
    log "Created .env with ports: WordPress=$wp_port, phpMyAdmin=$phpmyadmin_port"
fi

# Stop any existing containers that might conflict
log "Checking for existing containers..."
if docker-compose ps -q | grep -q .; then
    log "Stopping existing containers..."
    docker-compose down 2>/dev/null || true
fi

# Clean up any containers using the ports we want
log "Cleaning up conflicting containers..."
if [ -n "$wp_port" ] && [ "$wp_port" != "" ]; then
    docker ps -q --filter "publish=$wp_port" | xargs -r docker stop 2>/dev/null || true
fi
if [ -n "$phpmyadmin_port" ] && [ "$phpmyadmin_port" != "" ]; then
    docker ps -q --filter "publish=$phpmyadmin_port" | xargs -r docker stop 2>/dev/null || true
fi

# Export port variables for Docker Compose
export WORDPRESS_PORT=$wp_port
export PHPMYADMIN_PORT=$phpmyadmin_port

# Start services
log "Starting WordPress services..."
docker-compose up -d

# Wait for MySQL to be fully ready
log "Waiting for MySQL to initialize..."
wait_for_mysql() {
    local max_attempts=30
    local attempt=1
    local mysql_root_password=$(grep MYSQL_ROOT_PASSWORD .env | cut -d'=' -f2 2>/dev/null || echo "change_this_root_password")
    
    while [ $attempt -le $max_attempts ]; do
        if docker-compose exec -T mysql mysqladmin ping -h localhost -u root -p"$mysql_root_password" --silent 2>/dev/null; then
            log "✅ MySQL is ready!"
            return 0
        fi
        
        log "MySQL not ready yet (attempt $attempt/$max_attempts)..."
        sleep 2
        ((attempt++))
    done
    
    error "MySQL failed to start after $max_attempts attempts"
    return 1
}

# Wait for MySQL
if ! wait_for_mysql; then
    error "Failed to start MySQL. Check logs: docker-compose logs mysql"
    exit 1
fi

# Wait for WordPress to connect to database
log "Waiting for WordPress to connect to database..."
wait_for_wordpress_db() {
    local max_attempts=20
    local attempt=1
    local mysql_user=$(grep MYSQL_USER .env | cut -d'=' -f2 2>/dev/null || echo "wordpress_user")
    local mysql_password=$(grep MYSQL_PASSWORD .env | cut -d'=' -f2 2>/dev/null || echo "change_this_password")
    local mysql_database=$(grep MYSQL_DATABASE .env | cut -d'=' -f2 2>/dev/null || echo "wordpress_db")
    
    while [ $attempt -le $max_attempts ]; do
        if docker-compose exec -T mysql mysql -u "$mysql_user" -p"$mysql_password" -e "USE $mysql_database;" 2>/dev/null; then
            log "✅ WordPress database connection successful!"
            return 0
        fi
        
        log "WordPress database not ready yet (attempt $attempt/$max_attempts)..."
        sleep 3
        ((attempt++))
    done
    
    warn "WordPress database connection may still be initializing..."
    return 1
}

wait_for_wordpress_db

# Verify services are running
if docker-compose ps | grep -q "Up"; then
    log "✅ Services started successfully!"
    log "WordPress: http://localhost:$wp_port"
    log "phpMyAdmin: http://localhost:$phpmyadmin_port"
    log "Admin: http://localhost:$wp_port/wp-admin"
    log ""
    
    # Check if WordPress is accessible
    log "Checking WordPress accessibility..."
    local wp_response=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:$wp_port")
    if echo "$wp_response" | grep -q "200\|302"; then
        log "✅ WordPress is accessible! (HTTP $wp_response)"
    else
        warn "⚠️  WordPress may still be initializing... (HTTP $wp_response)"
        log "   If you see database connection errors, wait 30-60 seconds"
        log "   for WordPress to complete its setup process."
        log "   You can check logs with: docker-compose logs wordpress"
    fi
    
    log ""
    log "🔧 Troubleshooting:"
    log "   - Database errors: docker-compose logs mysql"
    log "   - WordPress errors: docker-compose logs wordpress"
    log "   - All logs: docker-compose logs"
    log ""
    log "Setup complete!"
else
    error "Failed to start services. Check logs: docker-compose logs"
    exit 1
fi