@echo off
setlocal

set PGHOST=10.13.18.133
set PDBASE=RRHH
set PGUSER=postgres
set PGPASSWORD=postgres
set PGOPTIONS=--client-min-messages=warning
@echo ==============================(  1a - Creando Esquema  )==============================
C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f 1a-Crea_Esquema.sql

@echo ==============================(  2a - Creando Basede Datos STG  )==============================
set PGUSER=rrhh
set PGPASSWORD=rrhh
C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f 2a-Crea_Base_STG.sql

@echo ==============================(  2b - Creando Basede Datos ODS  )==============================
C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f 2b-Crea_Base_ODS.sql

@echo ==============================(  2c - Creando Basede Datos DW  )==============================
C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f 2c-Crea_Base_DW.sql

@echo ==============================(  2d - Creando Funcion de Totales  )==============================
C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f 2d-Crea_Funciones.sql

endlocal
IF "%1"=="/N" GOTO:EOF

@echo ==============================(  Proceso Finalizado  )==============================
timeout 10
