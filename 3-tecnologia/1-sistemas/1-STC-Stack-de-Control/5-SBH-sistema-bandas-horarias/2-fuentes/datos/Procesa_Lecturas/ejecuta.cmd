@echo off
cd /D %~dp0

::##############################################################################
::##  Variables generales del proceso                                         ##
::##############################################################################
set KETTLE=C:\app\pentaho-ee\design-tools\data-integration\kitchen.bat
set DIRBASE=C:\archivos\PROCESOS\Procesa_Lecturas
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
set FILE_LOG=%DIRBASE%\logs\Procesa_Lectura_%DATETIME%.log

::##############################################################################
::##  Inicializando LOG                                                       ##
::##############################################################################
echo Proceso ejecutado el dia %DATE% a las %TIME% > %FILE_LOG% 2>&1
setlocal enableDelayedExpansion >> %FILE_LOG% 2>&1

::##############################################################################
::##  Ejecuta el proceso ETL                                                  ##
::##############################################################################
::call %KETTLE% /file:%DIRBASE%\Procesa_Lecturas.kjb /level:%LOGLEVEL% >> %FILE_LOG% 2>&1
call %KETTLE% /rep:"ETL Lecturas" /job:"Procesa_Lecturas" /level:%LOGLEVEL% >> %FILE_LOG% 2>&1

::##############################################################################
::##  Finalizando                                                             ##
::##############################################################################
echo Proceso Finalizado >> %FILE_LOG% 2>&1
@timeout 10