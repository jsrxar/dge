<?php
// Registro general (vacío)
echo "<option value=\"\">Por favor seleccione...</option>\n";

include_once dirname(__FILE__) . '/' . 'ax_general.php';

if($id_accion = get_param("id_accion")){  
	$sql = "SELECT bi.id_bien, es.ds_referencia ||' > ' || tb.ds_referencia no_bien\n";
	$sql = $sql . "FROM sga_accion ac\n";
	$sql = $sql . "JOIN sga_bien bi ON bi.id_tipo_bien = ac.id_tipo_bien\n";
	$sql = $sql . "LEFT JOIN sga_tipo_bien tb ON tb.id_tipo_bien = ac.id_tipo_bien\n";
	$sql = $sql . "LEFT JOIN sga_espacio es ON es.id_espacio = bi.id_espacio\n";
	$sql = $sql . "WHERE ac.id_accion = " . $id_accion;
	
	echo "<!--p>sql:\n" . $sql . "\n<p-->\n";
	
	$result = pg_query($dbc, $sql);
	if ($result) {
		while ($row = pg_fetch_row($result)) {
			echo "<option value=\"" . $row[0] . "\">" . $row[1] . "</option>\n";
		}
	} else {
		if($debug) echo "<h3>Problema de ejecución</h3>";
	}
} else {
	if($debug) echo "<h3>Falta el parámetro ID Acción</h3>";
}
?>
