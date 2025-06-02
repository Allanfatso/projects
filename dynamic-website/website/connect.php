<?php
require 'vendor/autoload.php';

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

/* Database credentials.*/
$link = mysqli_connect(
    $_ENV['DB_SERVER'], 
    $_ENV['DB_USERNAME'], 
    $_ENV['DB_PASSWORD'], 
    $_ENV['DB_NAME']
);
 
/* Attempt to connect to MySQL database */
 
// Check connection
if ($link === false) {
    die("ERROR: Could not connect. " . mysqli_connect_error());
}
?>