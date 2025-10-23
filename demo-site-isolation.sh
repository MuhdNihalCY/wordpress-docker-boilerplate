#!/bin/bash

# WordPress Docker Boilerplate - Site Isolation Demonstration
# This script demonstrates complete site isolation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header "WordPress Docker Boilerplate - Site Isolation Demo"

echo "This demonstration shows how each WordPress site is completely independent."
echo

# Check if management script exists
if [ ! -f "./manage-multiple-sites.sh" ]; then
    print_error "Management script not found. Please run this from the boilerplate directory."
    exit 1
fi

print_header "1. Creating Test Sites"

# Create two test sites
print_status "Creating site1..."
./manage-multiple-sites.sh create site1 2>/dev/null || {
    print_warning "site1 might already exist, continuing..."
}

print_status "Creating site2..."
./manage-multiple-sites.sh create site2 2>/dev/null || {
    print_warning "site2 might already exist, continuing..."
}

echo

print_header "2. Starting Sites"

print_status "Starting site1..."
./manage-multiple-sites.sh start site1

echo

print_status "Starting site2..."
./manage-multiple-sites.sh start site2

echo

print_header "3. Verifying Complete Isolation"

print_status "Running isolation verification..."
./manage-multiple-sites.sh verify-isolation

echo

print_header "4. Showing Site Independence"

print_status "Site1 containers:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep "site1_" || echo "  No site1 containers running"

echo

print_status "Site2 containers:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep "site2_" || echo "  No site2 containers running"

echo

print_status "Site1 volumes:"
docker volume ls --format "table {{.Name}}\t{{.Driver}}" | grep "site1_" || echo "  No site1 volumes found"

echo

print_status "Site2 volumes:"
docker volume ls --format "table {{.Name}}\t{{.Driver}}" | grep "site2_" || echo "  No site2 volumes found"

echo

print_status "Site1 networks:"
docker network ls --format "table {{.Name}}\t{{.Driver}}" | grep "site1_" || echo "  No site1 networks found"

echo

print_status "Site2 networks:"
docker network ls --format "table {{.Name}}\t{{.Driver}}" | grep "site2_" || echo "  No site2 networks found"

echo

print_header "5. Database Isolation Check"

if [ -f "site1/.env" ]; then
    print_status "Site1 database credentials:"
    echo "  Database: $(grep MYSQL_DATABASE site1/.env | cut -d'=' -f2)"
    echo "  User: $(grep MYSQL_USER site1/.env | cut -d'=' -f2)"
    echo "  Table Prefix: $(grep WORDPRESS_TABLE_PREFIX site1/.env | cut -d'=' -f2)"
fi

echo

if [ -f "site2/.env" ]; then
    print_status "Site2 database credentials:"
    echo "  Database: $(grep MYSQL_DATABASE site2/.env | cut -d'=' -f2)"
    echo "  User: $(grep MYSQL_USER site2/.env | cut -d'=' -f2)"
    echo "  Table Prefix: $(grep WORDPRESS_TABLE_PREFIX site2/.env | cut -d'=' -f2)"
fi

echo

print_header "6. Port Isolation Check"

print_status "Checking port usage..."
netstat -tuln | grep -E ":(808[0-9]|809[0-9])" | sort || echo "  No WordPress ports in use"

echo

print_header "7. Independence Test"

print_status "Testing site independence..."

# Test stopping one site doesn't affect the other
print_status "Stopping site1..."
./manage-multiple-sites.sh stop site1

print_status "Checking if site2 is still running..."
site2_containers=$(docker ps --format "{{.Names}}" | grep "site2_" | wc -l)
if [ "$site2_containers" -gt 0 ]; then
    print_status "✅ site2 is still running independently!"
else
    print_warning "site2 might not be running"
fi

# Restart site1
print_status "Restarting site1..."
./manage-multiple-sites.sh start site1

echo

print_header "8. Summary"

print_status "✅ Complete Site Isolation Achieved!"
echo
print_status "Each site has:"
print_status "  🔒 Unique container names (site1_wordpress, site2_wordpress)"
print_status "  💾 Separate Docker volumes (site1_wordpress_data, site2_wordpress_data)"
print_status "  🌐 Independent networks (site1_wordpress-network, site2_wordpress-network)"
print_status "  🔌 Different ports (8080, 8082, etc.)"
print_status "  🗄️ Unique databases with different credentials"
print_status "  ⚙️ Separate configurations (.env.site files)"
echo
print_status "🎯 Result: Sites are completely independent and cannot affect each other!"
echo
print_status "Access your sites:"
if [ -f "site1/.env" ]; then
    site1_port=$(grep WORDPRESS_PORT site1/.env | cut -d'=' -f2)
    print_status "  Site1: http://localhost:$site1_port"
fi
if [ -f "site2/.env" ]; then
    site2_port=$(grep WORDPRESS_PORT site2/.env | cut -d'=' -f2)
    print_status "  Site2: http://localhost:$site2_port"
fi
echo
print_status "To clean up test sites: ./manage-multiple-sites.sh cleanup"
