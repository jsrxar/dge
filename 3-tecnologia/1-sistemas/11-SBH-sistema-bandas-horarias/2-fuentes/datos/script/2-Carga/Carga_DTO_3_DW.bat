@echo off
setlocal
set PGPASSWORD=rrhh

@echo ==============================(  Cargando Dimensiones  )==============================
C:\app\pentaho-ee\postgresql\bin\psql -d RRHH -U rrhh -f Carga_DTO_3a-Dimension_Fecha.sql
C:\app\pentaho-ee\postgresql\bin\psql -d RRHH -U rrhh -f Carga_DTO_3b-Otras_Dimensiones.sql

@echo ==============================(  Cargando Hechos  )==============================
C:\app\pentaho-ee\postgresql\bin\psql -d RRHH -U rrhh -f Carga_DTO_3c-Hechos.sql

@echo ==============================(  Proceso finalizado  )==============================

endlocal
timeout 10