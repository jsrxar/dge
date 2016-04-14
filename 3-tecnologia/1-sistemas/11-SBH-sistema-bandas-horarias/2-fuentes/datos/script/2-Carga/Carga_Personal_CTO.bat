@echo off
setlocal

set PGHOST=10.13.18.133
set PDBASE=RRHH
@echo ==============================(  Cargando Fichadas  )==============================
set PGUSER=postgres
set PGPASSWORD=postgres

for %%f in (C:\archivos\dto\personal\*.csv) do (
	echo Cargando "%%~nxf"
	C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -c "\COPY stg_dto_personal (tx_sector, tx_area, tx_puesto, tx_nombre, tx_dni) FROM '%%~dpnxf' DELIMITERS ';' WITH NULL AS '';"
)
::Para mover agregar al FOR: move "%%~dpnxf" "%%~dpfprocesado\%FECHAHORA%.%%~nxf"

@echo ==============================(  Procesando datos cargados  )==============================
set PGUSER=rrhh
set PGPASSWORD=rrhh
C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f Carga_Personal_CTO.sql

@echo ==============================(  Proceso finalizado  )==============================

endlocal
timeout 10
