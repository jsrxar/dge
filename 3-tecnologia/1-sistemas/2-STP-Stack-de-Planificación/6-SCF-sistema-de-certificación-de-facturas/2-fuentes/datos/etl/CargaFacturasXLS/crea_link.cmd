:: Crea link simb�lico del directorio C:\archivos\PROCESOS\CargaFacturasXLS al directorio actual
::@echo off

mklink /d C:\archivos\PROCESOS\CargaFacturasXLS %~dp0
@timeout 10
