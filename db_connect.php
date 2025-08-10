<?php
$host = 'localhost';
$db   = 'alerto360';
$user = 'root'; // Change if you use a different MySQL user
$pass = '';     // Change if you have a MySQL password

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Database connection failed: " . $e->getMessage());
}
?>