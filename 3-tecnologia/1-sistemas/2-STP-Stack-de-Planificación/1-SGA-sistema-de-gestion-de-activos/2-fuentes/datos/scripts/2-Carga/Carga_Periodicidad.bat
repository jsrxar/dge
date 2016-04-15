@echo off
setlocal
set PGPASSWORD=rcdto

@echo ==============================(  Cargando Ciardi  )==============================

C:\app\pentaho-ee\postgresql\bin\psql -d RCDTO -U postgres -f Carga_Periodicidad.sql

@echo ==============================(  Proceso finalizado  )==============================

endlocal
@timeout 10