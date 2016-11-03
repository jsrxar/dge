switch($.urlParam('operation')) {
    case 'copy':
    case 'edit':
    case 'insert':
		// Edición de registro
        fn_certif_edit();
        break;
    case 'view':
		// Visualización de registro
        fn_certif_view();
        break;
    default:
		// Visualizaciones generales
		fn_certif_grid();
}

function fn_certif_edit () {
	switch($.urlParam('action')) {
		case 'cert':
		case 'edit':
			$('#co_estado_edit').val('C');
			$('label.control-label[for="fe_certificacion_edit"]').append('<span class="required-mark">*</span>');
			$('#fe_certificacion_edit').attr('data-validation','required');
			$('#fe_certificacion_edit').attr('data-required-error-message','Fecha Certificación es obligatorio.');
			$('label.control-label[for="co_nota_edit"]').append('<span class="required-mark">*</span>');
			$('#co_nota_edit').attr('data-validation','required');
			$('#co_nota_edit').attr('data-required-error-message','Número Nota es obligatorio.');
			break;
		case 'cancel':
			$('div.page-header.form-header > h1').html('Cancelar certificación del Lote');
			$('#co_estado_edit').val('P');
			$('#fe_certificacion_edit').val('');
			$('#co_nota_edit').val('');
			break;
		default:
			// Nada
	}
}

function fn_certif_view () {
	var span = "span8";
	$('div.span6').append('<div id="auxLoteCert"><h2 style="text-align:center;color:grey">Cargando Lote</h2><br></div>');
	$('div.span6').addClass(span);
	$('div.' + span).removeClass('span6');

	var today = new Date();
	var datos = {
		"idClave": "K" + MD5("f4ct#r4s@" + today.toISOString().substring(0, 10)),
		"idLoteCertif": $.urlParam('pk0')
	};

	$.ajax({
		data: datos,
		url: 'ax_lote_certif.php',
		type: 'post',
		success: function(respuesta) {
			$("#auxLoteCert").html(respuesta);
		}
	});
}

function fn_certif_grid () {
	// Modifica acciones del registro
	var loteCertif = $('.pg-row');
	var repoCertif = 'http://reportes.cck.gob.ar:8080/pentaho/api/repos/:home:horas:Lote%20Certificacion.prpt';
	var href = "";
	loteCertif.each(function() {
		var lEdit = $(this).find('td.data-operation[data-column-name="edit"] > span > a');
		var lDelete = $(this).find('td.data-operation[data-column-name="delete"] > span > a');
		var lCopy = $(this).find('td.data-operation[data-column-name="copy"] > span > a');
		switch($(this).find('td.sortable[data-column-name="co_estado_nombre"]').html()) {
			case 'PreCertificado':
				lDelete.attr('title', 'Eliminar el lote PreCertificado y liberar las facturas asociadas.');
				lEdit.html("Certificar");
				lEdit.attr('href', lEdit.attr('href') + '&action=cert');
				lEdit.attr('title', 'Certificar el lote de facturas.');
				lCopy.html("Reporte");
				lCopy.attr('href', lCopy.attr('href').replace('certificacion.php?operation=copy&pk0',
					repoCertif + '/viewer?userid=horas&password=horas&lote_certif'));
				lCopy.attr('target', '_blank');
				lCopy.attr('title', 'Generar reporte de facturas a certificar.');
				break;
			case 'Certificado':
				lDelete.removeAttr('data-modal-delete');
				lDelete.removeAttr('data-delete-handler-name');
				lDelete.html('Cancelar');
				lDelete.attr('title', 'Cancelar la certificación del lote y colocarlo como PreCertificado de nuevo.');
				lDelete.attr('href', lEdit.attr('href') + '&action=cancel');
				lEdit.attr('href', lEdit.attr('href') + '&action=edit');
				lEdit.attr('title', 'Editar la fecha y/o nota del lote certificado.');
				lCopy.html("Reporte");
				lCopy.attr('href', lCopy.attr('href').replace('certificacion.php?operation=copy&pk0',
					repoCertif + '/viewer?userid=horas&password=horas&lote_certif'));
				lCopy.attr('target', '_blank');
				lCopy.attr('title', 'Generar reporte de facturas a certificar.');
				break;
			default:
				// Nada
		}
	});
}
