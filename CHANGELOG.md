# Changelog

All notable changes to the WordPress Docker Boilerplate will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Automated setup script with password generation
- Health checks for all services
- Configurable port settings
- Enhanced security configurations
- Comprehensive documentation

### Changed
- Updated to WordPress 6.4 with PHP 8.2
- Improved Docker Compose configuration
- Enhanced debug logging plugin
- Better error handling and validation

### Fixed
- Container startup dependencies
- File permission issues
- Debug logging reliability

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
