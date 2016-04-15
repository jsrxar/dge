@echo off
setlocal
set PGPASSWORD=rrhh

@echo ==============================(  Cargando Tablas Operacionales  )==============================

C:\app\pentaho-ee\postgresql\bin\psql -d RRHH -U rrhh -f Carga_DTO_2a-ODS.sql

@echo ==============================(  Proceso finalizado  )==============================

endlocal
timeout 10