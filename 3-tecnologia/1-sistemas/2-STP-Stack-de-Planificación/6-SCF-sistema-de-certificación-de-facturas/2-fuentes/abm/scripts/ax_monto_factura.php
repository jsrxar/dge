<?php
include_once dirname(__FILE__) . '/' . 'ax_general.php';

if($idFactura = get_param("idFactura")){
	$key = str_pad($dbo['password'], 24, "*");
	
	$sql =  "SELECT CONVERT_FROM(DECRYPT(va_factura,'" . $key . "','AES'),'SQL_ASCII')::MONEY::NUMERIC::FLOAT\n";
	$sql .= "FROM facturas.factura\n";
	$sql .= "WHERE id_factura = " . $idFactura;

	//if($debug) echo "<!--p>sql:\n" . $sql . "\n<p-->\n";

	$result = pg_query($dbc, $sql);

	if ($result) {
		$row = pg_fetch_row($result);
		echo $row[0];
	} else {
		if($debug) echo "<h3>Problema de ejecución</h3>";
	}
} else {
	if($debug) echo "<h3>Falta el parámetro idFactura</h3>";
}
?>