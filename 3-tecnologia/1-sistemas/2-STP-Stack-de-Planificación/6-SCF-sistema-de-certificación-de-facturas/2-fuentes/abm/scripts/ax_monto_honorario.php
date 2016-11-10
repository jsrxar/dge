<?php
include_once dirname(__FILE__) . '/' . 'ax_general.php';

if($idHonorario = get_param("idHonorario")){
	$conn = GetGlobalConnectionOptions();
	$key = str_pad($conn['password'], 24, "*");
	
	$sql =  "SELECT CONVERT_FROM(DECRYPT(va_honorario,'" . $key . "','AES'),'SQL_ASCII')::MONEY::NUMERIC::FLOAT\n";
	$sql .= "FROM facturas.honorario\n";
	$sql .= "WHERE id_honorario = " . $idHonorario;

	//if($debug) echo "<!--p>sql:\n" . $sql . "\n<p-->\n";

	$result = pg_query($dbc, $sql);

	if ($result) {
		$row = pg_fetch_row($result);
		echo $row[0];
	} else {
		if($debug) echo "<h3>Problema de ejecución</h3>";
	}
} else {
	if($debug) echo "<h3>Falta el parámetro idHonorario</h3>";
}
?>