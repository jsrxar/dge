<?php
// Registro general (vacío)
echo "<option value=\"\">Por favor seleccione...</option>\n";

include_once dirname(__FILE__) . '/' . 'ax_general.php';

if($id_accion = get_param("id_accion")){  
	$sql = "SELECT es.id_espacio, es.ds_referencia, ac.ds_referencia\n";
	$sql = $sql . "FROM sga_accion ac\n";
	$sql = $sql . "LEFT JOIN sga_espacio es\n";
	$sql = $sql . "ON es.id_tipo_espacio = ac.id_tipo_espacio\n";
	$sql = $sql . "AND es.id_sector = ac.id_sector\n";
	$sql = $sql . "WHERE ac.id_accion = " . $id_accion;
	
	echo "<!--p>sql:\n" . $sql . "\n<p-->\n";
	
	$result = pg_query($dbc, $sql);
	if ($result) {
		$default = true;
		while ($row = pg_fetch_row($result)) {
			if($default) echo "<option value=\"0\">Todos los espacios de \"" . $row[2] . "\"</option>\n";
			$default = false;
			echo "<option value=\"" . $row[0] . "\">" . $row[1] . "</option>\n";
		}
	} else {
		if($debug) echo "<h3>Problema de ejecución</h3>";
	}
} else {
	if($debug) echo "<h3>Falta el parámetro ID Acción</h3>";
}
?>
