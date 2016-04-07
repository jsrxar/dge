<?php
include_once dirname(__FILE__) . '/' . 'ax_general.php';

if($id_accion = get_param("id_accion")){  
	$sql = "SELECT nu_personas FROM sga_accion WHERE id_accion = " . $id_accion;
	if($debug) echo "<!--p>sql:\n" . $sql . "\n<p-->\n";
	
	$result = pg_query($dbc, $sql);
	if ($result) {
		while ($row = pg_fetch_row($result)) {
			echo $row[0];
		}
	} else {
		if($debug) echo "<h3>Problema de ejecución</h3>";
	}
} else {
	if($debug) echo "<h3>Falta el parámetro ID Acción</h3>";
}
?>
