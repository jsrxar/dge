@echo off
setlocal

set PGHOST=monet.myc.ar
set PGHOST=10.13.18.64
set PDBASE=horas
@echo ==============================(  Cargando Agentes  )==============================
set PGUSER=postgres
set PGPASSWORD=postgres

for %%f in (C:\archivos\personas\*.csv) do (
	echo Cargando "%%~nxf"
	C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -c "\COPY stg_personal (tx_dat_lab_dependencia, tx_dat_lab_secretaria, tx_dat_lab_subsecretaria, tx_dat_lab_direccion_area, tx_dat_lab_area_dependenc, tx_dat_lab_sector, tx_dat_lab_sub_sector, tx_ubi_fis_ubic_fisica_1, tx_dat_per_apell_nombre, tx_dat_per_tipo_doc, tx_dat_per_nro_doc ) FROM '%%~dpnxf' DELIMITERS ';' WITH NULL AS '' CSV HEADER;"
)
::Para mover agregar al FOR: move "%%~dpnxf" "%%~dpfprocesado\%FECHAHORA%.%%~nxf"

@echo ==============================(  Procesando datos cargados  )==============================
set PGUSER=horas
set PGPASSWORD=hola1234

C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f Carga_Personal_RRHH.sql

C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f Carga_DIM_Persona.sql

@echo ==============================(  Proceso finalizado  )==============================

endlocal
timeout 10
