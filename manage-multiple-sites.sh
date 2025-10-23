#!/bin/bash

# WordPress Docker Boilerplate - Multiple Sites Management Script
# This script helps manage multiple WordPress sites on the same system

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default configuration
DEFAULT_PORTS_START=8080
DEFAULT_PHPMYADMIN_START=8081
MAX_SITES=10

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

# Function to check if port is available
check_port() {
    local port=$1
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        return 1
    else
        return 0
    fi
}

# Function to find available ports
find_available_ports() {
    local count=$1
    local wp_port=$DEFAULT_PORTS_START
    local phpmyadmin_port=$DEFAULT_PHPMYADMIN_START
    local ports=()
    
    for ((i=1; i<=count; i++)); do
        # Find available WordPress port
        while ! check_port $wp_port; do
            ((wp_port++))
        done
        
        # Find available phpMyAdmin port
        while ! check_port $phpmyadmin_port; do
            ((phpmyadmin_port++))
        done
        
        ports+=("$wp_port:$phpmyadmin_port")
        ((wp_port++))
        ((phpmyadmin_port++))
    done
    
    echo "${ports[@]}"
}

# Function to create a new site
create_site() {
    local site_name=$1
    local wp_port=$2
    local phpmyadmin_port=$3
    
    print_header "Creating Site: $site_name"
    
    # Check if site directory already exists
    if [ -d "$site_name" ]; then
        print_error "Directory '$site_name' already exists!"
        return 1
    fi
    
    # Clone the boilerplate
    print_status "Cloning boilerplate to '$site_name'..."
    git clone . "$site_name" 2>/dev/null || {
        print_error "Failed to clone boilerplate. Make sure you're in the boilerplate directory."
        return 1
    }
    
    # Create .env file
    print_status "Creating environment configuration..."
    cp "$site_name/environment.env" "$site_name/.env"
    
    # Update ports in .env
    sed -i.bak "s/WORDPRESS_PORT=8080/WORDPRESS_PORT=$wp_port/" "$site_name/.env"
    sed -i.bak "s/PHPMYADMIN_PORT=8081/PHPMYADMIN_PORT=$phpmyadmin_port/" "$site_name/.env"
    
    # Update database credentials to be unique
    local db_name="wp_${site_name}_db"
    local db_user="wp_${site_name}_user"
    local db_password="wp_${site_name}_$(openssl rand -hex 8)"
    local db_root_password="wp_${site_name}_root_$(openssl rand -hex 8)"
    
    sed -i.bak "s/MYSQL_DATABASE=wordpress_db/MYSQL_DATABASE=$db_name/" "$site_name/.env"
    sed -i.bak "s/MYSQL_USER=wordpress_user/MYSQL_USER=$db_user/" "$site_name/.env"
    sed -i.bak "s/MYSQL_PASSWORD=change_this_password_123/MYSQL_PASSWORD=$db_password/" "$site_name/.env"
    sed -i.bak "s/MYSQL_ROOT_PASSWORD=change_this_root_password_123/MYSQL_ROOT_PASSWORD=$db_root_password/" "$site_name/.env"
    
    # Clean up backup files
    rm "$site_name/.env.bak"
    
    print_status "Site '$site_name' created successfully!"
    print_status "WordPress: http://localhost:$wp_port"
    print_status "phpMyAdmin: http://localhost:$phpmyadmin_port"
    print_status "Database: $db_name"
    
    return 0
}

# Function to start a site
start_site() {
    local site_name=$1
    
    if [ ! -d "$site_name" ]; then
        print_error "Site '$site_name' does not exist!"
        return 1
    fi
    
    print_header "Starting Site: $site_name"
    
    cd "$site_name"
    
    # Set COMPOSE_PROJECT_NAME environment variable
    export COMPOSE_PROJECT_NAME="$site_name"
    
    # Stop any existing containers with the same name first
    docker-compose -p "$site_name" down 2>/dev/null || true
    
    # Start the services
    docker-compose -p "$site_name" up -d --build
    
    if [ $? -eq 0 ]; then
        print_status "Site '$site_name' started successfully!"
        
        # Get ports from .env
        local wp_port=$(grep WORDPRESS_PORT .env | cut -d'=' -f2)
        local phpmyadmin_port=$(grep PHPMYADMIN_PORT .env | cut -d'=' -f2)
        
        print_status "WordPress: http://localhost:$wp_port"
        print_status "phpMyAdmin: http://localhost:$phpmyadmin_port"
    else
        print_error "Failed to start site '$site_name'"
    fi
    
    cd ..
}

# Function to stop a site
stop_site() {
    local site_name=$1
    
    if [ ! -d "$site_name" ]; then
        print_error "Site '$site_name' does not exist!"
        return 1
    fi
    
    print_header "Stopping Site: $site_name"
    
    cd "$site_name"
    
    # Set COMPOSE_PROJECT_NAME environment variable
    export COMPOSE_PROJECT_NAME="$site_name"
    
    docker-compose -p "$site_name" down
    
    if [ $? -eq 0 ]; then
        print_status "Site '$site_name' stopped successfully!"
    else
        print_error "Failed to stop site '$site_name'"
    fi
    
    cd ..
}

# Function to list all sites
list_sites() {
    print_header "Available Sites"
    
    local sites_found=false
    
    for dir in */; do
        if [ -d "$dir" ] && [ -f "$dir/docker-compose.yml" ]; then
            local site_name=${dir%/}
            local status="Stopped"
            
            # Check if containers are running
            if docker ps --format "table {{.Names}}" | grep -q "${site_name}_"; then
                status="Running"
            fi
            
            # Get ports from .env if exists
            if [ -f "$dir/.env" ]; then
                local wp_port=$(grep WORDPRESS_PORT "$dir/.env" | cut -d'=' -f2 2>/dev/null || echo "N/A")
                local phpmyadmin_port=$(grep PHPMYADMIN_PORT "$dir/.env" | cut -d'=' -f2 2>/dev/null || echo "N/A")
                echo -e "  ${GREEN}$site_name${NC} - Status: $status - WordPress: $wp_port - phpMyAdmin: $phpmyadmin_port"
            else
                echo -e "  ${GREEN}$site_name${NC} - Status: $status - No .env file"
            fi
            
            sites_found=true
        fi
    done
    
    if [ "$sites_found" = false ]; then
        print_warning "No sites found. Create a site first with: $0 create <site_name>"
    fi
}

# Function to show site status
show_status() {
    print_header "System Status"
    
    # Show Docker containers
    print_status "Running WordPress containers:"
    docker ps --format "table {{.Names}}\t{{.Ports}}\t{{.Status}}" | grep -E "(wordpress|mysql|phpmyadmin)" || echo "  No WordPress containers running"
    
    echo
    
    # Show resource usage
    print_status "Resource usage:"
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}" | head -10
    
    echo
    
    # Show port usage
    print_status "Port usage:"
    netstat -tuln | grep -E ":(808[0-9]|809[0-9])" | sort || echo "  No WordPress ports in use"
}

# Function to cleanup sites
cleanup_sites() {
    print_header "Cleanup Sites"
    
    read -p "This will remove all site directories and their data. Are you sure? (y/N): " confirm
    if [[ $confirm =~ ^[Yy]$ ]]; then
        for dir in */; do
            if [ -d "$dir" ] && [ -f "$dir/docker-compose.yml" ]; then
                local site_name=${dir%/}
                print_status "Removing site: $site_name"
                
                # Stop containers first
                cd "$dir"
                export COMPOSE_PROJECT_NAME="$site_name"
                docker-compose -p "$site_name" down -v 2>/dev/null || true
                cd ..
                
                # Remove directory
                rm -rf "$dir"
            fi
        done
        print_status "Cleanup completed!"
    else
        print_status "Cleanup cancelled."
    fi
}

# Function to fix container conflicts
fix_conflicts() {
    print_header "Fixing Container Conflicts"
    
    print_status "Stopping all WordPress-related containers..."
    
    # Stop all containers with wp-boilerplate in the name
    docker ps -q --filter "name=wp-boilerplate" | xargs -r docker stop
    docker ps -aq --filter "name=wp-boilerplate" | xargs -r docker rm
    
    # Stop all containers with wordpress in the name
    docker ps -q --filter "name=wordpress" | xargs -r docker stop
    docker ps -aq --filter "name=wordpress" | xargs -r docker rm
    
    # Stop all containers with mysql in the name
    docker ps -q --filter "name=mysql" | xargs -r docker stop
    docker ps -aq --filter "name=mysql" | xargs -r docker rm
    
    # Stop all containers with phpmyadmin in the name
    docker ps -q --filter "name=phpmyadmin" | xargs -r docker stop
    docker ps -aq --filter "name=phpmyadmin" | xargs -r docker rm
    
    print_status "Container conflicts resolved!"
    print_warning "You may need to restart your sites:"
    print_status "  ./manage-multiple-sites.sh list"
    print_status "  ./manage-multiple-sites.sh start <site_name>"
}

# Function to show help
show_help() {
    echo "WordPress Docker Boilerplate - Multiple Sites Manager"
    echo
    echo "Usage: $0 <command> [options]"
    echo
    echo "Commands:"
    echo "  create <site_name> [count]  Create a new site (or multiple sites)"
    echo "  start <site_name>           Start a specific site"
    echo "  stop <site_name>            Stop a specific site"
    echo "  restart <site_name>         Restart a specific site"
    echo "  list                        List all available sites"
    echo "  status                      Show system status"
    echo "  fix-conflicts               Fix container name conflicts"
    echo "  cleanup                     Remove all sites (with confirmation)"
    echo "  help                        Show this help message"
    echo
    echo "Examples:"
    echo "  $0 create mysite           # Create a single site"
    echo "  $0 create mysite 3         # Create 3 sites: mysite1, mysite2, mysite3"
    echo "  $0 start mysite            # Start mysite"
    echo "  $0 list                    # List all sites"
    echo "  $0 status                  # Show system status"
}

# Main script logic
case "$1" in
    "create")
        if [ -z "$2" ]; then
            print_error "Please provide a site name"
            echo "Usage: $0 create <site_name> [count]"
            exit 1
        fi
        
        site_name="$2"
        count="${3:-1}"
        
        if [ "$count" -gt "$MAX_SITES" ]; then
            print_error "Maximum $MAX_SITES sites allowed"
            exit 1
        fi
        
        print_header "Creating $count site(s)"
        
        # Find available ports
        ports=($(find_available_ports $count))
        
        if [ ${#ports[@]} -lt $count ]; then
            print_error "Not enough available ports found"
            exit 1
        fi
        
        # Create sites
        for ((i=1; i<=count; i++)); do
            if [ "$count" -eq 1 ]; then
                current_site_name="$site_name"
            else
                current_site_name="${site_name}${i}"
            fi
            
            port_pair=${ports[$((i-1))]}
            wp_port=${port_pair%:*}
            phpmyadmin_port=${port_pair#*:}
            
            create_site "$current_site_name" "$wp_port" "$phpmyadmin_port"
            echo
        done
        
        print_status "All sites created successfully!"
        ;;
        
    "start")
        if [ -z "$2" ]; then
            print_error "Please provide a site name"
            echo "Usage: $0 start <site_name>"
            exit 1
        fi
        start_site "$2"
        ;;
        
    "stop")
        if [ -z "$2" ]; then
            print_error "Please provide a site name"
            echo "Usage: $0 stop <site_name>"
            exit 1
        fi
        stop_site "$2"
        ;;
        
    "restart")
        if [ -z "$2" ]; then
            print_error "Please provide a site name"
            echo "Usage: $0 restart <site_name>"
            exit 1
        fi
        stop_site "$2"
        sleep 2
        start_site "$2"
        ;;
        
    "list")
        list_sites
        ;;
        
    "status")
        show_status
        ;;
        
    "cleanup")
        cleanup_sites
        ;;
        
    "fix-conflicts")
        fix_conflicts
        ;;
        
    "help"|"-h"|"--help")
        show_help
        ;;
        
    *)
        print_error "Unknown command: $1"
        echo
        show_help
        exit 1
        ;;
esac
