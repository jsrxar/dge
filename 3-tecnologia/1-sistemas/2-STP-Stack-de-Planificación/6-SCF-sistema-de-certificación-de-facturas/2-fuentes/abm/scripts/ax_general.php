<?php
$debug = true;

function get_param ($parametro) {
	if (isset($_POST[$parametro]))
		$param_val = $_POST[$parametro];
	elseif (isset($_GET[$parametro]))
		$param_val = $_GET[$parametro];
	return $param_val;
}

//echo "<p>val1: 'K" . md5("f4ct#r4s@".date('Y-m-d')) . "'</p>\n";
//echo "<p>val2: '" . get_param("idClave") . "'</p>\n";
if ('K'.md5("f4ct#r4s@".date('Y-m-d')) != get_param("idClave")) {
	if($debug) echo '<h3>La clave "idClave" no corresponde.</h3>'; 
	exit;
}

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
