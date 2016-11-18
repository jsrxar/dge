@echo off
setlocal

set PGHOST=monet.myc.ar
set PDBASE=sfmycp
set PGUSER=postgres
set PGPASSWORD=B1c3nt3n4r10@2016
set PGOPTIONS=--client-min-messages=warning
:: Descomentar solamente para reiniciar completamente el esquema!!!
::@echo ==============================(  Pre Esquema  )==============================
::C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f audit_pre.sql

@echo ==============================(  Creando Esquema Audit  )==============================
C:\app\pentaho-ee\postgresql\bin\psql -h %PGHOST% -d %PDBASE% -U %PGUSER% -f audit.sql

endlocal
IF "%1"=="/N" GOTO:EOF

@echo ==============================(  Proceso Finalizado  )==============================
timeout 10