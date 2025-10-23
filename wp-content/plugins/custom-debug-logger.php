<?php
/**
 * Plugin Name: WordPress Debug Logger
 * Plugin URI: https://github.com/yourusername/wordpress-docker-boilerplate
 * Description: Advanced debug logging functionality for WordPress development with custom write_log() function and admin interface.
 * Version: 1.0.0
 * Author: WordPress Docker Boilerplate
 * Author URI: https://github.com/yourusername/wordpress-docker-boilerplate
 * License: MIT
 * License URI: https://opensource.org/licenses/MIT
 * Text Domain: wp-debug-logger
 * Domain Path: /languages
 * Requires at least: 5.0
 * Tested up to: 6.4
 * Requires PHP: 7.4
 * Network: false
 *
 * @package WordPress_Debug_Logger
 * @version 1.0.0
 */

// Prevent direct access.
if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

// Define plugin constants.
define( 'WP_DEBUG_LOGGER_VERSION', '1.0.0' );
define( 'WP_DEBUG_LOGGER_PLUGIN_FILE', __FILE__ );
define( 'WP_DEBUG_LOGGER_PLUGIN_DIR', plugin_dir_path( __FILE__ ) );
define( 'WP_DEBUG_LOGGER_PLUGIN_URL', plugin_dir_url( __FILE__ ) );

/**
 * Custom write_log function for debugging.
 *
 * @since 1.0.0
 *
 * @param mixed  $log   The data to log.
 * @param string $level Log level (info, warning, error, debug).
 * @return void
 */
function write_log( $log, $level = 'info' ) {
	// Check if WP_DEBUG_LOG is enabled.
	if ( ! defined( 'WP_DEBUG_LOG' ) || ! WP_DEBUG_LOG ) {
		return;
	}

	// Create logs directory if it doesn't exist.
	$log_dir = WP_CONTENT_DIR . '/debug-logs';
	if ( ! file_exists( $log_dir ) ) {
		wp_mkdir_p( $log_dir );
	}

	// Format the log entry.
	$timestamp = current_time( 'Y-m-d H:i:s' );
	$backtrace = debug_backtrace( DEBUG_BACKTRACE_IGNORE_ARGS, 2 );
	$caller    = isset( $backtrace[1] ) ? basename( $backtrace[1]['file'] ) . ':' . $backtrace[1]['line'] : 'unknown';

	// Convert log data to string.
	if ( is_array( $log ) || is_object( $log ) ) {
		$log = print_r( $log, true );
	}

	// Create log entry.
	$log_entry = sprintf(
		"[%s] [%s] [%s] %s\n",
		$timestamp,
		strtoupper( $level ),
		$caller,
		$log
	);

	// Write to custom log file.
	$log_file = $log_dir . '/custom-debug.log';
	error_log( $log_entry, 3, $log_file );

	// Also write to WordPress debug.log if it exists.
	if ( defined( 'WP_DEBUG_LOG' ) && WP_DEBUG_LOG ) {
		error_log( $log_entry );
	}
}

/**
 * Enhanced error logging with context.
 *
 * @since 1.0.0
 *
 * @param string $message Error message.
 * @param array  $context Additional context data.
 * @return void
 */
function write_error_log( $message, $context = array() ) {
	$log_data = array(
		'message'     => $message,
		'context'     => $context,
		'user_id'     => get_current_user_id(),
		'request_uri' => isset( $_SERVER['REQUEST_URI'] ) ? $_SERVER['REQUEST_URI'] : 'unknown',
		'user_agent'  => isset( $_SERVER['HTTP_USER_AGENT'] ) ? $_SERVER['HTTP_USER_AGENT'] : 'unknown',
	);

	write_log( $log_data, 'error' );
}

/**
 * Log database queries (if WP_DEBUG is enabled).
 *
 * @since 1.0.0
 *
 * @return void
 */
function wp_debug_logger_log_database_queries() {
	if ( defined( 'WP_DEBUG' ) && WP_DEBUG && defined( 'SAVEQUERIES' ) && SAVEQUERIES ) {
		global $wpdb;

		if ( ! empty( $wpdb->queries ) ) {
			write_log(
				array(
					'total_queries' => count( $wpdb->queries ),
					'queries'       => $wpdb->queries,
				),
				'debug'
			);
		}
	}
}

/**
 * Log WordPress hooks and filters.
 *
 * @since 1.0.0
 *
 * @return void
 */
function wp_debug_logger_log_wp_hooks() {
	if ( defined( 'WP_DEBUG' ) && WP_DEBUG ) {
		global $wp_filter;

		$hook_count = 0;
		foreach ( $wp_filter as $hook_name => $hook_data ) {
			$hook_count += count( $hook_data->callbacks );
		}

		write_log(
			array(
				'total_hooks' => $hook_count,
				'hook_names' => array_keys( $wp_filter ),
			),
			'debug'
		);
	}
}

/**
 * Initialize debug logging.
 *
 * @since 1.0.0
 *
 * @return void
 */
function wp_debug_logger_init_debug_logging() {
	// Log WordPress initialization.
	write_log( 'WordPress initialized', 'info' );

	// Log current theme.
	write_log(
		array(
			'theme'          => get_template(),
			'stylesheet'     => get_stylesheet(),
			'is_child_theme' => is_child_theme(),
		),
		'info'
	);

	// Log active plugins.
	$active_plugins = get_option( 'active_plugins', array() );
	write_log(
		array(
			'active_plugins' => $active_plugins,
			'plugin_count'   => count( $active_plugins ),
		),
		'info'
	);
}

// Hook into WordPress initialization.
add_action( 'init', 'wp_debug_logger_init_debug_logging' );

// Log database queries on shutdown.
add_action( 'shutdown', 'wp_debug_logger_log_database_queries' );

// Log hooks on admin pages (optional).
if ( is_admin() ) {
	add_action( 'admin_init', 'wp_debug_logger_log_wp_hooks' );
}

/**
 * Helper function to clear debug logs.
 *
 * @since 1.0.0
 *
 * @return void
 */
function wp_debug_logger_clear_debug_logs() {
	$log_dir  = WP_CONTENT_DIR . '/debug-logs';
	$log_file = $log_dir . '/custom-debug.log';

	if ( file_exists( $log_file ) ) {
		file_put_contents( $log_file, '' );
		write_log( 'Debug logs cleared', 'info' );
	}
}

/**
 * Helper function to get debug log content.
 *
 * @since 1.0.0
 *
 * @param int $lines Number of lines to retrieve.
 * @return string Debug log content.
 */
function wp_debug_logger_get_debug_logs( $lines = 100 ) {
	$log_dir  = WP_CONTENT_DIR . '/debug-logs';
	$log_file = $log_dir . '/custom-debug.log';

	if ( ! file_exists( $log_file ) ) {
		return 'No debug logs found.';
	}

	$content     = file_get_contents( $log_file );
	$log_lines   = explode( "\n", $content );
	$recent_lines = array_slice( $log_lines, -$lines );

	return implode( "\n", $recent_lines );
}

// Add admin menu for debug tools (only for administrators).
if ( is_admin() ) {
	add_action(
		'admin_menu',
		function() {
			add_management_page(
				'Debug Logs',
				'Debug Logs',
				'manage_options',
				'debug-logs',
				'wp_debug_logger_admin_page'
			);
		}
	);
}

/**
 * Admin page for viewing debug logs.
 *
 * @since 1.0.0
 *
 * @return void
 */
function wp_debug_logger_admin_page() {
	if ( ! current_user_can( 'manage_options' ) ) {
		wp_die( 'You do not have sufficient permissions to access this page.' );
	}

	if ( isset( $_POST['clear_logs'] ) && wp_verify_nonce( $_POST['_wpnonce'], 'clear_debug_logs' ) ) {
		wp_debug_logger_clear_debug_logs();
		echo '<div class="notice notice-success"><p>Debug logs cleared successfully!</p></div>';
	}

	$logs = wp_debug_logger_get_debug_logs( 200 );

	echo '<div class="wrap">';
	echo '<h1>Debug Logs</h1>';

	echo '<form method="post" style="margin-bottom: 20px;">';
	wp_nonce_field( 'clear_debug_logs' );
	echo '<input type="submit" name="clear_logs" class="button button-secondary" value="Clear Logs" onclick="return confirm(\'Are you sure you want to clear all debug logs?\');">';
	echo '</form>';

	echo '<textarea readonly style="width: 100%; height: 500px; font-family: monospace; font-size: 12px;">';
	echo esc_textarea( $logs );
	echo '</textarea>';

	echo '</div>';
}
