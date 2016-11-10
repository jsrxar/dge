<?php
/* Funciones Generales PHP */

// Clave de encriptación
function crypt_key () {
  $conn = GetGlobalConnectionOptions();
  return str_pad($conn['password'], 24, "*");
}

// Función de encriptado de datos
function encrypt_aes ($valor) {
  return rtrim(mcrypt_encrypt(
    MCRYPT_RIJNDAEL_128,
    crypt_key(),
    $valor,
    MCRYPT_MODE_ECB,''),"\x00..\x1F");
}

// Función de desencriptado de datos
function decrypt_aes ($valor) {
  return rtrim(mcrypt_decrypt(
    MCRYPT_RIJNDAEL_128,
    crypt_key(),
    $valor,
    MCRYPT_MODE_ECB,''),"\x00..\x1F");
}
?>