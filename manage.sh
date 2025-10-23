#!/bin/bash

# Simple WordPress Multi-Site Manager
# Usage: ./manage.sh [create|start|stop|list] [site_name]

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if port is available
check_port() {
    ! lsof -Pi :$1 -sTCP:LISTEN -t >/dev/null 2>&1
}

# Create a new site
create_site() {
    local site_name=$1
    local port=$2
    
    if [ -d "$site_name" ]; then
        error "Site '$site_name' already exists"
        return 1
    fi
    
    log "Creating site: $site_name"
    
    # Clone boilerplate
    git clone . "$site_name" 2>/dev/null || {
        error "Failed to clone. Run from boilerplate directory"
        return 1
    }
    
    # Configure site
    cd "$site_name"
    cp environment.env .env
    
    # Generate unique passwords
    local db_password=$(openssl rand -hex 8)
    local root_password=$(openssl rand -hex 8)
    
    # Update ports and database
    sed -i.bak "s/WORDPRESS_PORT=8080/WORDPRESS_PORT=$port/" .env
    sed -i.bak "s/PHPMYADMIN_PORT=8081/PHPMYADMIN_PORT/$((port+1))/" .env
    sed -i.bak "s/MYSQL_DATABASE=wordpress_db/MYSQL_DATABASE=wp_${site_name}_db/" .env
    sed -i.bak "s/MYSQL_USER=wordpress_user/MYSQL_USER=wp_${site_name}_user/" .env
    sed -i.bak "s/MYSQL_PASSWORD=change_this_password/MYSQL_PASSWORD=$db_password/" .env
    sed -i.bak "s/MYSQL_ROOT_PASSWORD=change_this_root_password/MYSQL_ROOT_PASSWORD=$root_password/" .env
    
    rm .env.bak
    cd ..
    
    log "Site '$site_name' created at http://localhost:$port"
}

# Start a site
start_site() {
    local site_name=$1
    
    if [ ! -d "$site_name" ]; then
        error "Site '$site_name' not found"
        return 1
    fi
    
    log "Starting site: $site_name"
    cd "$site_name"
    export COMPOSE_PROJECT_NAME="$site_name"
    docker-compose -p "$site_name" up -d
    cd ..
    log "Site '$site_name' started"
}

# Stop a site
stop_site() {
    local site_name=$1
    
    if [ ! -d "$site_name" ]; then
        error "Site '$site_name' not found"
        return 1
    fi
    
    log "Stopping site: $site_name"
    cd "$site_name"
    export COMPOSE_PROJECT_NAME="$site_name"
    docker-compose -p "$site_name" down
    cd ..
    log "Site '$site_name' stopped"
}

# Clean up a site
cleanup_site() {
    local site_name=$1
    
    if [ ! -d "$site_name" ]; then
        error "Site '$site_name' not found"
        return 1
    fi
    
    log "Cleaning up site: $site_name"
    
    # Stop and remove containers
    cd "$site_name"
    export COMPOSE_PROJECT_NAME="$site_name"
    docker-compose -p "$site_name" down -v 2>/dev/null || true
    
    # Remove volumes
    docker volume rm "${site_name}_wordpress_data" 2>/dev/null || true
    docker volume rm "${site_name}_mysql_data" 2>/dev/null || true
    
    cd ..
    
    # Remove directory
    rm -rf "$site_name"
    
    log "Site '$site_name' cleaned up completely"
}

# List all sites
list_sites() {
    log "Available sites:"
    for dir in */; do
        if [ -d "$dir" ] && [ -f "$dir/docker-compose.yml" ]; then
            local site_name=${dir%/}
            local status="Stopped"
            
            if docker ps --format "{{.Names}}" | grep -q "${site_name}_"; then
                status="Running"
            fi
            
            if [ -f "$dir/.env" ]; then
                local port=$(grep WORDPRESS_PORT "$dir/.env" | cut -d'=' -f2 2>/dev/null || echo "N/A")
                echo "  $site_name - $status - Port: $port"
            else
                echo "  $site_name - $status"
            fi
        fi
    done
}

# Main script logic
case "$1" in
    "create")
        if [ -z "$2" ]; then
            error "Usage: $0 create <site_name>"
            exit 1
        fi
        
        # Find available port
        port=8080
        while ! check_port $port; do
            ((port++))
        done
        
        create_site "$2" $port
        ;;
        
    "start")
        if [ -z "$2" ]; then
            error "Usage: $0 start <site_name>"
            exit 1
        fi
        start_site "$2"
        ;;
        
    "stop")
        if [ -z "$2" ]; then
            error "Usage: $0 stop <site_name>"
            exit 1
        fi
        stop_site "$2"
        ;;
        
    "list")
        list_sites
        ;;
        
    "cleanup")
        if [ -z "$2" ]; then
            error "Usage: $0 cleanup <site_name>"
            exit 1
        fi
        cleanup_site "$2"
        ;;
        
    *)
        echo "WordPress Multi-Site Manager"
        echo "Usage: $0 [create|start|stop|list|cleanup] [site_name]"
        echo ""
        echo "Commands:"
        echo "  create <name>   Create a new site"
        echo "  start <name>    Start a site"
        echo "  stop <name>     Stop a site"
        echo "  cleanup <name>  Remove a site completely"
        echo "  list            List all sites"
        ;;
esac
