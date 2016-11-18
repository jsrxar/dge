switch($.urlParam('operation')) {
    case 'copy':
    case 'insert':
		// Inserción de registro
        fn_factura_insert();
        break;
    case 'edit':
		// Edición de registro
        fn_factura_edit();
        break;
    case 'view':
        // Nada
        break;
    default:
		// Certificación de Facturas
        fn_factura_grid();
}

function fn_factura_insert () {
	// Crea campo auxiliar de monto
	if ($("#va_factura_aux").length > 0){
		$("#va_factura_aux").val(monto);
	} else {
		$("#va_factura_edit").before('<input type="hidden" id="va_factura_aux" value="">');
	}

	// Ocultar campo "Rechazada?" en creación
	$('label[for="fl_rechazo_edit"]').hide();
	$('#fl_rechazo_edit').hide();

	// Ocultar la botonera de carga de archivo
	$('div.btn-group[data-toggle="buttons-radio"]').hide();
	$('div.controls > br').hide();
	$('input[type="file"]').css({"width":"+=60px","vertical-align":"middle"});

	// Al cambiar honorario...
	$("#id_honorario_edit").bind("DOMSubtreeModified", function(){
		// Agrandar combos de "CUIT" y "Honorarios"
		$(".select2-container").css("width", "532px");
		
		// Poner monto por defecto
		if($("#select2-chosen-4").html().indexOf("$") > 0 ) {
			var monto = $("#select2-chosen-4").html().split("(")[1];
			monto = monto.split(")")[0];
			monto = monto.replace("$","").replace(".","").replace(",",".");
			$("#va_factura_edit").val(monto);
			$("#va_factura_aux").val(monto);
			commentOblig (false);
		}
	});
	
	$("#va_factura_edit").focusout(function() {
		commentOblig ($("#va_factura_edit").val() != $("#va_factura_aux").val());
	});
}

function fn_factura_edit () {
	// Modifica ancho de mensaje de archivo
	$('input[type="file"]').css({"width":"+=60px","vertical-align":"middle"});
	
	// Al cambiar honorario...
	$("#id_honorario_edit").bind("DOMSubtreeModified", function(){
		// Agrandar combos de "CUIT" y "Honorarios"
		$(".select2-container").css("width", "532px");
	});

	// Al hacer click en "Rechazada?" hace obligatorio el comentario
	$('#fl_rechazo_edit').change(function(){
		commentOblig ($('#fl_rechazo_edit').prop('checked'));
	});

	// Desencripta el monto de la factura
	var today = new Date();
	var datos = {
		"idClave": "K" + MD5("f4ct#r4s@" + today.toISOString().substring(0, 10)),
		"idFactura": $.urlParam('pk0')
	};
	$.ajax({
		data: datos,
		url: 'ax_monto_factura.php',
		type: 'post',
		success: function(respuesta) {
			$('#va_factura_edit').val(respuesta);
		}
	});
}

function fn_factura_grid () {
	//$("#public_facturaGrid").css("min-width", "1200px");
	$("table.pgui-grid > tbody > tr > td").css({"padding":"0px","padding-left":"2px","padding-right":"2px"});

	// Cambiar "SetAllowDeleteSelected(false);" por "SetAllowDeleteSelected(true);"
	if($('td.row-selection input[type=checkbox]').length > 0) {
		$('div.btn-toolbar.pull-left').before('<button class="btn rrhh-certif-selected"><i class="pg-icon-export"></i>Certificar facturas</button>');
	}
	$('button.delete-selected').hide();

	// Copiado de "deleteSelectedButton" en "components\js\pgui.grid.js"
	$('button.rrhh-certif-selected').click(function() {
		require(['bootbox.min'], function() {
			bootbox.animate(false);
			bootbox.confirm('Certificar las facturas seleccionadas?', function(confirmed) {
				if (confirmed) { certifSelectRows(); }
			});
		});
	});
}

function commentOblig (obligat) {
	if(obligat) {
		if (!$('label.control-label[for="ds_comentario_edit"] > span.required-mark').length > 0){
			$('label.control-label[for="ds_comentario_edit"]').append('<span class="required-mark">*</span>');
		}
		$('#ds_comentario_edit').attr('data-validation','required');
		$('#ds_comentario_edit').attr('data-required-error-message','Comentario Factura es obligatorio.');
	} else {
		$('label.control-label[for="ds_comentario_edit"] > span.required-mark').remove();
		$('#ds_comentario_edit').removeAttr('data-validation');
		$('#ds_comentario_edit').removeAttr('data-required-error-message');
	}
}

function certifSelectRows() {
	var rowsToCertif = $('.pg-row').filter(function() {
		return $(this).find('td.row-selection input[type=checkbox]').prop('checked') ? true : false;
	});
	if(rowsToCertif.length == 0) {
		bootbox.alert('Ninguna factura seleccionada.<br>Elija facturas del mismo convenio AT con "Lote Certificacion" en blanco para certificar.');
	} else {
		var idsToCertif = [];
		var hayCertif = 0;
		var haySinConv = 0;
		var convenioAT = [];
		rowsToCertif.each(function() {
			idsToCertif.push($(this).find('td.row-selection input[type=hidden]').val());
			if($(this).find('td[data-column-name=id_certificacion_nombre]').html() != '<em class="pgui-null-value">NULL</em>') {
				hayCertif += 1;
			}
			if($(this).find('td[data-column-name=id_convenio_at_no_convenio_at]').html() != '<em class="pgui-null-value">NULL</em>') {
				if(convenioAT.indexOf($(this).find('td[data-column-name=id_convenio_at_no_convenio_at]').html()) < 0)
					convenioAT.push($(this).find('td[data-column-name=id_convenio_at_no_convenio_at]').html());
			} else {
				haySinConv += 1;
			}
		});
		if(hayCertif > 0) {
			bootbox.alert('Hay ' + hayCertif + ' factura/s ya asociada/s a un lote.<br>Elija solo facturas con "Lote Certificacion" en blanco.');
		} else if(haySinConv > 0) {
			bootbox.alert('Hay ' + haySinConv + ' factura/s sin convenio AT asociado.<br>Elija solo facturas de agentes con contrato de Asistencia Tecnica.');
		} else if(convenioAT.length > 1) {
			bootbox.alert('Hay facturas asociadas a ' + convenioAT.length + ' convenios AT diferentes (' + convenioAT.join(', ') + ').<br>Elija facturas del mismo convenio AT.');
		} else {
			var today = new Date();
			var $form = $('<form>')
				.addClass('hide')
				.attr('method', 'post')
				.attr('action', 'certificar_lote.php')
				.append($('<input name="idsToCertif" value="' + idsToCertif.join(',') + '">'))
				.append($('<input name="idClave" value="K' + MD5("f4ct#r4s@" + today.toISOString().substring(0, 10)) + '">'))
				.append($('<input name="operation" value="view">'))
				.appendTo($('body'));
			$form.submit();
		}
	}
}
