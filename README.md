# WordPress Docker Setup for Lightspeed Server

This repository contains a complete Docker setup for running WordPress on a Lightspeed server.

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed on your server
- Basic knowledge of Docker commands
- Domain name pointing to your server (for production)

### 1. Clone and Setup
```bash
# Navigate to your project directory
cd /Users/nihalcy/Desktop/docker_site/lightspeed/site1

# Copy environment file and customize
cp environment.env .env
# Edit .env with your preferred database credentials
```

### 2. Start the Services
```bash
# Start all services
docker-compose up -d

# Check if services are running
docker-compose ps
```

### 3. Access Your WordPress Site
- **WordPress**: http://your-server-ip:8080
- **phpMyAdmin**: http://your-server-ip:8081

## 📁 Project Structure

```
site1/
├── docker-compose.yml              # Main Docker Compose configuration
├── environment.env                 # Environment variables template
├── .env                           # Environment variables (created from template)
├── nginx.conf                     # Nginx reverse proxy configuration
├── debug-config.php               # WordPress debug configuration
├── DEBUG-LOGGING-GUIDE.md         # Comprehensive debug logging guide
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
Edit the `.env` file to customize your setup:

```env
# Database Configuration
MYSQL_DATABASE=wordpress_db
MYSQL_USER=wordpress_user
MYSQL_PASSWORD=your_secure_password
MYSQL_ROOT_PASSWORD=your_root_password

# WordPress Configuration
WORDPRESS_TABLE_PREFIX=wp_
WORDPRESS_DEBUG=1
```

### Port Configuration
- WordPress: Port 8080
- phpMyAdmin: Port 8081
- MySQL: Internal port 3306

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
