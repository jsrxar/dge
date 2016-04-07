<?php
// Registro general (vacío)
echo "<option value=\"\">Please select...</option>\n";

include_once dirname(__FILE__) . '/' . 'ax_general.php';

if (isset($_POST["id_accion"]))
	$id_accion = $_POST["id_accion"];
elseif (isset($_GET["id_accion"]))
	$id_accion = $_GET["id_accion"];

if(isset($id_accion)){  
	$sql = "SELECT bi.id_bien, te.ds_referencia ||' > ' ||\n";
	$sql = $sql . "CASE nu_planta WHEN 0 THEN 'PB' ELSE nu_planta::text||'ºP' END\n";
	$sql = $sql . "|| ' > ' || TRIM(es.no_espacio) ||' > ' ||tb.ds_referencia no_bien\n";
	$sql = $sql . "FROM ods_accion ac\n";
	$sql = $sql . "JOIN ods_bien bi ON bi.id_tipo_bien = ac.id_tipo_bien\n";
	$sql = $sql . "LEFT JOIN ods_tipo_bien tb ON tb.id_tipo_bien = ac.id_tipo_bien\n";
	$sql = $sql . "LEFT JOIN ods_espacio es ON es.id_espacio = bi.id_espacio\n";
	$sql = $sql . "LEFT JOIN ods_tipo_espacio te ON te.id_tipo_espacio = es.id_tipo_espacio\n";
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
