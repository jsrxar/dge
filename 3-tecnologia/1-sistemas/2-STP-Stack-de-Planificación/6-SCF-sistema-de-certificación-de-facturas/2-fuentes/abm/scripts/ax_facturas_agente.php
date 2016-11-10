
<?php
include_once dirname(__FILE__) . '/' . 'ax_general.php';

if($idAgente = get_param("idAgente")){
	$sql =  "SELECT TO_CHAR(fa.fe_factura, 'DD/MM/YYYY'),\n";
	$sql .= "LPAD(fa.nu_pto_venta::TEXT, 4, '0')||'-'||LPAD(fa.nu_factura::TEXT, 8, '0'),\n";
	$sql .= "fa.va_factura::NUMERIC::MONEY,\n";
	$sql .= "CASE co_categ_honorario\nWHEN 'M' THEN 'Mes '\nWHEN 'A' THEN 'Adicional '\n";
	$sql .= "WHEN 'E' THEN 'Extra '\nWHEN 'B' THEN 'Bono '\nELSE '' END || no_tipo_honorario,\n";
	$sql .= "TO_CHAR(fa.fe_carga, 'DD/MM/YYYY'),\n";
	$sql .= "(SELECT no_convenio_at FROM convenio_at WHERE id_convenio_at = ce.id_convenio_at )||\n";
	$sql .= "' #' || CAST(ce.id_certificacion AS TEXT) ||\n";
	$sql .= "CASE ce.co_estado WHEN 'P' THEN ' (PreCertif. '\n";
	$sql .= "WHEN 'C' THEN ' (Certificado ' ELSE ' (Anulado ' END ||\n";
	$sql .= "TO_CHAR(COALESCE(ce.fe_certificacion, ce.fe_creacion), 'DD/MM/YY\")\"'),\n";
	$sql .= "fa.id_factura,\n";
	$sql .= "CASE WHEN fa.fl_rechazo IS TRUE THEN 'tachado' ELSE '' END\n";
	$sql .= "FROM contrato co\n";
	$sql .= "LEFT JOIN honorario ho ON co.id_contrato = ho.id_contrato\n";
	$sql .= "INNER JOIN tipo_honorario th ON ho.id_tipo_honorario = th.id_tipo_honorario\n";
	$sql .= "INNER JOIN factura fa ON ho.id_honorario = fa.id_honorario\n";
	$sql .= "LEFT JOIN certificacion ce ON fa.id_certificacion = ce.id_certificacion\n";
	$sql .= "WHERE co.id_agente = " . $idAgente . "\n";
	$sql .= "ORDER BY fa.fe_factura DESC";

	 echo "<!--p>sql:\n" . $sql . "\n<p-->\n";

	$result = pg_query($dbc, $sql);
	if ($result) {
		$init = true;
		if(pg_num_rows($result) > 0) {
			while ($row = pg_fetch_row($result)) {
				if($init) {
					$init = false;
?>
<style type="text/css">.tachado{text-decoration:line-through;color:Grey;}</style>
<table class="table pgui-record-card">
	<tbody>
		<tr><td><strong>Honorario</strong></td>
			<td><strong>Entrega Factura</strong></td>
			<td><strong>Nro Factura</strong></td>
			<td><strong>Monto</strong></td>
			<td><strong>Fecha Carga</strong></td>
			<td><strong>Lote Certificación</strong></td></tr>
<?php
				}
				echo "\t\t<tr class='" . $row[7] . "'>\n";
				echo "\t\t\t<td>".$row[3]."</td>\n";
				echo "\t\t\t<td>".$row[0]."</td>\n";
				echo "\t\t\t<td><a href='factura.php?operation=view&amp;pk0=".$row[6]."'>".$row[1]."</a></td>\n";
				echo "\t\t\t<td>".$row[2]."</td>\n";
				echo "\t\t\t<td>".$row[4]."</td>\n";
				echo "\t\t\t<td>".$row[5]."</td>\n";
				echo "\t\t</tr>\n";
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