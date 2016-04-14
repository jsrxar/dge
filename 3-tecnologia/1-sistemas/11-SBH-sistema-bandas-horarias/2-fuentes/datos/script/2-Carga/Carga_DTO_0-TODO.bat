@echo off
setlocal

set PGHOST=10.13.18.133
set PDBASE=RRHH
set PGUSER=postgres
set PGPASSWORD=postgres
set PGOPTIONS=--client-min-messages=warning
@echo ==============================(  Inicializando  )==============================
:: Ejecutamos el script de inicialización
cd ..\1-Inicializacion
call inicializa.bat /N
cd..\2-Carga

@echo ==============================(  Cargando Stage Personal  )==============================
@echo Cargando "DTO_Personal.csv"
C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f Carga_DTO_1a-Stage_Personal.sql

@echo ==============================(  Cargando Stage Fichadas  )==============================
set FECHAHORA=%Date:~6,4%%Date:~3,2%%Date:~0,2%_%Time:~0,2%%Time:~3,2%%Time:~6,2%

for %%f in (C:\archivos\dto\*.csv) do (
	@echo Cargando "%%~nxf"
	C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -c "\COPY stg_dto_banda (tx_fecha, tx_nombre, tx_entrada, tx_salida, tx_horas, tx_dni, tx_empresa_area, tx_tipo_acreditac) FROM '%%~dpnxf' DELIMITERS ';' WITH CSV HEADER;"
)
:: Para mover agregar al FOR: move "%%~dpnxf" "%%~dpfprocesado\%FECHAHORA%.%%~nxf"

@echo Completando datos
C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f Carga_DTO_1b-Stage_Banda.sql

:: Se cambia de usuario de acceso a la base de datos
set PGUSER=rrhh
set PGPASSWORD=rrhh
@echo ==============================(  Cargando Tablas Operacionales  )==============================
C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f Carga_DTO_2a-ODS.sql

@echo ==============================(  Cargando Dimension Fechas  )==============================
C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f Carga_DTO_3a-Dimension_Fecha.sql

@echo ==============================(  Cargando Dimensiones  )==============================
C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f Carga_DTO_3b-Otras_Dimensiones.sql

@echo ==============================(  Cargando Hechos  )==============================
C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f Carga_DTO_3c-Hechos.sql

@echo ==============================(  Proceso finalizado  )==============================

endlocal
timeout 10