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
		// Visualizaciones generales
		fn_agente_grid();
}

function fn_agente_edit () {
	$("#id_ubicacion_fisica_edit").bind("DOMSubtreeModified", function() {
		// Agrandar combos de "Puesto" y "Dependencia"
		$(".select2-container").css("width", "532px");
	});
	// Si cambia "Nombre" o "Apellido" colocamos el "Nombre Completo"
	$("#no_nombre_edit").on("input",function(e){
		$("#no_agente_edit").val($("#no_apellido_edit").val() + ", " + $("#no_nombre_edit").val());
	});
	$("#no_apellido_edit").on("input",function(e){
		$("#no_agente_edit").val($("#no_apellido_edit").val() + ", " + $("#no_nombre_edit").val());
	});
}

function fn_agente_view () {
	var span = "span12";
	$('div.span6').addClass(span);
	$('div.' + span).removeClass("span6");

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
				$("div." + span).append('<div id="auxFactAgente">' + respuesta + '</div>');
			}
		}
	});
}

function fn_agente_grid () {
	$('td[data-column-name="no_agente"]').css("font-weight","bold");
}