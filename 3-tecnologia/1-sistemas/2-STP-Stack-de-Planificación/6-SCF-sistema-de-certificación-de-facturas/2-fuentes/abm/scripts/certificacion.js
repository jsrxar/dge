if($.urlParam('operation') == 'view') {
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
			if ($("#auxLoteCert").length > 0){
				$("#auxLoteCert").html(respuesta);
			} else {
				$("div.span6").append('<div id="auxLoteCert">' + respuesta + '</div>');
			}
		}
	});
}
