<?php
$debug = false;

include_once dirname(__FILE__) . '/' . 'database_engine/pgsql_engine.php';
include_once dirname(__FILE__) . '/' . 'authorization.php';
include_once dirname(__FILE__) . '/' . 'phpgen_settings.php';

function get_param ($parametro) {
	if (isset($_POST[$parametro]))
		$param_val = $_POST[$parametro];
	elseif (isset($_GET[$parametro]))
		$param_val = $_GET[$parametro];
	return $param_val;
}

//if($debug) echo "<p>val0: K + md5('f4ct#r4s@" .date('Y-m-d') . "')</p>\n";
//if($debug) echo "<p>val1: 'K" . md5("f4ct#r4s@".date('Y-m-d')) . "'</p>\n";
//if($debug) echo "<p>val2: '" . get_param("idClave") . "'</p>\n";
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
$dbo = GetGlobalConnectionOptions();
$dbs  = 'host=' . $dbo['server'] . ' dbname=' . $dbo['database'] . ' port=5432';
$dbs .= " options='--application_name=Facturas;" . $dbo['password'] . "'";
$dbs .= ' user=' . $dbo['username'] . ' password=' . $dbo['password'];
//if($debug) echo "<p>dbs: " . $dbs . "</p>\n";
$dbc = @pg_connect($dbs);
if (!$dbc) {
	if($debug) echo '<h3>Imposible conectar a la Base de Datos</h3>'; 
	exit;
}
?>
