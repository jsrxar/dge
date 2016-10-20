@echo off
setlocal

set PGHOST=mozart.myc.ar
set PDBASE=FACTURAS
set PGOPTIONS=--client-min-messages=warning
@echo ==============================(  1a - Creando Esquema  )==============================
set PGUSER=postgres
set PGPASSWORD=postgres
C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f 1a-Crea_Esquema.sql
C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f audit.sql

@echo ==============================(  1b - Creando Objetos Base  )==============================
set PGUSER=facturas
set PGPASSWORD=hola1234
C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f 1b-Crea_Objetos.sql

@echo ==============================(  1d - Creando Triggers  )==============================
C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f 1c-Crea_Triggers.sql

@echo ==============================(  2a - Cargando Valores Iniciales  )==============================
C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f 2a-Carga_Valores_Iniciales.sql

@echo ==============================(  2b - Cargando Otros Valores  )==============================
C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f 2b-Carga_Valores_Full.sql

endlocal
IF "%1"=="/N" GOTO:EOF

@echo ==============================(  Proceso Finalizado  )==============================
timeout 10