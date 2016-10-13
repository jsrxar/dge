@echo off
setlocal
set PGPASSWORD=hola1234

@echo ==============================(  Cargando Dimensiones  )==============================
C:\app\pentaho-ee\postgresql\bin\psql -d HORAS -U horas -f Carga_DTO_3a-Dimension_Fecha.sql
C:\app\pentaho-ee\postgresql\bin\psql -d HORAS -U horas -f Carga_DTO_3b-Otras_Dimensiones.sql

@echo ==============================(  Cargando Hechos  )==============================
C:\app\pentaho-ee\postgresql\bin\psql -d HORAS -U horas -f Carga_DTO_3c-Hechos.sql

@echo ==============================(  Proceso finalizado  )==============================

endlocal
timeout 10