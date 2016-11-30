switch($.urlParam('operation')) {
    case 'copy':
    case 'edit':
    case 'insert':
		// Edición de registro
        fn_contrato_edit();
        break;
    case 'view':
        // Nada
        break;
    default:
        // Nada
}

function fn_contrato_edit () {
	$(document).ready(function(){ ver_campos_contrato(); ver_campos_honorario(); });
	$("#id_tipo_contrato_edit").change(function(){ ver_campos_contrato() });
	// Al hacer click en "Rechazada?" hace obligatorio el comentario
	$('#fl_crea_honorarios_edit').change(function(){ ver_campos_honorario() });
}

function ver_campos_contrato () {
	var tipo = $("#id_tipo_contrato_edit").val();
	$('label[for="id_convenio_at_edit"]').hide();
	$('#id_convenio_at_edit').hide();
	$('label[for="id_categoria_lm_edit"]').hide();
	$('#id_categoria_lm_edit').hide();
	$('label[for="co_categ_contrato_edit"]').hide();
	$('#co_categ_contrato_edit').hide();
	if(tipo == 1) {
		$('label[for="id_categoria_lm_edit"]').show();
		$('#id_categoria_lm_edit').show();
	} else if((tipo == 2) || (tipo == 3)) {
		$('label[for="id_convenio_at_edit"]').show();
		$('#id_convenio_at_edit').show();
		$('label[for="co_categ_contrato_edit"]').show();
		$('#co_categ_contrato_edit').show();
	}
}

function ver_campos_honorario () {
	var tipo = $("#id_tipo_contrato_edit").val();
	$('label[for="va_honorario_edit"]').hide();
	$('#va_honorario_edit').hide();
	$('span.add-on').hide();
	if($('#fl_crea_honorarios_edit').prop('checked')) {
		$('label[for="va_honorario_edit"]').show();
		$('#va_honorario_edit').show();
		$('span.add-on').show();
	}
}
