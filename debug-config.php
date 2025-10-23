<?php
/**
 * WordPress Debug Configuration
 * 
 * This file contains debug settings for WordPress development
 * Place this in your wp-config.php or include it
 */

// Enable WordPress debugging
define('WP_DEBUG', true);

// Enable debug logging to /wp-content/debug.log
define('WP_DEBUG_LOG', true);

// Display errors and warnings on screen (disable for production)
define('WP_DEBUG_DISPLAY', true);

// Use dev versions of core JS and CSS files
define('SCRIPT_DEBUG', true);

// Save database queries for analysis
define('SAVEQUERIES', true);

// Disable file editing in WordPress admin
define('DISALLOW_FILE_EDIT', true);

// Increase memory limit for debugging
ini_set('memory_limit', '256M');

// Set error reporting level
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Log PHP errors to WordPress debug log
ini_set('log_errors', 1);
ini_set('error_log', WP_CONTENT_DIR . '/debug.log');

// Additional debugging constants
define('WP_CACHE', false);
define('COMPRESS_CSS', false);
define('COMPRESS_SCRIPTS', false);
define('ENFORCE_GZIP', false);

// Custom error handler for better debugging
function custom_error_handler($errno, $errstr, $errfile, $errline) {
    if (!(error_reporting() & $errno)) {
        return false;
    }
    
    $error_types = [
        E_ERROR => 'ERROR',
        E_WARNING => 'WARNING',
        E_PARSE => 'PARSE',
        E_NOTICE => 'NOTICE',
        E_CORE_ERROR => 'CORE_ERROR',
        E_CORE_WARNING => 'CORE_WARNING',
        E_COMPILE_ERROR => 'COMPILE_ERROR',
        E_COMPILE_WARNING => 'COMPILE_WARNING',
        E_USER_ERROR => 'USER_ERROR',
        E_USER_WARNING => 'USER_WARNING',
        E_USER_NOTICE => 'USER_NOTICE',
        E_STRICT => 'STRICT',
        E_RECOVERABLE_ERROR => 'RECOVERABLE_ERROR',
        E_DEPRECATED => 'DEPRECATED',
        E_USER_DEPRECATED => 'USER_DEPRECATED'
    ];
    
    $error_type = isset($error_types[$errno]) ? $error_types[$errno] : 'UNKNOWN';
    
    $message = sprintf(
        "[%s] PHP %s: %s in %s on line %d",
        date('Y-m-d H:i:s'),
        $error_type,
        $errstr,
        $errfile,
        $errline
    );
    
    error_log($message);
    
    // Also log to custom debug log if function exists
    if (function_exists('write_log')) {
        write_log($message, 'error');
    }
    
    return true;
}

// Set custom error handler
set_error_handler('custom_error_handler');

// Custom exception handler
function custom_exception_handler($exception) {
    $message = sprintf(
        "[%s] Uncaught Exception: %s in %s on line %d",
        date('Y-m-d H:i:s'),
        $exception->getMessage(),
        $exception->getFile(),
        $exception->getLine()
    );
    
    error_log($message);
    
    // Also log to custom debug log if function exists
    if (function_exists('write_log')) {
        write_log($message, 'error');
    }
}

// Set custom exception handler
set_exception_handler('custom_exception_handler');

// Log WordPress initialization
if (function_exists('write_log')) {
    write_log('Debug configuration loaded', 'info');
}
