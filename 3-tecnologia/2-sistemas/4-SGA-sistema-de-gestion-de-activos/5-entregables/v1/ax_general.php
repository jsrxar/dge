<?php
$debug = false;

if($debug) {
	ini_set('display_errors', 'On');
	error_reporting(E_ALL);
} else {
	ini_set('display_errors', 'Off');
	error_reporting(0);
}

// Conectamos a la base de datos 
include_once dirname(__FILE__) . '/' . 'phpgen_settings.php';
$dbo = GetGlobalConnectionOptions();

//echo "<!--p>\nhost=" . $dbo['server'] . "\ndbname=" . $dbo['database'] . "\nuser=" . $dbo['username'] . "\npassword=" . $dbo['password'] . "\n<p-->\n";
$dbc = pg_pconnect('host=' . $dbo['server'] . ' dbname=' . $dbo['database'] . ' user=' . $dbo['username'] . ' password=' . $dbo['password']);
if (!$dbc) {
	if($debug) echo '<h3>Imposible conectar a la Base de Datos</h3>'; 
	exit;
}
?>
