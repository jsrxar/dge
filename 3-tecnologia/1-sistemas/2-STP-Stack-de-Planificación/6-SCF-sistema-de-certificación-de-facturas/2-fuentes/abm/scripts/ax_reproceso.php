<?php
include_once dirname(__FILE__) . '/' . 'ax_general.php';

if($reproFull = get_param("reproFull")){
	$key = str_pad($dbo['password'], 24, "*");
	$sql = "SELECT facturas.fn_xls_procesa_cargas('" . $key . "', " . $reproFull . ");";

	if($debug) echo "<!--p>sql:\n" . $sql . "\n<p-->\n";

	$result = pg_query($dbc, $sql);
	if ($result) {
		$row = pg_fetch_row($result);
		echo "Se reprocesaron correctamente ".$row[0]." facturas";
	} else {
		if($debug) echo "Problema de ejecución";
	}
} else {
	if($debug) echo "Error en la llamada del proceso";
}
?>