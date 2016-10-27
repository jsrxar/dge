<?php
include_once dirname(__FILE__) . '/' . 'ax_general.php';

if($idAgente = get_param("idAgente")){
	$sql =  "SELECT LPAD(fa.nu_pto_venta::TEXT, 4, '0')||'-'||LPAD(fa.nu_factura::TEXT, 8, '0'),\n";
	$sql .= "  TO_CHAR(fa.fe_factura, 'DD/MM/YYYY'),\n";
	$sql .= "  fa.va_factura::NUMERIC::MONEY,\n";
	$sql .= "  TO_CHAR(fa.fe_carga, 'DD/MM/YYYY')\n";
	$sql .= "FROM contrato co\n";
	$sql .= "LEFT JOIN honorario sa ON co.id_contrato = sa.id_contrato\n";
	$sql .= "INNER JOIN factura fa  ON sa.id_honorario = fa.id_honorario\n";
	$sql .= "WHERE co.id_agente = " . $idAgente . "\n";
	$sql .= "ORDER BY fa.fe_factura";

	 echo "<!--p>sql:\n" . $sql . "\n<p-->\n";

	$result = pg_query($dbc, $sql);
	if ($result) {
		$init = true;
		if(pg_num_rows($result) > 0) {
			while ($row = pg_fetch_row($result)) {
				if($init) {
					$init = false;
?>
<table class="table pgui-record-card">
	<tbody>
		<tr><td><strong>Nro Factura</strong></td>
			<td><strong>Fecha Factura</strong></td>
			<td><strong>Monto</strong></td>
			<td><strong>Fecha Carga</strong></td></tr>
<?php
				}
				echo "\t\t<tr><td>".$row[0]."</td>\n";
				echo "\t\t\t<td>".$row[1]."</td>\n";
				echo "\t\t\t<td>".$row[2]."</td>\n";
				echo "\t\t\t<td>".$row[3]."</td></tr>\n";
			}
?>
		</tbody>
</table>
<?php
		} else {
			echo "<p class='pgui-record-card' style='padding:8px'><strong>Sin facturas registradas</strong></p><br/>";
		}
	} else {
		if($debug) echo "<h3>Problema de ejecución</h3>";
	}
} else {
	if($debug) echo "<h3>Falta el parámetro idAgente</h3>";
}
?>