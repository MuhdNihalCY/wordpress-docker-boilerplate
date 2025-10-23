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
├── docker-compose.yml      # Main Docker Compose configuration
├── environment.env         # Environment variables template
├── nginx.conf             # Nginx reverse proxy configuration
├── wp-content/            # WordPress themes and plugins (created automatically)
└── README.md              # This file
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
WORDPRESS_DEBUG=0
```

### Port Configuration
- WordPress: Port 8080
- phpMyAdmin: Port 8081
- MySQL: Internal port 3306

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
- Always backup before making major changes

---

**Happy WordPress hosting! 🎉**


# wordpress-site-docker-lightspeed-boilerplate
