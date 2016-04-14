@echo off
setlocal

set PGHOST=10.13.18.133
set PDBASE=RRHH
set PGUSER=postgres
set PGPASSWORD=postgres
@echo ==============================(  Cargando Fichadas  )==============================

for %%f in (C:\archivos\manuales\*.csv) do (
	echo Cargando "%%~nxf"
	C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -c "\COPY stg_fichadas (tx_dni, tx_usuario, tx_fecha, tx_entrada_hora) FROM '%%~dpnxf' DELIMITERS ';' WITH CSV HEADER;"
)
::Para mover agregar al FOR: move "%%~dpnxf" "%%~dpfprocesado\%FECHAHORA%.%%~nxf"

@echo ==============================(  Procesando datos cargadops  )==============================
C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f C:\archivos\PROCESOS\Manual\Carga_Fichadas_Manuales.sql

@echo ==============================(  Proceso finalizado  )==============================

endlocal
timeout 10