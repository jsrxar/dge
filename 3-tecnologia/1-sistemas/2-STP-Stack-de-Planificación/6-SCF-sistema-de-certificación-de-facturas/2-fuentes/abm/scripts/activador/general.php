<?php
/* Funciones Generales PHP */
function crypt_key () {
	$conn = GetGlobalConnectionOptions();
	return str_pad($conn['password'], 24, "*");
}

function encrypt_aes ($valor) {
	return rtrim(mcrypt_encrypt(
		MCRYPT_RIJNDAEL_128,
		crypt_key(),
		$valor,
		MCRYPT_MODE_ECB,''),"\x00..\x1F");
}

function decrypt_aes ($valor) {
	return rtrim(mcrypt_decrypt(
		MCRYPT_RIJNDAEL_128,
		crypt_key(),
		$valor,
		MCRYPT_MODE_ECB,''),"\x00..\x1F");
}
?>