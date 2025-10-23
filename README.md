# WordPress Docker Boilerplate

A complete, production-ready WordPress Docker setup with advanced debug logging capabilities. Perfect for developers who want to quickly spin up a WordPress development environment or deploy to production.

## ✨ Features

- 🐳 **Complete Docker Environment**: WordPress + MySQL 8.0 + phpMyAdmin
- 🐛 **Advanced Debug Logging**: Custom `write_log()` function with multiple log levels
- 🔧 **Production Ready**: Nginx reverse proxy configuration included
- 📊 **Database Management**: phpMyAdmin for easy database administration
- 🚀 **One-Command Setup**: Get started in minutes
- 📖 **Comprehensive Documentation**: Detailed guides and examples
- 🔒 **Security Focused**: Best practices and security configurations
- 🎯 **Developer Friendly**: Debug tools, logging, and testing scripts

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- Git (for cloning)
- Basic terminal knowledge

### 1. Clone the Repository
```bash
git clone https://github.com/MuhdNihalCY/wordpress-docker-boilerplate.git
cd wordpress-docker-boilerplate
```

### 2. Quick Setup
```bash
# Run the setup script (recommended)
./setup.sh

# OR manually setup
cp environment.env .env
# Edit .env with your preferred settings
```

### 3. Start WordPress
```bash
docker-compose up -d
```

### 4. Access Your Site
- **WordPress**: http://localhost:8080
- **phpMyAdmin**: http://localhost:8081
- **WordPress Admin**: http://localhost:8080/wp-admin

## 📁 Project Structure

```
wordpress-docker-boilerplate/
├── docker-compose.yml              # Main Docker Compose configuration
├── environment.env                 # Environment variables template
├── .env                           # Your environment variables (create from template)
├── nginx.conf                     # Nginx reverse proxy configuration
├── debug-config.php               # WordPress debug configuration
├── DEBUG-LOGGING-GUIDE.md         # Comprehensive debug logging guide
├── setup.sh                       # Automated setup script
├── manage-multiple-sites.sh       # Multi-site management script
├── .gitignore                     # Git ignore file
├── LICENSE                        # MIT License
├── CONTRIBUTING.md                # Contribution guidelines
├── CHANGELOG.md                   # Version history and changes
├── wp-content/                    # WordPress themes and plugins
│   ├── plugins/
│   │   ├── custom-debug-logger.php    # Custom debug logging plugin
│   │   └── test-debug-logging.php      # Debug logging test script
│   ├── debug-logs/                # Custom debug logs directory
│   └── debug.log                  # WordPress debug log
└── README.md                      # This file
```

## 🔧 Configuration

### Environment Variables
The `.env` file contains all configuration settings. Copy from `environment.env` and customize:

```env
# Database Configuration
MYSQL_DATABASE=wordpress_db
MYSQL_USER=wordpress_user
MYSQL_PASSWORD=your_secure_password_here
MYSQL_ROOT_PASSWORD=your_root_password_here

# WordPress Configuration
WORDPRESS_TABLE_PREFIX=wp_
WORDPRESS_DEBUG=1

# Optional: Custom domain (for production)
# WORDPRESS_URL=http://yourdomain.com
# WORDPRESS_HOME=http://yourdomain.com
```

### Port Configuration
- **WordPress**: Port 8080 (change if needed)
- **phpMyAdmin**: Port 8081 (change if needed)
- **MySQL**: Internal port 3306

### Customization Options
- Change ports in `docker-compose.yml`
- Modify database credentials in `.env`
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

## 🔀 Running Multiple Sites

You can easily run multiple WordPress sites on the same system using different approaches:

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

### **Best Practices for Multiple Sites**

1. **Use descriptive project names** (`-p site1`, `-p site2`)
2. **Different ports** for each site
3. **Separate databases** for each site
4. **Individual .env files** for each site
5. **Resource monitoring** to prevent conflicts
6. **Regular backups** for each site
7. **SSL certificates** for production sites

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

### 1. Domain Setup
1. Point your domain to your server's IP address
2. Update the nginx.conf file with your domain name
3. Obtain SSL certificates (Let's Encrypt recommended)

### 2. Security Considerations
- Change default passwords in `.env`
- Use strong, unique passwords
- Enable SSL/HTTPS
- Regular backups of MySQL data
- Keep WordPress and plugins updated

### 3. Using Nginx Reverse Proxy
If you want to use Nginx as a reverse proxy:

```bash
# Add nginx service to docker-compose.yml
# Mount nginx.conf to your nginx container
# Update port mappings accordingly
```

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

### Common Issues

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

## 📝 Notes

- This setup uses Docker volumes for persistent data
- WordPress files are stored in `wordpress_data` volume
- MySQL data is stored in `mysql_data` volume
- Custom themes/plugins should be placed in `wp-content/` directory
- Debug logging is enabled by default for development
- Custom `write_log()` function is available for advanced logging
- Debug logs are stored in `/wp-content/debug-logs/` directory
- Always backup before making major changes
- Disable debug logging (`WORDPRESS_DEBUG=0`) in production

---

**Happy WordPress hosting! 🎉**


# wordpress-site-docker-lightspeed-boilerplate
