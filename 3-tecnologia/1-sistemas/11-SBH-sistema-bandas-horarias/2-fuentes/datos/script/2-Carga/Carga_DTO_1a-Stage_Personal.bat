@echo off
setlocal
set PGPASSWORD=postgres

@echo ==============================(  Cargando Personal  )==============================

echo Cargando "DTO_Personal.csv"
C:\app\pentaho-ee\postgresql\bin\psql -d RRHH -U postgres -f Carga_DTO_1a-Stage_Personal.sql

@echo ==============================(  Proceso finalizado  )==============================

endlocal
timeout 10
