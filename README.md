# WordPress Docker Boilerplate

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![WordPress](https://img.shields.io/badge/WordPress-6.4+-blue.svg)](https://wordpress.org/)
[![Docker](https://img.shields.io/badge/Docker-Compose-blue.svg)](https://docs.docker.com/compose/)
[![PHP](https://img.shields.io/badge/PHP-8.2+-purple.svg)](https://php.net/)

A complete, production-ready WordPress Docker boilerplate with advanced debug logging, multi-site management, and enterprise-grade security. Perfect for developers, agencies, and teams who need a robust WordPress development environment or production deployment.

## ✨ Features

### 🐳 **Complete Docker Environment**
- **WordPress 6.4** with PHP 8.2 and Apache
- **MySQL 8.0** with optimized configuration
- **phpMyAdmin 5.2** for database management
- **Health checks** and automatic restarts
- **Volume persistence** for data safety

### 🔀 **Multi-Site Management**
- **Unlimited sites** on the same system
- **Complete site isolation** - no cross-site interference
- **Automated management** with `manage-multiple-sites.sh`
- **Dynamic port assignment** and conflict resolution
- **Independent databases** and configurations

### 🐛 **Advanced Debug Logging**
- **Custom `write_log()` function** with multiple log levels
- **Admin interface** for log viewing and management
- **Structured logging** with timestamps and context
- **Production-safe** debug configurations
- **Comprehensive logging guide** included

### 🔒 **Enterprise Security**
- **Security-hardened** WordPress configuration
- **Environment-based** secrets management
- **Production-ready** SSL and reverse proxy setup
- **Best practices** for Docker security
- **Regular security updates** and monitoring

### 🚀 **Developer Experience**
- **One-command setup** with `./setup.sh`
- **Automated site creation** and management
- **Comprehensive documentation** and examples
- **Testing scripts** and validation tools
- **CI/CD ready** configuration

## 🚀 Quick Start

### Prerequisites

- **Docker Desktop** (latest version) - [Download](https://www.docker.com/products/docker-desktop/)
- **Docker Compose** (included with Docker Desktop)
- **Git** - [Download](https://git-scm.com/downloads)
- **Terminal/Command Line** access
- **4GB RAM minimum** (8GB recommended for multiple sites)

### Installation Methods

#### **Method 1: Automated Setup (Recommended)**

```bash
# Clone the repository
git clone https://github.com/MuhdNihalCY/wordpress-docker-boilerplate.git
cd wordpress-docker-boilerplate

# Run the automated setup
./setup.sh

# Access your site
open http://localhost:8080
```

#### **Method 2: Manual Setup**

```bash
# Clone the repository
git clone https://github.com/MuhdNihalCY/wordpress-docker-boilerplate.git
cd wordpress-docker-boilerplate

# Create environment file
cp environment.env .env

# Customize settings (optional)
nano .env

# Start the services
docker-compose up -d

# Access your site
open http://localhost:8080
```

### First-Time Access

1. **WordPress Site**: http://localhost:8080
2. **WordPress Admin**: http://localhost:8080/wp-admin
3. **phpMyAdmin**: http://localhost:8081
4. **Debug Logs**: http://localhost:8080/wp-admin/tools.php?page=debug-logs

### Default Credentials

- **WordPress Admin**: Create during first-time setup
- **phpMyAdmin**: 
  - Username: `wordpress_user` (or your custom MYSQL_USER)
  - Password: `change_this_password_123` (or your custom MYSQL_PASSWORD)

## 📁 Project Structure

```
wordpress-docker-boilerplate/
├── 📋 Core Configuration
│   ├── docker-compose.yml              # Main Docker Compose configuration
│   ├── environment.env                 # Environment variables template
│   ├── .env                           # Your environment variables (create from template)
│   ├── debug-config.php               # WordPress debug configuration
│   └── nginx.conf                     # Nginx reverse proxy configuration
│
├── 🛠️ Management Scripts
│   ├── setup.sh                       # Automated setup script
│   ├── manage-multiple-sites.sh       # Multi-site management script
│   ├── demo-site-isolation.sh         # Site isolation demonstration
│   └── test-container-fix.sh          # Container conflict testing
│
├── 📚 Documentation
│   ├── README.md                      # This comprehensive guide
│   ├── DEBUG-LOGGING-GUIDE.md         # Debug logging documentation
│   ├── CONTRIBUTING.md                # Contribution guidelines
│   ├── CHANGELOG.md                   # Version history and changes
│   └── LICENSE                        # MIT License
│
├── 🔧 WordPress Customization
│   └── wp-content/                    # WordPress themes and plugins
│       ├── plugins/
│       │   ├── custom-debug-logger.php    # Custom debug logging plugin
│       │   └── test-debug-logging.php     # Debug logging test script
│       ├── themes/                    # WordPress themes directory
│       ├── debug-logs/                # Custom debug logs directory
│       └── debug.log                  # WordPress debug log
│
└── 🗂️ Generated Files (after setup)
    ├── .env                           # Your environment configuration
    ├── wp-content/debug-logs/         # Debug log files
    └── Docker volumes/                # Persistent data storage
```

## 🔧 Configuration

### Environment Variables
The `.env` file contains all configuration settings. Copy from `environment.env` and customize:

```env
# Database Configuration
MYSQL_DATABASE=wordpress_db                    # Database name
MYSQL_USER=wordpress_user                     # Database user
MYSQL_PASSWORD=your_secure_password_here       # Database password
MYSQL_ROOT_PASSWORD=your_root_password_here   # Root password

# WordPress Configuration
WORDPRESS_TABLE_PREFIX=wp_                    # Table prefix
WORDPRESS_DEBUG=1                             # Debug mode (0 for production)

# Port Configuration
WORDPRESS_PORT=8080                           # WordPress port
PHPMYADMIN_PORT=8081                          # phpMyAdmin port

# Production Settings (uncomment for production)
# WORDPRESS_URL=https://yourdomain.com
# WORDPRESS_HOME=https://yourdomain.com
```

### Security Configuration

#### **Development Environment**
- Debug logging enabled (`WORDPRESS_DEBUG=1`)
- Default passwords (change before production)
- Automatic updates disabled
- Memory limits optimized for development

#### **Production Environment**
- Debug logging disabled (`WORDPRESS_DEBUG=0`)
- Strong, unique passwords required
- SSL/HTTPS configuration
- Security headers enabled
- Regular security updates

### Docker Configuration

#### **Services Overview**
- **WordPress**: PHP 8.2 + Apache + WordPress 6.4
- **MySQL**: Version 8.0 with optimized settings
- **phpMyAdmin**: Version 5.2 for database management

#### **Resource Limits**
```yaml
# Memory limits (configurable)
WP_MEMORY_LIMIT: 256M
WP_MAX_MEMORY_LIMIT: 512M

# Container limits
deploy:
  resources:
    limits:
      memory: 512M
      cpus: '0.5'
```

#### **Health Checks**
- WordPress: HTTP health check every 30s
- MySQL: Database ping every 30s
- Automatic restart on failure
- Update domain settings for production
- Customize debug settings in `debug-config.php`

## 🐛 Debug Logging & Development Tools

This setup includes comprehensive debug logging capabilities for WordPress development.

### **Debug Features Enabled**
- ✅ WordPress debug mode (`WP_DEBUG=true`)
- ✅ Debug logging (`WP_DEBUG_LOG=true`)
- ✅ Query saving (`SAVEQUERIES=true`)
- ✅ Script debugging (`SCRIPT_DEBUG=true`)
- ✅ Custom error handlers
- ✅ Enhanced logging functions

### **Custom Debug Logger Plugin**
The setup includes a custom debug logging plugin with advanced features:

#### **Core Functions**
```php
// Basic logging
write_log('This is a simple message');
write_log('Warning message', 'warning');
write_log('Error message', 'error');
write_log('Debug message', 'debug');

// Advanced logging
$data = ['user_id' => 1, 'action' => 'login'];
write_log($data, 'info');

// Error logging with context
write_error_log('Database connection failed', [
    'error_code' => 500,
    'database' => 'wordpress_db'
]);
```

#### **Available Log Levels**
- `info` - General information
- `warning` - Warning messages  
- `error` - Error messages
- `debug` - Debug information

### **Debug Tools Access**

1. **WordPress Admin Debug Logs**
   - URL: `http://localhost:8080/wp-admin/tools.php?page=debug-logs`
   - Features: View logs, clear logs, real-time monitoring

2. **Debug Test Script**
   - URL: `http://localhost:8080/wp-content/plugins/test-debug-logging.php`
   - Purpose: Test all logging functions and verify setup

3. **Log File Locations**
   - WordPress Debug: `/wp-content/debug.log`
   - Custom Debug: `/wp-content/debug-logs/custom-debug.log`

### **Debug Configuration**
- **File**: `debug-config.php`
- **Features**: Complete WordPress debug settings, custom error handlers
- **Usage**: Include in `wp-config.php` or load as needed

### **Quick Debug Setup**
```bash
# 1. Activate the debug plugin
# Go to WordPress Admin → Plugins → Activate "Custom Debug Logger"

# 2. Test the setup
# Visit: http://localhost:8080/wp-content/plugins/test-debug-logging.php

# 3. Start logging in your code
write_log('Function called', 'debug');
```

### **Debug Best Practices**
- Use appropriate log levels for different types of messages
- Include context data with error logs
- Clear logs regularly to manage disk space
- Disable debug logging in production
- Use the admin interface to monitor logs

For detailed debug logging documentation, see: `DEBUG-LOGGING-GUIDE.md`

## 📖 Usage Guide

### Basic Commands

```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f

# Restart a specific service
docker-compose restart wordpress

# Execute commands in containers
docker-compose exec wordpress wp --info
docker-compose exec mysql mysql -u root -p
```

### Management Scripts

```bash
# Setup new environment
./setup.sh

# Manage multiple sites
./manage-multiple-sites.sh create newsite
./manage-multiple-sites.sh start newsite
./manage-multiple-sites.sh stop newsite
./manage-multiple-sites.sh list

# Verify site isolation
./manage-multiple-sites.sh verify-isolation

# Demo site independence
./demo-site-isolation.sh
```

### WordPress CLI Integration

```bash
# Install WordPress CLI in container
docker-compose exec wordpress bash -c "curl -O https://raw.githubusercontent.com/wp-cli/wp-cli/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp"

# Use WordPress CLI
docker-compose exec wordpress wp plugin list
docker-compose exec wordpress wp theme list
docker-compose exec wordpress wp user list
```

## 🔀 Multi-Site Management

Run unlimited WordPress sites simultaneously with complete isolation:

### **Method 1: Automated Management Script (Recommended)**

Use the included management script for easy multi-site setup:

```bash
# Create a single site
./manage-multiple-sites.sh create mysite

# Create multiple sites at once
./manage-multiple-sites.sh create mysite 3  # Creates mysite1, mysite2, mysite3

# List all sites
./manage-multiple-sites.sh list

# Start a specific site
./manage-multiple-sites.sh start mysite1

# Stop a specific site
./manage-multiple-sites.sh stop mysite1

# Check system status
./manage-multiple-sites.sh status

# Verify all sites are properly isolated
./manage-multiple-sites.sh verify-isolation

# Fix container conflicts (if you get naming conflicts)
./manage-multiple-sites.sh fix-conflicts

# Get help
./manage-multiple-sites.sh help
```

### **Method 2: Manual Setup (Different Ports)**

1. **Clone the boilerplate multiple times:**
   ```bash
   # Site 1
   git clone https://github.com/MuhdNihalCY/wordpress-docker-boilerplate.git site1
   cd site1
   cp environment.env .env
   # Edit .env: WORDPRESS_PORT=8080, PHPMYADMIN_PORT=8081
   docker-compose up -d
   
   # Site 2
   git clone https://github.com/MuhdNihalCY/wordpress-docker-boilerplate.git site2
   cd site2
   cp environment.env .env
   # Edit .env: WORDPRESS_PORT=8082, PHPMYADMIN_PORT=8083
   docker-compose up -d
   
   # Site 3
   git clone https://github.com/MuhdNihalCY/wordpress-docker-boilerplate.git site3
   cd site3
   cp environment.env .env
   # Edit .env: WORDPRESS_PORT=8084, PHPMYADMIN_PORT=8085
   docker-compose up -d
   ```

2. **Access your sites:**
   - Site 1: http://localhost:8080 (phpMyAdmin: 8081)
   - Site 2: http://localhost:8082 (phpMyAdmin: 8083)
   - Site 3: http://localhost:8084 (phpMyAdmin: 8085)

### **Method 3: Different Project Names**

1. **Use Docker Compose project names:**
   ```bash
   # Site 1
   cd site1
   docker-compose -p site1 up -d
   
   # Site 2
   cd site2
   docker-compose -p site2 up -d
   
   # Site 3
   cd site3
   docker-compose -p site3 up -d
   ```

2. **Check running containers:**
   ```bash
   docker ps
   # You'll see containers like: site1_wordpress, site2_wordpress, etc.
   ```

### **Method 4: Subdomain Setup (Production)**

1. **Configure Nginx reverse proxy:**
   ```nginx
   # /etc/nginx/sites-available/multi-wordpress
   server {
       listen 80;
       server_name site1.yourdomain.com;
       location / {
           proxy_pass http://localhost:8080;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
       }
   }
   
   server {
       listen 80;
       server_name site2.yourdomain.com;
       location / {
           proxy_pass http://localhost:8082;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
       }
   }
   ```

2. **Update DNS records:**
   - site1.yourdomain.com → your-server-ip
   - site2.yourdomain.com → your-server-ip

### **Method 5: Single Docker Compose with Multiple Services**

Create a `docker-compose.multi.yml` file:

```yaml
version: '3.8'

services:
  wordpress1:
    image: wordpress:6.4-php8.2-apache
    container_name: wp-site1
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: mysql1:3306
      WORDPRESS_DB_USER: wp1_user
      WORDPRESS_DB_PASSWORD: wp1_password
      WORDPRESS_DB_NAME: wp1_db
    volumes:
      - wp1_data:/var/www/html
    depends_on:
      - mysql1

  mysql1:
    image: mysql:8.0
    container_name: wp-mysql1
    environment:
      MYSQL_DATABASE: wp1_db
      MYSQL_USER: wp1_user
      MYSQL_PASSWORD: wp1_password
      MYSQL_ROOT_PASSWORD: wp1_root_password
    volumes:
      - wp1_mysql_data:/var/lib/mysql

  wordpress2:
    image: wordpress:6.4-php8.2-apache
    container_name: wp-site2
    ports:
      - "8082:80"
    environment:
      WORDPRESS_DB_HOST: mysql2:3306
      WORDPRESS_DB_USER: wp2_user
      WORDPRESS_DB_PASSWORD: wp2_password
      WORDPRESS_DB_NAME: wp2_db
    volumes:
      - wp2_data:/var/www/html
    depends_on:
      - mysql2

  mysql2:
    image: mysql:8.0
    container_name: wp-mysql2
    environment:
      MYSQL_DATABASE: wp2_db
      MYSQL_USER: wp2_user
      MYSQL_PASSWORD: wp2_password
      MYSQL_ROOT_PASSWORD: wp2_root_password
    volumes:
      - wp2_mysql_data:/var/lib/mysql

volumes:
  wp1_data:
  wp1_mysql_data:
  wp2_data:
  wp2_mysql_data:
```

### **Port Configuration Reference**

| Site | WordPress Port | phpMyAdmin Port | Database Port |
|------|---------------|-----------------|---------------|
| Site 1 | 8080 | 8081 | 3306 (internal) |
| Site 2 | 8082 | 8083 | 3307 (internal) |
| Site 3 | 8084 | 8085 | 3308 (internal) |
| Site 4 | 8086 | 8087 | 3309 (internal) |

### **Management Commands for Multiple Sites**

```bash
# Start all sites
docker-compose -p site1 up -d
docker-compose -p site2 up -d
docker-compose -p site3 up -d

# Stop specific site
docker-compose -p site1 down

# View logs for specific site
docker-compose -p site1 logs wordpress

# Restart specific site
docker-compose -p site1 restart wordpress

# Check all running containers
docker ps --format "table {{.Names}}\t{{.Ports}}\t{{.Status}}"

# Backup specific site database
docker-compose -p site1 exec mysql mysqldump -u root -p wp1_db > site1_backup.sql
```

### **Resource Management**

```bash
# Check resource usage
docker stats

# Set resource limits in docker-compose.yml
services:
  wordpress:
    deploy:
      resources:
        limits:
          memory: 512M
          cpus: '0.5'
```

### **Complete Site Isolation**

Each site is **completely independent** and will not affect other sites:

✅ **Container Isolation**
- Unique container names: `site1_wordpress`, `site2_wordpress`, etc.
- Separate Docker networks per site
- Independent container lifecycles

✅ **Data Isolation**
- Separate Docker volumes: `site1_wordpress_data`, `site2_wordpress_data`
- Independent MySQL databases with unique credentials
- Isolated WordPress file systems

✅ **Network Isolation**
- Different ports for each site
- Separate Docker networks
- No cross-site communication

✅ **Database Isolation**
- Unique database names: `wp_site1_timestamp_db`
- Different MySQL users and passwords
- Separate WordPress table prefixes

✅ **Configuration Isolation**
- Site-specific `.env.site` files
- Independent environment variables
- No shared configuration

### **Best Practices for Multiple Sites**

1. **Use descriptive project names** (`-p site1`, `-p site2`)
2. **Different ports** for each site
3. **Separate databases** for each site
4. **Individual .env files** for each site
5. **Resource monitoring** to prevent conflicts
6. **Regular backups** for each site
7. **SSL certificates** for production sites
8. **Verify isolation** with `./manage-multiple-sites.sh verify-isolation`

## 🏗️ Boilerplate Standards

This boilerplate follows industry best practices:

### **WordPress Standards**
- ✅ WordPress Coding Standards compliance
- ✅ Proper PHPDoc documentation
- ✅ Security best practices
- ✅ Performance optimizations
- ✅ Accessibility considerations

### **Docker Best Practices**
- ✅ Multi-stage builds where applicable
- ✅ Health checks for all services
- ✅ Proper volume management
- ✅ Network isolation
- ✅ Resource limits and optimization

### **Development Standards**
- ✅ Comprehensive documentation
- ✅ Automated setup scripts
- ✅ Environment variable management
- ✅ Debug logging and monitoring
- ✅ Error handling and validation

### **Security Features**
- ✅ No hardcoded credentials
- ✅ Environment-based configuration
- ✅ Input validation and sanitization
- ✅ Proper file permissions
- ✅ Security headers configuration

## 🌐 Production Deployment

### Prerequisites

- **Server**: Ubuntu 20.04+ or CentOS 8+ with Docker installed
- **Resources**: Minimum 2GB RAM, 4GB recommended
- **Domain**: Registered domain name with DNS access
- **SSL**: SSL certificate (Let's Encrypt recommended)

### Step 1: Server Setup

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Nginx
sudo apt install nginx -y
```

### Step 2: Deploy WordPress

```bash
# Clone the boilerplate
git clone https://github.com/MuhdNihalCY/wordpress-docker-boilerplate.git
cd wordpress-docker-boilerplate

# Configure for production
cp environment.env .env
nano .env  # Update with production values

# Production .env example:
WORDPRESS_DEBUG=0
MYSQL_PASSWORD=your_very_secure_password_here
MYSQL_ROOT_PASSWORD=your_very_secure_root_password_here
WORDPRESS_URL=https://yourdomain.com
WORDPRESS_HOME=https://yourdomain.com

# Start services
docker-compose up -d
```

### Step 3: Nginx Configuration

```bash
# Configure Nginx
sudo cp nginx.conf /etc/nginx/sites-available/wordpress
sudo sed -i 's/yourdomain.com/yourdomain.com/g' /etc/nginx/sites-available/wordpress
sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default

# Test configuration
sudo nginx -t
sudo systemctl restart nginx
```

### Step 4: SSL Certificate

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Obtain SSL certificate
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com

# Test auto-renewal
sudo certbot renew --dry-run
```

### Step 5: Security Hardening

```bash
# Configure firewall
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable

# Set proper file permissions
sudo chown -R www-data:www-data wp-content/
sudo chmod -R 755 wp-content/

# Enable automatic security updates
sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure -plow unattended-upgrades
```

### Step 6: Backup Strategy

```bash
# Create backup script
cat > backup.sh << 'EOF'
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backups"

# Create backup directory
mkdir -p $BACKUP_DIR

# Database backup
docker-compose exec -T mysql mysqldump -u root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE > $BACKUP_DIR/db_backup_$DATE.sql

# Files backup
tar -czf $BACKUP_DIR/files_backup_$DATE.tar.gz wp-content/ .env docker-compose.yml

# Clean old backups (keep last 7 days)
find $BACKUP_DIR -name "*.sql" -mtime +7 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

echo "Backup completed: $DATE"
EOF

chmod +x backup.sh

# Schedule daily backups
(crontab -l 2>/dev/null; echo "0 2 * * * /path/to/backup.sh") | crontab -
```

### Production Checklist

- ✅ **Security**: Strong passwords, SSL enabled, firewall configured
- ✅ **Performance**: Resource limits set, caching enabled
- ✅ **Monitoring**: Log rotation, health checks, uptime monitoring
- ✅ **Backups**: Automated daily backups, tested restore procedures
- ✅ **Updates**: Regular WordPress and plugin updates
- ✅ **Documentation**: Deployment procedures documented

## 📊 Management Commands

### Start Services
```bash
docker-compose up -d
```

### Stop Services
```bash
docker-compose down
```

### View Logs
```bash
# All services
docker-compose logs

# Specific service
docker-compose logs wordpress
docker-compose logs mysql
```

### Backup Database
```bash
# Create backup
docker-compose exec mysql mysqldump -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} > backup.sql

# Restore backup
docker-compose exec -T mysql mysql -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} < backup.sql
```

### Update WordPress
```bash
# Pull latest WordPress image
docker-compose pull wordpress

# Restart WordPress container
docker-compose up -d wordpress
```

## 🔍 Troubleshooting

### **Container Name Conflicts (Most Common Issue)**

If you get errors like "Container name already in use", this happens when running multiple sites:

```bash
# Quick fix - stop all conflicting containers
./manage-multiple-sites.sh fix-conflicts

# Or manually stop specific containers
docker stop wp-boilerplate-mysql wp-boilerplate-wordpress wp-boilerplate-phpmyadmin
docker rm wp-boilerplate-mysql wp-boilerplate-wordpress wp-boilerplate-phpmyadmin

# Then restart your sites
./manage-multiple-sites.sh start <site_name>
```

**Why this happens:** The old docker-compose.yml used hardcoded container names. The updated version uses dynamic names based on project name.

### **Common Issues**

1. **Port Already in Use**
   ```bash
   # Check what's using the port
   sudo lsof -i :8080
   # Change port in docker-compose.yml if needed
   ```

2. **Database Connection Issues**
   ```bash
   # Check MySQL logs
   docker-compose logs mysql
   # Ensure MySQL is fully started before WordPress
   ```

3. **Permission Issues**
   ```bash
   # Fix WordPress file permissions
   docker-compose exec wordpress chown -R www-data:www-data /var/www/html
   ```

### **Multi-Site Specific Issues**

1. **Sites interfering with each other**
   ```bash
   # Use different project names
   docker-compose -p site1 up -d
   docker-compose -p site2 up -d
   ```

2. **Port conflicts**
   ```bash
   # Check available ports
   ./manage-multiple-sites.sh status
   
   # Use the management script for automatic port assignment
   ./manage-multiple-sites.sh create newsite
   ```

3. **Database conflicts**
   - Each site should have unique database credentials
   - The management script automatically generates unique credentials

### Logs and Debugging
```bash
# Enable WordPress debug mode
# Set WORDPRESS_DEBUG=1 in .env file

# View real-time logs
docker-compose logs -f wordpress

# View WordPress debug logs
docker-compose exec wordpress tail -f /var/www/html/wp-content/debug.log

# View custom debug logs
docker-compose exec wordpress tail -f /var/www/html/wp-content/debug-logs/custom-debug.log

# Test debug logging
# Visit: http://localhost:8080/wp-content/plugins/test-debug-logging.php
```

### Debug Logging Issues

1. **Debug Logs Not Working**
   ```bash
   # Check if debug is enabled
   docker-compose exec wordpress wp config get WP_DEBUG
   
   # Check log file permissions
   docker-compose exec wordpress ls -la /var/www/html/wp-content/
   
   # Restart WordPress container
   docker-compose restart wordpress
   ```

2. **Custom write_log() Function Not Found**
   ```bash
   # Check if plugin is activated
   docker-compose exec wordpress wp plugin list
   
   # Activate the debug logger plugin
   docker-compose exec wordpress wp plugin activate custom-debug-logger
   ```

3. **Log Files Too Large**
   ```bash
   # Clear debug logs via WordPress admin
   # Or manually clear log files
   docker-compose exec wordpress truncate -s 0 /var/www/html/wp-content/debug.log
   docker-compose exec wordpress truncate -s 0 /var/www/html/wp-content/debug-logs/custom-debug.log
   ```

## 📈 Performance Optimization

1. **Enable Redis/Memcached** for object caching
2. **Use CDN** for static assets
3. **Optimize images** before upload
4. **Enable Gzip compression** in nginx
5. **Regular database optimization**

## 🔒 Security Best Practices

1. **Strong Passwords**: Use complex passwords for all accounts
2. **Regular Updates**: Keep WordPress, plugins, and themes updated
3. **SSL Certificate**: Always use HTTPS in production
4. **Backup Strategy**: Regular automated backups
5. **Firewall**: Configure server firewall properly
6. **Two-Factor Authentication**: Enable 2FA for admin accounts

## 📞 Support

For issues specific to this Docker setup, check:
- Docker logs: `docker-compose logs`
- WordPress debug logs
- MySQL error logs

## ❓ Frequently Asked Questions

### **General Questions**

**Q: Can I use this for production?**
A: Yes! This boilerplate is production-ready. See the [Production Deployment](#-production-deployment) section for detailed setup instructions.

**Q: How many sites can I run simultaneously?**
A: Unlimited! Each site is completely isolated with its own containers, databases, and configurations.

**Q: What's the difference between this and other WordPress Docker setups?**
A: This boilerplate includes advanced debug logging, multi-site management, complete site isolation, and comprehensive documentation.

### **Technical Questions**

**Q: Can I change the WordPress version?**
A: Yes, edit the `image` field in `docker-compose.yml`. Supported versions: `wordpress:6.4-php8.2-apache`, `wordpress:6.3-php8.1-apache`, etc.

**Q: How do I update WordPress?**
A: Update the image version in `docker-compose.yml` and run `docker-compose pull && docker-compose up -d`.

**Q: Can I use a different database?**
A: Yes, you can modify `docker-compose.yml` to use PostgreSQL, MariaDB, or external databases.

**Q: How do I backup my site?**
A: Use the backup script in the [Production Deployment](#-production-deployment) section or run:
```bash
docker-compose exec mysql mysqldump -u root -p wordpress_db > backup.sql
```

### **Multi-Site Questions**

**Q: How do I create multiple sites?**
A: Use the management script: `./manage-multiple-sites.sh create newsite`

**Q: Can sites interfere with each other?**
A: No! Each site has complete isolation with separate containers, databases, and configurations.

**Q: How do I manage multiple sites?**
A: Use the management script commands:
- `./manage-multiple-sites.sh list` - List all sites
- `./manage-multiple-sites.sh start site1` - Start a site
- `./manage-multiple-sites.sh stop site1` - Stop a site

### **Debug Logging Questions**

**Q: How do I enable debug logging?**
A: Set `WORDPRESS_DEBUG=1` in your `.env` file and restart the containers.

**Q: Where are the debug logs stored?**
A: Logs are stored in `wp-content/debug-logs/` and can be viewed in the WordPress admin.

**Q: How do I use the custom write_log() function?**
A: Simply call `write_log('Your message', 'info')` in your PHP code. See the [Debug Logging Guide](DEBUG-LOGGING-GUIDE.md) for examples.

### **Troubleshooting Questions**

**Q: I get "Container name already in use" error.**
A: Run `./manage-multiple-sites.sh fix-conflicts` to resolve container conflicts.

**Q: WordPress won't load.**
A: Check the logs: `docker-compose logs wordpress` and ensure MySQL is running: `docker-compose logs mysql`.

**Q: Can't access phpMyAdmin.**
A: Verify the port in your `.env` file and check if it's not blocked by firewall.

**Q: Database connection failed.**
A: Ensure MySQL is fully started before WordPress. Check database credentials in `.env`.

## 📝 Additional Notes

### **Data Persistence**
- WordPress files are stored in Docker volumes for persistence
- Database data survives container restarts
- Debug logs are stored in `wp-content/debug-logs/`
- Custom plugins and themes go in `wp-content/`

### **Security Considerations**
- Change default passwords before production deployment
- Use strong, unique passwords (minimum 12 characters)
- Enable SSL/HTTPS for production sites
- Regular backups and security updates
- Monitor debug logs for security issues

### **Performance Optimization**
- Resource limits are configured for optimal performance
- Health checks ensure service reliability
- Volume optimization for faster I/O
- Memory limits prevent resource exhaustion

### **Development Workflow**
- Use `write_log()` for debugging your code
- Test with multiple sites for client work
- Use the management script for easy site management
- Debug logs help identify issues quickly

---

**Happy WordPress hosting! 🎉**


# wordpress-site-docker-lightspeed-boilerplate
