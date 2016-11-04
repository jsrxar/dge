<!DOCTYPE html>
<html dir="">
<head>
	<meta charset="UTF-8">

	<meta http-equiv="X-UA-Compatible" content="IE=8, IE=9, IE=10">
	<title>Lote Certificación</title>

	<link rel="stylesheet" type="text/css" href="components/css/main.css" />

	<script src="components/js/jquery/jquery.min.js"></script>
	<script src="components/js/libs/amplify.store.js"></script>
	<script src="components/js/bootstrap/bootstrap.js"></script>

	<script type="text/javascript" src="components/js/require-config.js"></script>
	<script type="text/javascript" src="components/js/user.js"></script>
	<script type="text/javascript" data-main="pgui.view-page-main" src="components/js/require.js"></script>

	<script>
		require(['pgui.layout'], function(layout_manager){
			layout_manager.fixLayout();
		});
	</script>

	<script>
		function EditValidation (fieldValues, errorInfo) { ; return true; }
		function InsertValidation(fieldValues, errorInfo) { ; return true; }
		function EditForm_EditorValuesChanged(sender, editors) { ; return true; }
		function InsertForm_EditorValuesChanged(sender, editors) { ; return true; }
		function EditForm_initd(editors) { ; return true; }
		function InsertForm_initd(editors) { ; return true; }
	</script>
</head>
<body>

<div class="navbar" id="navbar">
	<div class="navbar-inner">
		<div class="container">
			<div class="pull-left"><h1 style="text-align:right">Facturas</h1></div>
			<ul id="login-panel" class="nav pull-right">
				<li class="active"><a href="#" onclick="return false;" style="cursor: default;"><i class="pg-icon-user"></i>facturas</a></li>
				<li><a href="login.php?operation=logout">Salir</a></li>
			</ul>
		</div>
	</div>
</div>

<div class="container-fluid">
	<div class="row-fluid">
		<div class="span3 expanded" id="side-bar">
			<div class="sidebar-nav-fixed">
				<a href="#" class="close" style="margin: 4px 4px 0 0"><i class="icon-chevron-left"></i></a>
				<div class="content">
					<div class="sidebar-nav">
						<ul class="nav nav-list pg-page-list">
							<li class="nav-header">Facturas</li>
								<li><a href="factura.php"       title="Factura">                    <i class="page-list-icon"></i>Factura</a></li>
								<li class="divider"></li>
								<li><a href="certificacion.php" title="Lote Certificación">         <i class="page-list-icon"></i>Lote Certificación</a></li>
							<li class="nav-header">Agentes</li>
								<li><a href="agente.php"        title="Agente">                     <i class="page-list-icon"></i>Agente</a></li>
								<li class="divider"></li>
								<li><a href="dependencia.php"   title="Dependencia">                <i class="page-list-icon"></i>Dependencia</a></li>
								<li><a href="ubicacion_fisica.php" title="Ubicacion Fisica">        <i class="page-list-icon"></i>Ubicacion Fisica</a></li>
								<li><a href="puesto.php"        title="Puesto">                     <i class="page-list-icon"></i>Puesto</a></li>
								<li><a href="honorario.php"     title="Honorario">                  <i class="page-list-icon"></i>Honorario</a></li>
							<li class="nav-header">Contratos</li>
								<li><a href="contrato.php"      title="Contrato">                   <i class="page-list-icon"></i>Contrato</a></li>
								<li class="divider"></li>
								<li><a href="tipo_contrato.php" title="Tipo Contrato">              <i class="page-list-icon"></i>Tipo Contrato</a></li>
								<li><a href="categoria_lm.php"  title="Categoria Ley Marco">        <i class="page-list-icon"></i>Categoria LM</a></li>
								<li><a href="convenio_at.php"   title="Convenio Asistencia Tecnica"><i class="page-list-icon"></i>Convenio AT</a></li>
						</ul>
					</div>
				</div>
			</div>

			<script>
			$('.sidebar-nav-fixed').css('top',
				Math.max(0, $('#navbar').outerHeight() - $(window).scrollTop())
			);
			$('#navbar img').load(function() {
				$('.sidebar-nav-fixed').css('top',
					Math.max(0, $('#navbar').outerHeight() - $(window).scrollTop())
				);
			});
			$(window).scroll(function() {
				$('.sidebar-nav-fixed').css('top',
						Math.max(0, $('#navbar').outerHeight() - $(window).scrollTop())
				);
			});
			</script>

		</div>
		<div class="span9" id="content-block">
			<script>
			var sideBarContainer = $('#side-bar');
			var sidebar = $('#side-bar .sidebar-nav-fixed');
			var toggleButton = sidebar.find('a.close');
			var toggleButtonIcon = toggleButton.children('i');

			function hideSideBar() {
				sideBarContainer.removeClass('expanded');
				sidebar.children('.content').hide();
				sideBarContainer.width(20);
				toggleButtonIcon.removeClass('icon-chevron-left');
				toggleButtonIcon.addClass('icon-chevron-right');
				$('#content-block').css('left', 0);
				$('#content-block').addClass('span10');
				$('#content-block').removeClass('span9');
			}

			function showSideBar() {
				sideBarContainer.addClass('expanded');
				sidebar.children('.content').show();
				sideBarContainer.width(240);
				toggleButtonIcon.addClass('icon-chevron-left');
				toggleButtonIcon.removeClass('icon-chevron-right');
				$('#content-block').css('left', 240);
				$('#content-block').removeClass('span10');
				$('#content-block').addClass('span9');
			}

			if (amplify.store('side-bar-collapsed')) {
				hideSideBar();
			}

			toggleButton.click(function(e) {
				e.preventDefault();
				if (sideBarContainer.hasClass('expanded')) {
					hideSideBar();
					amplify.store('side-bar-collapsed', true);
				}
				else {
					showSideBar();
					amplify.store('side-bar-collapsed', false);
				}
			});
			</script>
			<div id="pgui-view-grid">
				<div class="page-header">
					<h1>Lote a Certificar</h1>
				</div>
				<div class="container-fluid">
				<br>
<?php
include_once dirname(__FILE__) . '\ax_general.php';

if($idsToCertif = get_param("idsToCertif")){
	if($operation = get_param("operation")){
		if($operation == "view") {
			$sql =  "SELECT at.id_convenio_at, at.no_convenio_at,\n";
			$sql .= "  TO_CHAR(fa.fe_carga, 'DD/MM/YYYY'), ag.no_agente,\n";
			$sql .= "  LPAD(fa.nu_pto_venta::TEXT, 4, '0')||'-'||LPAD(fa.nu_factura::TEXT, 8, '0'),\n";
			$sql .= "  TO_CHAR(fa.fe_factura, 'DD/MM/YYYY'),\n";
			$sql .= "  fa.va_factura::NUMERIC::MONEY\n";
			$sql .= "FROM factura fa\n";
			$sql .= "LEFT JOIN honorario sa ON sa.id_honorario = fa.id_honorario\n";
			$sql .= "LEFT JOIN contrato co  ON co.id_contrato = sa.id_contrato\n";
			$sql .= "LEFT JOIN agente ag    ON ag.id_agente = co.id_agente\n";
			$sql .= "LEFT JOIN convenio_at at ON at.id_convenio_at = co.id_convenio_at\n";
			$sql .= "WHERE fa.fl_rechazo IS FALSE\n";
			$sql .= "  AND fa.id_certificacion IS NULL\n";
			$sql .= "  AND fa.id_factura IN (" . $idsToCertif . ")";

			if($debug) echo "<!--p>sql:\n" . $sql . "\n<p-->\n";

			$result = pg_query($dbc, $sql);
			if ($result) {
				$init = true;
				while ($row = pg_fetch_row($result)) {
					if($init) {
						$init = false;
						$idConvenioAT = $row[0];
?>
					<div class="row-fluid">
						<div class="span10">
							<table class="table pgui-record-card">
								<tbody>
									<tr><td><strong>Nuevo Lote</strong></td><td></td></tr>
									<tr><td><strong>Convenio AT</strong></td><td><?php echo $row[1] ?></td></tr>
									<tr><td><strong>Estado Lote</strong></td><td>Nuevo</td></tr>
									<tr><td><strong>Cantidad Facturas</strong></td><td><?php echo pg_num_rows($result) ?></td></tr>
								</tbody>
							</table>
							<br>
							<table class="table pgui-record-card">
								<tbody>
									<tr><td><strong>Carga</strong></td>
										<td><strong>Agente</strong></td>
										<td><strong>Nro Factura</strong></td>
										<td><strong>Fecha Factura</strong></td>
										<td><strong>Monto</strong></td></tr>
<?php
					}
					echo "<tr><td>".$row[2]."</td><td>".$row[3]."</td><td>".$row[4]."</td><td>".$row[5]."</td><td>".$row[6]."</td></tr>\n";
				}
?>
								</tbody>
							</table>
						</div>
					</div>
					<form class="form-horizontal" enctype="multipart/form-data" method="POST" action="certificar_lote.php" novalidate="novalidate">
						<input type="hidden" name="idClave" value="<?php echo get_param("idClave") ?>">
						<input type="hidden" name="idsToCertif" value="<?php echo get_param("idsToCertif") ?>">
						<input type="hidden" name="idConvenioAT" value="<?php echo $idConvenioAT ?>">
						<input type="hidden" name="operation" value="create">
						<div class="row-fluid">
							<div class="btn-toolbar">
								<div class="btn-group">
									<button type="submit" id="submit-button" class="btn btn-primary submit-button">Grabar</button>
									<button class="btn" onclick="window.location.href='certificacion.php?operation=return'; return false;">Cancelar</button>
								</div>
							</div>
						</div>
					</form>
<?php
			} else {
				if($debug) echo "<h3>Problema de ejecucion en la consulta</h3>";
			}
		} else if($operation == "create") {
			$idConvenioAT = get_param("idConvenioAT");

			$sql =  "INSERT INTO certificacion (id_convenio_at, co_estado) VALUES (" . $idConvenioAT . ", 'P') RETURNING currval('certificacion_sq')";
			if($debug) echo "<!--p>sql:\n" . $sql . "\n<p-->\n";

			$result = pg_query($dbc, $sql);
			if ($result) {
				$idCertif = pg_fetch_row($result);

				$sql =  "UPDATE factura\n";
				$sql .= "SET id_certificacion = " . $idCertif[0] . "\n";
				$sql .= "WHERE fl_rechazo IS FALSE\n";
				$sql .= "  AND id_certificacion IS NULL\n";
				$sql .= "  AND id_factura IN (" . $idsToCertif . ")";
				if($debug) echo "<!--p>sql:\n" . $sql . "\n<p-->\n";

				$result = pg_query($dbc, $sql);
				if ($result) {
					echo "<script> location.replace('certificacion.php?operation=view&pk0=" . $idCertif[0] . "'); </script>";
					die();
				} else {
					if($debug) echo "<h3>Problema de ejecucion en la actualizacion de las facturas</h3>";
				}
			} else {
				if($debug) echo "<h3>Problema de ejecucion en la creacion del lote</h3>";
			}
		} else {
			if($debug) echo "<h3>Operacion no reconocida</h3>";
		}
	} else {
		if($debug) echo "<h3>Falta el parámetro operation</h3>";
	}
} else {
	if($debug) echo "<h3>Falta el parámetro idsToCertif</h3>";
}
?>
				</div>
			</div>
			<hr>
			<footer><p></p></footer>
		</div>
	</div>
</div>

</body>
</html>
