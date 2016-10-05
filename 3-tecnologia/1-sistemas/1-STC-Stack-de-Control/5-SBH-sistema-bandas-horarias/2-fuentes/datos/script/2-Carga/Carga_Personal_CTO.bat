@echo off
setlocal

set PGHOST=monet.myc.ar
set PDBASE=horas
@echo ==============================(  Cargando Personal DTO  )==============================
set PGUSER=postgres
set PGPASSWORD=postgres

for %%f in (C:\archivos\dto\personal\*.csv) do (
	echo Cargando "%%~nxf"
	C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -c "\COPY stg_dto_personal (tx_sector, tx_area, tx_puesto, tx_nombre, tx_dni) FROM '%%~dpnxf' DELIMITERS ';' WITH NULL AS '';"
)
::Para mover agregar al FOR: move "%%~dpnxf" "%%~dpfprocesado\%FECHAHORA%.%%~nxf"

@echo ==============================(  Procesando datos cargados  )==============================
set PGUSER=horas
set PGPASSWORD=hola1234
C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f Carga_Personal_CTO.sql

C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f Carga_DIM_Persona.sql

@echo ==============================(  Proceso finalizado  )==============================

endlocal
timeout 10
