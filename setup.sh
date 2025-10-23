#!/bin/bash

# WordPress Docker Setup with Comprehensive Error Handling
# Usage: ./setup.sh

set -euo pipefail

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging functions
log() { echo -e "${GREEN}[INFO]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
debug() { echo -e "${BLUE}[DEBUG]${NC} $1"; }

# Error handling
cleanup() {
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        error "Setup failed with exit code $exit_code"
        log "Cleaning up..."
        docker-compose down 2>/dev/null || true
        log "Cleanup complete. You can try running ./setup.sh again."
    fi
}

trap cleanup EXIT

# Check system requirements
check_system_requirements() {
    log "Checking system requirements..."
    
    # Check if running on supported OS
    if [[ "$OSTYPE" != "linux-gnu"* ]] && [[ "$OSTYPE" != "darwin"* ]]; then
        error "Unsupported operating system: $OSTYPE"
        error "This script supports Linux and macOS only."
        exit 1
    fi
    
    # Check available disk space (minimum 2GB)
    local available_space=$(df . | tail -1 | awk '{print $4}')
    if [ "$available_space" -lt 2097152 ]; then  # 2GB in KB
        error "Insufficient disk space. At least 2GB required."
        error "Available: $(($available_space / 1024 / 1024))GB"
        exit 1
    fi
    
    # Check available memory (minimum 1GB)
    if command -v free >/dev/null 2>&1; then
        local available_memory=$(free -m | awk 'NR==2{print $7}')
        if [ "$available_memory" -lt 1024 ]; then
            warn "Low memory warning: ${available_memory}MB available"
            warn "At least 1GB RAM recommended for optimal performance"
        fi
    fi
    
    log "✅ System requirements check passed"
}

# Check Docker installation and permissions
check_docker_installation() {
    log "Checking Docker installation..."
    
    # Check if Docker is installed
    if ! command -v docker &> /dev/null; then
        error "Docker not found. Please install Docker Desktop:"
        error "  - macOS: https://docs.docker.com/desktop/mac/install/"
        error "  - Linux: https://docs.docker.com/engine/install/"
        error "  - Windows: https://docs.docker.com/desktop/windows/install/"
        exit 1
    fi
    
    # Check if Docker is running
    if ! docker info >/dev/null 2>&1; then
        error "Docker is not running. Please start Docker Desktop."
        error "On Linux, you may need to start Docker service:"
        error "  sudo systemctl start docker"
        exit 1
    fi
    
    # Check Docker permissions
    if ! docker ps >/dev/null 2>&1; then
        error "Permission denied accessing Docker."
        error "On Linux, add your user to docker group:"
        error "  sudo usermod -aG docker $USER"
        error "  Then log out and log back in."
        exit 1
    fi
    
    # Check Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        error "Docker Compose not found. Please install Docker Compose:"
        error "  https://docs.docker.com/compose/install/"
        exit 1
    fi
    
    log "✅ Docker installation check passed"
}

# Check network connectivity
check_network_connectivity() {
    log "Checking network connectivity..."
    
    # Check internet connection
    if ! ping -c 1 8.8.8.8 >/dev/null 2>&1; then
        error "No internet connection detected."
        error "Please check your network connection and try again."
        exit 1
    fi
    
    # Check Docker Hub connectivity
    if ! curl -s --connect-timeout 10 https://hub.docker.com >/dev/null 2>&1; then
        warn "Cannot reach Docker Hub. Images may download slowly or fail."
        warn "Check your firewall and proxy settings."
    fi
    
    log "✅ Network connectivity check passed"
}

# Check file permissions
check_file_permissions() {
    log "Checking file permissions..."
    
    # Check if we can write to current directory
    if ! touch test_write_permission 2>/dev/null; then
        error "No write permission in current directory."
        error "Please run from a directory where you have write access."
        exit 1
    fi
    rm -f test_write_permission
    
    # Check if we can create .env file
    if ! touch .env.test 2>/dev/null; then
        error "Cannot create files in current directory."
        error "Please check directory permissions."
        exit 1
    fi
    rm -f .env.test
    
    log "✅ File permissions check passed"
}

log "Setting up WordPress Docker environment with comprehensive error handling..."

# Run all prerequisite checks
check_system_requirements
check_docker_installation
check_network_connectivity
check_file_permissions

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

# Start services with error handling
start_docker_services() {
    log "Starting WordPress services..."
    
    # Check if docker-compose.yml exists
    if [ ! -f "docker-compose.yml" ]; then
        error "docker-compose.yml not found in current directory."
        error "Please run this script from the WordPress Docker boilerplate directory."
        exit 1
    fi
    
    # Try to start services with retry mechanism
    local max_attempts=3
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        log "Starting services (attempt $attempt/$max_attempts)..."
        
        if docker-compose up -d; then
            log "✅ Services started successfully!"
            return 0
        else
            error "Failed to start services (attempt $attempt/$max_attempts)"
            
            if [ $attempt -lt $max_attempts ]; then
                log "Cleaning up and retrying..."
                docker-compose down 2>/dev/null || true
                sleep 5
            fi
            
            ((attempt++))
        fi
    done
    
    error "Failed to start services after $max_attempts attempts"
    error "Check logs: docker-compose logs"
    exit 1
}

start_docker_services

# Wait for MySQL to be fully ready with enhanced error handling
wait_for_mysql() {
    local max_attempts=30
    local attempt=1
    local mysql_root_password=$(grep MYSQL_ROOT_PASSWORD .env | cut -d'=' -f2 2>/dev/null || echo "change_this_root_password")
    
    log "Waiting for MySQL to initialize..."
    
    while [ $attempt -le $max_attempts ]; do
        # Check if MySQL container is running
        if ! docker-compose ps mysql | grep -q "Up"; then
            error "MySQL container is not running!"
            error "Check MySQL logs: docker-compose logs mysql"
            exit 1
        fi
        
        # Try to ping MySQL
        if docker-compose exec -T mysql mysqladmin ping -h localhost -u root -p"$mysql_root_password" --silent 2>/dev/null; then
            log "✅ MySQL is ready!"
            return 0
        fi
        
        log "MySQL not ready yet (attempt $attempt/$max_attempts)..."
        
        # Check for MySQL errors in logs
        if [ $attempt -eq 10 ]; then
            warn "MySQL is taking longer than expected to start."
            warn "Checking MySQL logs for errors..."
            docker-compose logs mysql | tail -20
        fi
        
        sleep 2
        ((attempt++))
    done
    
    error "MySQL failed to start after $max_attempts attempts"
    error "MySQL logs:"
    docker-compose logs mysql
    exit 1
}

# Wait for MySQL
if ! wait_for_mysql; then
    error "Failed to start MySQL. Check logs: docker-compose logs mysql"
    exit 1
fi

# Wait for WordPress to connect to database with enhanced error handling
wait_for_wordpress_db() {
    local max_attempts=20
    local attempt=1
    local mysql_user=$(grep MYSQL_USER .env | cut -d'=' -f2 2>/dev/null || echo "wordpress_user")
    local mysql_password=$(grep MYSQL_PASSWORD .env | cut -d'=' -f2 2>/dev/null || echo "change_this_password")
    local mysql_database=$(grep MYSQL_DATABASE .env | cut -d'=' -f2 2>/dev/null || echo "wordpress_db")
    
    log "Waiting for WordPress to connect to database..."
    
    while [ $attempt -le $max_attempts ]; do
        # Check if WordPress container is running
        if ! docker-compose ps wordpress | grep -q "Up"; then
            error "WordPress container is not running!"
            error "Check WordPress logs: docker-compose logs wordpress"
            exit 1
        fi
        
        # Try to connect to database
        if docker-compose exec -T mysql mysql -u "$mysql_user" -p"$mysql_password" -e "USE $mysql_database;" 2>/dev/null; then
            log "✅ WordPress database connection successful!"
            return 0
        fi
        
        log "WordPress database not ready yet (attempt $attempt/$max_attempts)..."
        
        # Check for database errors
        if [ $attempt -eq 10 ]; then
            warn "Database connection is taking longer than expected."
            warn "Checking if database and user exist..."
            
            # Check if database exists
            if ! docker-compose exec -T mysql mysql -u root -p"$mysql_root_password" -e "SHOW DATABASES LIKE '$mysql_database';" 2>/dev/null | grep -q "$mysql_database"; then
                error "Database '$mysql_database' does not exist!"
                error "This may indicate a MySQL initialization problem."
            fi
            
            # Check if user exists
            if ! docker-compose exec -T mysql mysql -u root -p"$mysql_root_password" -e "SELECT User FROM mysql.user WHERE User='$mysql_user';" 2>/dev/null | grep -q "$mysql_user"; then
                error "User '$mysql_user' does not exist!"
                error "This may indicate a MySQL initialization problem."
            fi
        fi
        
        sleep 3
        ((attempt++))
    done
    
    error "WordPress database connection failed after $max_attempts attempts"
    error "Database: $mysql_database"
    error "User: $mysql_user"
    error "Check MySQL logs: docker-compose logs mysql"
    exit 1
}

wait_for_wordpress_db

# Comprehensive service verification
verify_services() {
    log "Performing comprehensive service verification..."
    
    # Check if all containers are running
    local running_containers=$(docker-compose ps --services --filter "status=running" | wc -l)
    local total_containers=$(docker-compose ps --services | wc -l)
    
    if [ "$running_containers" -ne "$total_containers" ]; then
        error "Not all containers are running!"
        error "Running: $running_containers, Expected: $total_containers"
        docker-compose ps
        exit 1
    fi
    
    # Check WordPress accessibility with retry
    log "Checking WordPress accessibility..."
    local wp_response=""
    local max_attempts=5
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        wp_response=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:$wp_port" 2>/dev/null || echo "000")
        
        if echo "$wp_response" | grep -q "200\|302"; then
            log "✅ WordPress is accessible! (HTTP $wp_response)"
            break
        elif [ "$wp_response" = "000" ]; then
            warn "Cannot connect to WordPress (attempt $attempt/$max_attempts)"
        else
            warn "WordPress returned HTTP $wp_response (attempt $attempt/$max_attempts)"
        fi
        
        if [ $attempt -lt $max_attempts ]; then
            sleep 5
        fi
        ((attempt++))
    done
    
    if [ $attempt -gt $max_attempts ]; then
        warn "⚠️  WordPress may still be initializing..."
        warn "   This is normal for first-time setup."
        warn "   Wait 30-60 seconds and try accessing: http://localhost:$wp_port"
    fi
    
    # Check phpMyAdmin accessibility
    log "Checking phpMyAdmin accessibility..."
    local pma_response=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:$phpmyadmin_port" 2>/dev/null || echo "000")
    
    if echo "$pma_response" | grep -q "200\|302"; then
        log "✅ phpMyAdmin is accessible! (HTTP $pma_response)"
    else
        warn "⚠️  phpMyAdmin may still be initializing... (HTTP $pma_response)"
    fi
    
    # Final success message
    log ""
    log "🎉 Setup completed successfully!"
    log "📋 Service Information:"
    log "   WordPress: http://localhost:$wp_port"
    log "   phpMyAdmin: http://localhost:$phpmyadmin_port"
    log "   Admin Panel: http://localhost:$wp_port/wp-admin"
    log ""
    log "🔧 Troubleshooting Commands:"
    log "   View all logs: docker-compose logs"
    log "   MySQL logs: docker-compose logs mysql"
    log "   WordPress logs: docker-compose logs wordpress"
    log "   phpMyAdmin logs: docker-compose logs phpmyadmin"
    log "   Restart services: docker-compose restart"
    log "   Stop services: docker-compose down"
    log ""
    
    if [ "$wp_response" != "200" ] && [ "$wp_response" != "302" ]; then
        warn "⚠️  WordPress is still initializing. This may take 1-2 minutes."
        warn "   If you see database connection errors, wait a bit longer."
        warn "   WordPress will complete its setup automatically."
    fi
    
    log "Setup complete! 🚀"
}

verify_services