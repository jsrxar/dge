@echo off
setlocal

set PGHOST=monet.myc.ar
set PDBASE=sfmycp
set PGUSER=facturas
set PGPASSWORD=F4ct#r4s@2016
set PGOPTIONS=--client-min-messages=warning
@echo ==============================(  Inicializando  )==============================
:: Ejecutamos el script de inicialización
cd ..\1-Inicializacion
call inicializa.bat /N
cd..\2-Carga

@echo ==============================(  Cargando Archivo Datos  )==============================
set FECHAHORA=%Date:~6,4%%Date:~3,2%%Date:~0,2%_%Time:~0,2%%Time:~3,2%%Time:~6,2%

for %%f in (C:\archivos\facturas\inicial\*.csv) do (
	@echo Cargando "%%~nxf"
	C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -c "\COPY stg_base_rrhh(ds_ministerio,ds_secretaria,ds_subsecretaria,ds_direccion_area,ds_area_dependencia,ds_sector,ds_sub_sector,ds_puesto,ds_funcion,ds_ubicacion_fisica,ds_apellido_nombres,ds_dni,ds_nro,ds_cuit,ds_f_nacimiento,ds_lm_at,ds_tipo,ds_ingreso,ds_vto_contrato,ds_ini_contrato,ds_fin_contrato,ds_categ_lm,ds_universidad,ds_convenio_at,ds_julio_10p,ds_agosto_14p,ds_sept,ds_oct,ds_nov,ds_dic) FROM '%%~dpnxf' DELIMITERS ';'"
)


:: Para mover agregar al FOR: move "%%~dpnxf" "%%~dpfprocesado\%FECHAHORA%.%%~nxf"

@echo Completando datos
set APPNAME=Carga_inicial_Base;%PGPASSWORD%
C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f 1-Carga_Datos.sql -v pAppName='%APPNAME%'

@echo ==============================(  Proceso finalizado  )==============================

endlocal
timeout 10