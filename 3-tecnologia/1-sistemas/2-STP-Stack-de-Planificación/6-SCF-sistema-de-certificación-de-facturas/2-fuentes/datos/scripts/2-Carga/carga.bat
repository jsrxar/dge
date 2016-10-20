@echo off
setlocal

set PGHOST=mozart.myc.ar
set PDBASE=FACTURAS
set PGUSER=facturas
set PGPASSWORD=hola1234
set PGOPTIONS=--client-min-messages=warning
@echo ==============================(  Inicializando  )==============================
:: Ejecutamos el script de inicialización
cd ..\1-Inicializacion
call inicializa.bat /N
cd..\2-Carga

@echo ==============================(  Cargando Archivo Datos  )==============================
set FECHAHORA=%Date:~6,4%%Date:~3,2%%Date:~0,2%_%Time:~0,2%%Time:~3,2%%Time:~6,2%

for %%f in (C:\archivos\facturas\*.csv) do (
	@echo Cargando "%%~nxf"
	C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -c "\COPY stg_base_rrhh FROM '%%~dpnxf' DELIMITERS ';'"
)
:: Para mover agregar al FOR: move "%%~dpnxf" "%%~dpfprocesado\%FECHAHORA%.%%~nxf"

@echo Completando datos
C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f 1-Carga_Datos.sql

@echo ==============================(  Proceso finalizado  )==============================

endlocal
timeout 10