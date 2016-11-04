<?php
/* Funciones Generales PHP */
function decrypt_aes ($valor) {
	$conn = GetGlobalConnectionOptions();
	return rtrim(mcrypt_decrypt(
		MCRYPT_RIJNDAEL_128,
		str_pad($conn['password'], 24, "*#"),
		$valor,
		MCRYPT_MODE_ECB,''),"\x00..\x1F");
}
?>