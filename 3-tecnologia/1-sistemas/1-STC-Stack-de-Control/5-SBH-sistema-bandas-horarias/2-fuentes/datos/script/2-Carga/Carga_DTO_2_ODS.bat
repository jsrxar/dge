@echo off
setlocal
set PGPASSWORD=hola1234

@echo ==============================(  Cargando Tablas Operacionales  )==============================

C:\app\pentaho-ee\postgresql\bin\psql -d HORAS -U horas -f Carga_DTO_2a-ODS.sql

@echo ==============================(  Proceso finalizado  )==============================

endlocal
timeout 10