@echo off
setlocal

set PGHOST=10.13.18.133
set PDBASE=RRHH
set PGUSER=postgres
set PGPASSWORD=postgres
@echo ==============================(  Cargando Personal  )==============================
echo Cargando "Base Banda Horaria 2016.csv"
C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f Carga_Personal_RRHH.sql

@echo ==============================(  Proceso finalizado  )==============================

endlocal
timeout 10
