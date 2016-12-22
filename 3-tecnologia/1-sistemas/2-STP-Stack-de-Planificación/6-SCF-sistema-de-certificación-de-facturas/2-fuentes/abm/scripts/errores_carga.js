switch($.urlParam('operation')) {
    case 'copy':
    case 'insert':
    case 'edit':
    case 'view':
        // Nada
        break;
    default:
		// Grilla
        fn_errores_grid();
}

function fn_errores_grid () {
	if (!$("#aux_res_procesa").length > 0){
		$('div.btn-toolbar.pull-left > div.btn-group').append('<button id="btn_repro" class="btn"><i class="pg-icon-page-refresh"></i>Reproceso</button>');
		$('div.btn-toolbar.pull-left > div.btn-group').append('<button id="btn_reprofull" class="btn"><i class="pg-icon-page-refresh"></i>Reproceso Full</button>');
		$('div.btn-toolbar.pull-left').after('<div class="btn-toolbar pull-left" id="aux_res_procesa" style="margin:5px"></div>');
	}

	$('button#btn_repro').click(function() {
		reprocesa_errores_carga("false");
	});

	$('button#btn_reprofull').click(function() {
		$('#aux_res_procesa').html('');
		require(['bootbox.min'], function() {
			bootbox.animate(false);
			bootbox.confirm('Volver a procesar TODOS los Errores de la tabla?', function(confirmed) {
				if (confirmed) { reprocesa_errores_carga("true"); }
			});
		});
	});
}

function reprocesa_errores_carga(reproFull) {
	var today = new Date();
	var datos = {
		"idClave": "K" + MD5("f4ct#r4s@" + today.toISOString().substring(0, 10)),
		"reproFull": reproFull
	};
	$('#aux_res_procesa').html('Procesando...');
	$.ajax({
		data: datos,
		url: 'ax_reproceso.php',
		type: 'post',
		success: function(respuesta) {
			$('#aux_res_procesa').html(respuesta);
		}
	});
}