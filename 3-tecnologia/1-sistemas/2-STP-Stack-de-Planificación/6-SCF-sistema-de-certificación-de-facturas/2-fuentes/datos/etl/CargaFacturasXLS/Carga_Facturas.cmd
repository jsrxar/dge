@echo off
cd /D %~dp0

::##############################################################################
::##  Variables generales del proceso                                         ##
::##############################################################################
set KETTLE=C:\app\pentaho-ce\data-integration\kitchen.bat
set DIRBASE=C:\archivos\PROCESOS\CargaFacturasXLS
::set LOGLEVEL=Basic
set LOGLEVEL=Detailed

::##############################################################################
::##  Calculando fecha y hora                                                 ##
::##############################################################################
set DATETIME=%DATE%_%TIME%
set DATETIME=%DATETIME: =_%
set DATETIME=%DATETIME::=%
set DATETIME=%DATETIME:/=%
set DATETIME=%DATETIME:.=_%
set DATETIME=%DATETIME:,=%
set FILE_LOG=%DIRBASE%\logs\Carga_Facturas_%DATETIME%.log

::##############################################################################
::##  Inicializando LOG                                                       ##
::##############################################################################
echo Proceso ejecutado el dia %DATE% a las %TIME% > %FILE_LOG% 2>&1
setlocal enableDelayedExpansion >> %FILE_LOG% 2>&1

::##############################################################################
::##  Ejecuta el proceso ETL                                                  ##
::##############################################################################
::call %KETTLE% /file:%DIRBASE%\Carga_Facturas.kjb /level:%LOGLEVEL% >> %FILE_LOG% 2>&1
call %KETTLE% /rep:"Carga Facturas XLS" /job:"Carga_Facturas" /level:%LOGLEVEL% >> %FILE_LOG% 2>&1

::##############################################################################
::##  Finalizando                                                             ##
::##############################################################################
echo Proceso Finalizado >> %FILE_LOG% 2>&1
::@timeout 10