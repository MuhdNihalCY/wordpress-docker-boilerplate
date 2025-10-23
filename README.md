# WordPress Docker Boilerplate

Simple, production-ready WordPress Docker setup with MySQL and phpMyAdmin.

## Quick Start

```bash
# Clone and setup
git clone https://github.com/MuhdNihalCY/wordpress-docker-boilerplate.git
cd wordpress-docker-boilerplate
./setup.sh

# Access your site
open http://localhost:8080
```

## Multi-Site Management

```bash
# Create multiple sites
./manage.sh create site1
./manage.sh create site2

# Manage sites
./manage.sh start site1
./manage.sh stop site1
./manage.sh list
```

## Configuration

Edit `.env` file:
```env
# Database
MYSQL_DATABASE=wordpress_db
MYSQL_USER=wordpress_user
MYSQL_PASSWORD=your_password

# WordPress
WORDPRESS_DEBUG=1

# Ports
WORDPRESS_PORT=8080
PHPMYADMIN_PORT=8081
```

## Access Points

- **WordPress**: http://localhost:8080
- **Admin**: http://localhost:8080/wp-admin
- **phpMyAdmin**: http://localhost:8081

## Debug Logging

The boilerplate includes a custom `write_log()` function built into debug-config.php:

```php
// In your PHP code
write_log('Debug message', 'info');
write_log($variable, 'debug');
```

Logs are stored in `wp-content/debug-logs/` (created automatically).

## Production Deployment

1. **Update .env**:
   ```env
   WORDPRESS_DEBUG=0
   MYSQL_PASSWORD=strong_password
   WORDPRESS_URL=https://yourdomain.com
   ```

2. **Deploy**:
   ```bash
   docker-compose up -d
   ```

3. **Setup SSL** (optional):
   ```bash
   # Use nginx.conf with Let's Encrypt
   sudo certbot --nginx -d yourdomain.com
   ```

## Commands

```bash
# Basic Docker commands
docker-compose up -d          # Start
docker-compose down           # Stop
docker-compose logs           # View logs

# Management script
./manage.sh create newsite    # Create site
./manage.sh start newsite     # Start site
./manage.sh stop newsite      # Stop site
./manage.sh list             # List sites
```

## Troubleshooting

**Container conflicts**: Each site uses unique container names
**Port conflicts**: Script automatically finds available ports
**Database issues**: Check MySQL container logs: `docker-compose logs mysql`

## Features

- ✅ WordPress 6.4 + PHP 8.2 + MySQL 8.0
- ✅ Complete site isolation for multiple sites
- ✅ Built-in debug logging with write_log() function
- ✅ Production-ready configuration
- ✅ Simple management scripts
- ✅ Health checks and auto-restart

## License

MIT License - see LICENSE file