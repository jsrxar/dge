switch($.urlParam('operation')) {
    case 'edit':
		// Edición de registro
        fn_honorario_edit();
    case 'insert':
		// Nuevo registro
        fn_honorario_insert();
        break;
    case 'copy':
    case 'view':
		// Nada
        break;
    default:
		// Nada
}

function fn_honorario_insert () {
	$("form.form-horizontal").bind("DOMSubtreeModified", function(){
		$("div#s2id_id_contrato_edit").css("width", "532px");
	});
}

function fn_honorario_edit () {
	var today = new Date();

	var datos = {
		"idClave": "K" + MD5("f4ct#r4s@" + today.toISOString().substring(0, 10)),
		"idHonorario": $.urlParam('pk0')
	};

	$.ajax({
		data: datos,
		url: 'ax_monto_honorario.php',
		type: 'post',
		success: function(respuesta) {
			$('#va_honorario_edit').val(respuesta);
		}
	});
}
