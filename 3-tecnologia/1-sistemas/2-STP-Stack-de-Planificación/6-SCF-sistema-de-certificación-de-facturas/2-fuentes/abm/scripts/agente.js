switch($.urlParam('operation')) {
    case 'copy':
    case 'edit':
    case 'insert':
		// Edición de registro
        fn_agente_edit();
        break;
    case 'view':
		// Visualización de registro
        fn_agente_view();
        break;
    default:
        // Nada
}

function fn_agente_edit () {
	$("#id_ubicacion_fisica_edit").bind("DOMSubtreeModified", function() {
		// Agrandar combos de "Puesto" y "Dependencia"
		$(".select2-container").css("width", "532px");
	});
}

function fn_agente_view () {
	var today = new Date();

	var datos = {
		"idClave": "K" + MD5("f4ct#r4s@" + today.toISOString().substring(0, 10)),
		"idAgente": $.urlParam('pk0')
	};

	$.ajax({
		data: datos,
		url: 'ax_facturas_agente.php',
		type: 'post',
		success: function(respuesta) {
			if ($("#auxFactAgente").length > 0){
				$("#auxFactAgente").html(respuesta);
			} else {
				$("div.span6").append('<div id="auxFactAgente">' + respuesta + '</div>');
			}
		}
	});
}
