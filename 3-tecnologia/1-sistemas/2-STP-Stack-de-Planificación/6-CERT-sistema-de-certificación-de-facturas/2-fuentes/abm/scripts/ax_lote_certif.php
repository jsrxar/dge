<?php
include_once dirname(__FILE__) . '/' . 'ax_general.php';

if($idLoteCertif = get_param("idLoteCertif")){
	$sql =  "SELECT TO_CHAR(fa.fe_carga, 'DD/MM/YYYY'), ag.no_agente,\n";
	$sql .= "  LPAD(fa.nu_pto_venta::TEXT, 4, '0')||'-'||LPAD(fa.nu_factura::TEXT, 8, '0'),\n";
	$sql .= "  TO_CHAR(fa.fe_factura, 'DD/MM/YYYY'),\n";
	$sql .= "  fa.va_factura::NUMERIC::MONEY\n";
	$sql .= "FROM factura fa\n";
	$sql .= "LEFT JOIN salario sa  ON sa.id_salario = fa.id_salario\n";
	$sql .= "LEFT JOIN contrato co ON co.id_contrato = sa.id_contrato\n";
	$sql .= "LEFT JOIN agente ag   ON ag.id_agente = co.id_agente\n";
	$sql .= "LEFT JOIN convenio_at at ON at.id_convenio_at = co.id_convenio_at\n";
	$sql .= "WHERE fa.id_certificacion = " . $idLoteCertif;

	echo "<!--p>sql:\n" . $sql . "\n<p-->\n";

	$result = pg_query($dbc, $sql);
	if ($result) {
		$init = true;
		while ($row = pg_fetch_row($result)) {
			if($init) {
				$init = false;
?>
<table class="table pgui-record-card">
	<tbody>
		<tr><td><strong>Carga</strong></td>
			<td><strong>Agente</strong></td>
			<td><strong>Nro Factura</strong></td>
			<td><strong>Fecha Factura</strong></td>
			<td><strong>Monto</strong></td></tr>
<?php
			}
			echo "\t\t<tr><td>".$row[0]."</td>\n";
			echo "\t\t\t<td>".$row[1]."</td>\n";
			echo "\t\t\t<td>".$row[2]."</td>\n";
			echo "\t\t\t<td>".$row[3]."</td>\n";
			echo "\t\t\t<td>".$row[4]."</td></tr>\n";
		}
?>
		</tbody>
</table>
<?php
	} else {
		if($debug) echo "<h3>Problema de ejecución</h3>";
	}
} else {
	if($debug) echo "<h3>Falta el parámetro idLoteCertif</h3>";
}
?>