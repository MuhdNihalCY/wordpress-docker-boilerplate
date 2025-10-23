<?php
/**
 * WordPress Debug Logging Test Script
 *
 * This script tests the custom write_log() function
 * Access via: http://your-site.com/wp-content/plugins/test-debug-logging.php
 *
 * @package WordPress_Debug_Logger
 * @version 1.0.0
 */

// Load WordPress.
require_once '../../../wp-load.php';

// Check if user is logged in and has admin privileges.
if ( ! is_user_logged_in() || ! current_user_can( 'manage_options' ) ) {
	wp_die( 'You must be logged in as an administrator to run this test.' );
}
?>
<!DOCTYPE html>
<html <?php language_attributes(); ?>>
<head>
	<meta charset="<?php bloginfo( 'charset' ); ?>">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>WordPress Debug Logging Test</title>
	<style>
		body { 
			font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; 
			margin: 20px; 
			line-height: 1.6;
			color: #333;
		}
		.test-section { 
			margin: 20px 0; 
			padding: 15px; 
			border: 1px solid #ddd; 
			border-radius: 4px;
		}
		.success { 
			background-color: #d4edda; 
			border-color: #c3e6cb; 
		}
		.error { 
			background-color: #f8d7da; 
			border-color: #f5c6cb; 
		}
		pre { 
			background-color: #f8f9fa; 
			padding: 10px; 
			border-radius: 4px; 
			overflow-x: auto;
		}
		button { 
			padding: 10px 20px; 
			margin: 5px; 
			cursor: pointer; 
			border: 1px solid #ccc;
			border-radius: 4px;
			background: #f7f7f7;
		}
		button:hover {
			background: #e7e7e7;
		}
		h1 {
			color: #23282d;
		}
		h3 {
			color: #0073aa;
		}
	</style>
</head>
<body>
	<h1>WordPress Debug Logging Test</h1>
	
	<?php
	// Test 1: Simple log message.
	echo '<div class="test-section">';
	echo '<h3>Test 1: Simple Log Message</h3>';
	if ( function_exists( 'write_log' ) ) {
		write_log( 'Test log message from debug test script', 'info' );
		echo '<div class="success">✓ Simple log message written successfully</div>';
	} else {
		echo '<div class="error">✗ write_log() function not found</div>';
	}
	echo '</div>';

	// Test 2: Array logging.
	echo '<div class="test-section">';
	echo '<h3>Test 2: Array Logging</h3>';
	if ( function_exists( 'write_log' ) ) {
		$test_data = array(
			'test_id'    => 'array_test',
			'timestamp'  => time(),
			'user_id'    => get_current_user_id(),
			'test_array' => array( 'item1', 'item2', 'item3' ),
		);
		write_log( $test_data, 'info' );
		echo '<div class="success">✓ Array data logged successfully</div>';
		echo '<pre>' . esc_html( print_r( $test_data, true ) ) . '</pre>';
	} else {
		echo '<div class="error">✗ write_log() function not found</div>';
	}
	echo '</div>';

	// Test 3: Error logging.
	echo '<div class="test-section">';
	echo '<h3>Test 3: Error Logging</h3>';
	if ( function_exists( 'write_error_log' ) ) {
		write_error_log(
			'Test error message',
			array(
				'error_code'    => 999,
				'test_context'  => 'debug_test_script',
			)
		);
		echo '<div class="success">✓ Error logged successfully</div>';
	} else {
		echo '<div class="error">✗ write_error_log() function not found</div>';
	}
	echo '</div>';

	// Test 4: Different log levels.
	echo '<div class="test-section">';
	echo '<h3>Test 4: Different Log Levels</h3>';
	if ( function_exists( 'write_log' ) ) {
		write_log( 'Info level message', 'info' );
		write_log( 'Warning level message', 'warning' );
		write_log( 'Error level message', 'error' );
		write_log( 'Debug level message', 'debug' );
		echo '<div class="success">✓ All log levels tested successfully</div>';
	} else {
		echo '<div class="error">✗ write_log() function not found</div>';
	}
	echo '</div>';

	// Test 5: Check debug configuration.
	echo '<div class="test-section">';
	echo '<h3>Test 5: Debug Configuration Status</h3>';
	echo '<pre>';
	echo 'WP_DEBUG: ' . ( defined( 'WP_DEBUG' ) && WP_DEBUG ? 'Enabled' : 'Disabled' ) . "\n";
	echo 'WP_DEBUG_LOG: ' . ( defined( 'WP_DEBUG_LOG' ) && WP_DEBUG_LOG ? 'Enabled' : 'Disabled' ) . "\n";
	echo 'WP_DEBUG_DISPLAY: ' . ( defined( 'WP_DEBUG_DISPLAY' ) && WP_DEBUG_DISPLAY ? 'Enabled' : 'Disabled' ) . "\n";
	echo 'SAVEQUERIES: ' . ( defined( 'SAVEQUERIES' ) && SAVEQUERIES ? 'Enabled' : 'Disabled' ) . "\n";
	echo 'SCRIPT_DEBUG: ' . ( defined( 'SCRIPT_DEBUG' ) && SCRIPT_DEBUG ? 'Enabled' : 'Disabled' ) . "\n";
	echo '</pre>';
	echo '</div>';

	// Test 6: Show recent logs.
	echo '<div class="test-section">';
	echo '<h3>Test 6: Recent Debug Logs</h3>';
	if ( function_exists( 'wp_debug_logger_get_debug_logs' ) ) {
		$logs = wp_debug_logger_get_debug_logs( 20 );
		if ( $logs && 'No debug logs found.' !== $logs ) {
			echo '<div class="success">✓ Debug logs retrieved successfully</div>';
			echo '<pre>' . esc_html( $logs ) . '</pre>';
		} else {
			echo '<div class="error">✗ No debug logs found</div>';
		}
	} else {
		echo '<div class="error">✗ wp_debug_logger_get_debug_logs() function not found</div>';
	}
	echo '</div>';
	?>
	
	<div class="test-section">
		<h3>Actions</h3>
		<button onclick="location.reload()">Run Tests Again</button>
		<button onclick="window.open('<?php echo esc_url( admin_url( 'tools.php?page=debug-logs' ) ); ?>', '_blank')">View Debug Logs in Admin</button>
		<button onclick="if(confirm('Clear all debug logs?')) { window.location.href = '?clear_logs=1'; }">Clear Debug Logs</button>
	</div>
	
	<?php
	// Handle clear logs request.
	if ( isset( $_GET['clear_logs'] ) && function_exists( 'wp_debug_logger_clear_debug_logs' ) ) {
		wp_debug_logger_clear_debug_logs();
		echo '<div class="success">Debug logs cleared successfully!</div>';
		echo '<script>setTimeout(function(){ window.location.href = window.location.pathname; }, 2000);</script>';
	}
	?>
	
	<div class="test-section">
		<h3>Usage Examples</h3>
		<pre>
// Simple logging
write_log('This is a simple message');

// Log with level
write_log('Warning message', 'warning');

// Log arrays/objects
write_log($my_array, 'debug');

// Error logging with context
write_error_log('Something went wrong', array('error_code' => 500));

// Different log levels
write_log('Info message', 'info');
write_log('Warning message', 'warning');
write_log('Error message', 'error');
write_log('Debug message', 'debug');
		</pre>
	</div>
	
	<div class="test-section">
		<h3>Log File Locations</h3>
		<pre>
WordPress Debug Log: <?php echo esc_html( WP_CONTENT_DIR ); ?>/debug.log
Custom Debug Log: <?php echo esc_html( WP_CONTENT_DIR ); ?>/debug-logs/custom-debug.log
		</pre>
	</div>
</body>
</html>