@echo off
setlocal
set PGPASSWORD=postgres
set FECHAHORA=%Date:~6,4%%Date:~3,2%%Date:~0,2%_%Time:~0,2%%Time:~3,2%%Time:~6,2%

@echo ==============================(  Cargando Fichadas  )==============================

for %%f in (C:\archivos\dto\*.csv) do (
	echo Cargando "%%~nxf"
	C:\app\pentaho-ee\postgresql\bin\psql -d HORAS -U postgres -c "\COPY stg_dto_banda (tx_fecha, tx_nombre, tx_entrada, tx_salida, tx_horas, tx_dni, tx_empresa_area, tx_tipo_acreditac) FROM '%%~dpnxf' DELIMITERS ';' WITH CSV HEADER;"
)
::Para mover agregar al FOR: move "%%~dpnxf" "%%~dpfprocesado\%FECHAHORA%.%%~nxf"

echo Completando datos
C:\app\pentaho-ee\postgresql\bin\psql -d HORAS -U postgres -f Carga_DTO_1b-Stage_Banda.sql

@echo ==============================(  Proceso finalizado  )==============================

endlocal
timeout 10
