?>
<script>
	if ( $( "div.sidebar-nav-fixed" ).length && !$( "#sga_reportes" ).length ) {
		// Armando arreglo de reportes
		var rep_dir = 'http://10.13.18.133:8080/pentaho/api/repos/:home:sga';
		var rep_nom = [
			["Orden de Trabajo",     rep_dir, "Orden Trabajo.prpt",          "userid=sga&password=sga"],
			["Plan General Mensual", rep_dir, "Plan General - Mensual.prpt", "userid=sga&password=sga"],
			["Plan General Semanal", rep_dir, "Plan General - Semanal.prpt", "userid=sga&password=sga"]
		];

		// Armando HTML de llamada
		var rep_div = '<div class="content"><div class="sidebar-nav"><ul class="nav nav-list pg-page-list">\n';
		rep_div += '<li class="nav-header">Reportes</li>';
		for	(index = 0; index < rep_nom.length; index++) {
			rep_div += '<li><a href="'+rep_nom[index][1]+':'+encodeURIComponent(rep_nom[index][2])+'/viewer?'+rep_nom[index][3];
			rep_div += '" target="_blank" title="'+rep_nom[index][0]+'"><i class="page-list-icon"></i> '+rep_nom[index][0]+'</a></li>';
		}
		rep_div += '</ul></div></div>';

		// Agregando HTML generado al reporte
		$( "div.sidebar-nav-fixed" ).append(rep_div);
	}
</script>
