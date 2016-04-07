<?php
include_once dirname(__FILE__) . '/' . 'ax_general.php';

if($id_accion = get_param("id_accion")){  
	//$sql = "SELECT hora,\n";
	//$sql = $sql . "(SELECT 'selected' FROM sga_accion WHERE id_accion = " . $id_accion . " AND POSITION(hs.hora IN fe_horas) > 0) sel \n";
	//$sql = $sql . "FROM ( SELECT LPAD(SH.H::TEXT, 2, '0') || ':' || LPAD(SM.M::TEXT, 2, '0') hora \n";
	//$sql = $sql . "FROM generate_series(0,23) AS SH(H), generate_series(0,45,15) AS SM(M) \n";
	//$sql = $sql . "GROUP BY SH.H, SM.M ORDER BY 1 ) hs\n";

	$sql = "SELECT fe_horas FROM sga_accion WHERE id_accion = " . $id_accion;
	echo "<!--p>sql:\n" . $sql . "\n<p-->\n";
	
	$result = pg_query($dbc, $sql);
	if ($result) {
		if ($row = pg_fetch_row($result)) {
			if ($row[0]) {
				echo "<p>Deje vacío para mantener los horarios asociados a la Acción:<br/>";
				echo "<strong style='font-size:medium;color:DarkBlue;'>" . $row[0] . "</strong></p>";
			}
		}
	} else {
		if($debug) echo "<h3>Problema de ejecución</h3>";
	}
} else {
	if($debug) echo "<h3>Falta el parámetro ID Acción</h3>";
}
?>
