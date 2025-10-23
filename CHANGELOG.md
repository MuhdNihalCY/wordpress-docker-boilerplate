# Changelog

All notable changes to the WordPress Docker Boilerplate will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Complete Site Isolation System**
  - Dynamic container names prevent conflicts
  - Separate Docker volumes per site
  - Independent networks and configurations
  - Unique database credentials per site
  - Site-specific environment files

- **Advanced Multi-Site Management**
  - `manage-multiple-sites.sh` script for site management
  - Automated port assignment and conflict resolution
  - Site creation, start, stop, and restart commands
  - Site isolation verification tools
  - Comprehensive site status monitoring

- **Enhanced Documentation**
  - Comprehensive README with badges and examples
  - Detailed FAQ section with common questions
  - Production deployment guide with step-by-step instructions
  - Security hardening procedures
  - Performance optimization guidelines

- **Production-Ready Features**
  - Complete production deployment guide
  - SSL/HTTPS configuration with Let's Encrypt
  - Automated backup scripts
  - Security hardening procedures
  - Performance monitoring and optimization

### Changed
- **Docker Configuration**
  - Dynamic container names using COMPOSE_PROJECT_NAME
  - Site-specific volume and network names
  - Enhanced health checks and monitoring
  - Improved resource limits and optimization

- **Environment Configuration**
  - Comprehensive environment.env template
  - Detailed security notes and requirements
  - Production vs development configurations
  - Advanced configuration options

- **Management Scripts**
  - Enhanced error handling and validation
  - Better user experience with colored output
  - Comprehensive help and documentation
  - Automated conflict resolution

### Fixed
- **Container Conflicts**
  - Resolved "Container name already in use" errors
  - Dynamic naming prevents conflicts between sites
  - Automatic conflict detection and resolution
  - Improved container lifecycle management

- **Site Independence**
  - Complete isolation between sites
  - No cross-site interference or data sharing
  - Independent database and file systems
  - Separate configurations and environments

## [1.0.0] - 2024-10-23

### Added
- Complete WordPress Docker environment
- MySQL 8.0 database with phpMyAdmin
- Custom debug logging plugin with `write_log()` function
- Multiple log levels (info, warning, error, debug)
- WordPress admin interface for log management
- Debug test script for functionality verification
- Comprehensive debug configuration
- Nginx reverse proxy configuration
- Environment variables management
- Production-ready Docker Compose setup
- Extensive documentation and guides
- MIT License
- Contributing guidelines

### Features
- WordPress accessible at localhost:8080
- phpMyAdmin at localhost:8081
- Debug logs admin interface
- Test script for verification
- Complete development environment setup
- Advanced debugging capabilities
- Security best practices
- Performance optimizations

### Technical Details
- WordPress 6.4 with PHP 8.2
- MySQL 8.0 with utf8mb4 support
- phpMyAdmin 5.2
- Docker Compose 3.8
- Health checks and proper dependencies
- Volume persistence for data
- Network isolation
- Memory optimization

## [0.1.0] - 2024-10-22

### Added
- Initial WordPress Docker setup
- Basic MySQL configuration
- Simple debug logging
- Basic documentation

---

## Version History

- **1.0.0**: First stable release with complete feature set
- **0.1.0**: Initial development version

## Upgrade Notes

### From 0.1.0 to 1.0.0
- Update environment variables (new port configuration)
- Run `./setup.sh` for automatic configuration
- Update Docker Compose configuration
- Review new debug logging features

## Migration Guide

### Environment Variables
The following new variables were added in v1.0.0:
- `WORDPRESS_PORT` (default: 8080)
- `PHPMYADMIN_PORT` (default: 8081)

### Docker Configuration
- Updated container names with `wp-boilerplate-` prefix
- Added health checks
- Improved service dependencies
- Enhanced security configurations

### Debug Logging
- Function names updated with `wp_debug_logger_` prefix
- Improved error handling
- Enhanced admin interface
- Better log formatting

## Support

For upgrade assistance or questions:
- Check the README.md for detailed instructions
- Review the DEBUG-LOGGING-GUIDE.md for logging features
- Open an issue on GitHub for support
- Check CONTRIBUTING.md for contribution guidelines
