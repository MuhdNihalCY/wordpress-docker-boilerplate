#!/bin/bash

# WordPress Docker Boilerplate Setup Script
# This script helps you set up the WordPress Docker environment quickly

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to generate random password
generate_password() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-25
}

# Banner
echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                WordPress Docker Boilerplate                 ║"
echo "║                    Setup Script v1.0                        ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

print_status "Starting WordPress Docker Boilerplate setup..."

# Check prerequisites
print_status "Checking prerequisites..."

if ! command_exists docker; then
    print_error "Docker is not installed. Please install Docker first."
    echo "Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! command_exists docker-compose; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    echo "Visit: https://docs.docker.com/compose/install/"
    exit 1
fi

print_success "Docker and Docker Compose are installed"

# Check if .env already exists
if [ -f ".env" ]; then
    print_warning ".env file already exists"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Keeping existing .env file"
    else
        print_status "Overwriting .env file"
        rm .env
    fi
fi

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    print_status "Creating .env file from template..."
    cp environment.env .env
    
    # Generate secure passwords
    print_status "Generating secure passwords..."
    DB_PASSWORD=$(generate_password)
    ROOT_PASSWORD=$(generate_password)
    
    # Update passwords in .env
    sed -i.bak "s/change_this_password_123/$DB_PASSWORD/g" .env
    sed -i.bak "s/change_this_root_password_123/$ROOT_PASSWORD/g" .env
    rm .env.bak
    
    print_success "Created .env file with secure passwords"
    print_warning "Please save these passwords securely:"
    echo "  Database Password: $DB_PASSWORD"
    echo "  Root Password: $ROOT_PASSWORD"
    echo
fi

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker first."
    exit 1
fi

print_success "Docker is running"

# Create necessary directories
print_status "Creating necessary directories..."
mkdir -p wp-content/debug-logs
print_success "Directories created"

# Start Docker containers
print_status "Starting Docker containers..."
docker-compose up -d

# Wait for containers to be ready
print_status "Waiting for containers to be ready..."
sleep 10

# Check container status
if docker-compose ps | grep -q "Up"; then
    print_success "Containers are running successfully!"
else
    print_error "Some containers failed to start. Check logs with: docker-compose logs"
    exit 1
fi

# Display access information
echo
print_success "WordPress Docker Boilerplate is ready!"
echo
echo -e "${GREEN}Access URLs:${NC}"
echo "  WordPress Site:    http://localhost:8080"
echo "  WordPress Admin:    http://localhost:8080/wp-admin"
echo "  phpMyAdmin:         http://localhost:8081"
echo
echo -e "${GREEN}Debug Tools:${NC}"
echo "  Debug Logs Admin:   http://localhost:8080/wp-admin/tools.php?page=debug-logs"
echo "  Debug Test Script:  http://localhost:8080/wp-content/plugins/test-debug-logging.php"
echo
echo -e "${GREEN}Next Steps:${NC}"
echo "  1. Complete WordPress installation at http://localhost:8080"
echo "  2. Activate the 'Custom Debug Logger' plugin"
echo "  3. Test debug logging functionality"
echo "  4. Start developing your WordPress site!"
echo
echo -e "${YELLOW}Useful Commands:${NC}"
echo "  Stop containers:    docker-compose down"
echo "  Start containers:  docker-compose up -d"
echo "  View logs:         docker-compose logs"
echo "  Restart WordPress: docker-compose restart wordpress"
echo
print_success "Setup completed successfully! 🎉"
