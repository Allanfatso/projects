<?php

// Connect to database
require 'vendor/autoload.php';

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

$mysqli = new mysqli(
    $_ENV['DB_SERVER'],
    $_ENV['DB_USERNAME'],
    $_ENV['DB_PASSWORD'],
    $_ENV['DB_NAME']
);
if ($mysqli->connect_errno) {
    echo "Failed to connect to MySQL: " . $mysqli->connect_error;
    exit();
}

// Execute SQL query
$sql = "SELECT *
	FROM weather
	WHERE city = '{$_GET['city']}'
	AND weather_when >= DATE_SUB(NOW(), INTERVAL 10 SECOND)
	ORDER BY weather_when DESC limit 1";

$result = $mysqli -> query($sql);

// Error ?
if($result == false) {
	echo("<h4>SQL error description: " . $mysqli -> error . "</h4>");
}

// No data? Import fresh data and run query again!
if ($result->num_rows == 0) {
include('data-import.php');
$result = $mysqli -> query($sql); // Run query again after import

}

// Get data, convert to JSON and print
$row = $result -> fetch_assoc();
print json_encode($row);

// Free result set and close connection
$result -> free_result();
$mysqli -> close();

?>
