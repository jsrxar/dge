if($.urlParam('operation') == 'view') {
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
