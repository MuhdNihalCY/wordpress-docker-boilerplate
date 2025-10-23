<?php
/**
 * WordPress Debug Configuration
 * Simple debug setup with custom write_log() function
 * 
 * This file is automatically loaded by WordPress via docker-compose.yml
 * Mount: ./debug-config.php:/var/www/html/debug-config.php
 */

// Prevent direct access
if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

// Auto-load this file in wp-config.php
if ( file_exists( ABSPATH . 'wp-config.php' ) ) {
	require_once ABSPATH . 'debug-config.php';
}

// Only load if debug is enabled
if ( ! defined( 'WP_DEBUG' ) || ! WP_DEBUG ) {
	return;
}

// Enable debug logging
if ( ! defined( 'WP_DEBUG_LOG' ) ) {
	define( 'WP_DEBUG_LOG', true );
}

if ( ! defined( 'WP_DEBUG_DISPLAY' ) ) {
	define( 'WP_DEBUG_DISPLAY', false );
}

if ( ! defined( 'SAVEQUERIES' ) ) {
	define( 'SAVEQUERIES', true );
}

// Custom write_log function
if ( ! function_exists( 'write_log' ) ) {
	function write_log( $log, $level = 'info' ) {
		if ( ! defined( 'WP_DEBUG_LOG' ) || ! WP_DEBUG_LOG ) {
			return;
		}

		// Create logs directory
		$log_dir = WP_CONTENT_DIR . '/debug-logs';
		if ( ! file_exists( $log_dir ) ) {
			wp_mkdir_p( $log_dir );
		}

		// Format log entry
		$timestamp = current_time( 'Y-m-d H:i:s' );
		$backtrace = debug_backtrace( DEBUG_BACKTRACE_IGNORE_ARGS, 2 );
		$caller = isset( $backtrace[1] ) ? basename( $backtrace[1]['file'] ) . ':' . $backtrace[1]['line'] : 'unknown';

		// Convert data to string
		if ( is_array( $log ) || is_object( $log ) ) {
			$log = print_r( $log, true );
		}

		// Create log entry
		$log_entry = sprintf( "[%s] [%s] [%s] %s\n", $timestamp, strtoupper( $level ), $caller, $log );

		// Write to file
		$log_file = $log_dir . '/custom-debug.log';
		error_log( $log_entry, 3, $log_file );
		error_log( $log_entry );
	}
}