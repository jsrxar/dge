@echo off
setlocal

@echo ==============================(  1a - Creando Esquema  )==============================
set PGPASSWORD=postgres
C:\app\pentaho-ee\postgresql\bin\psql -d RCDTO -U postgres -f 1a-Crea_Esquema.sql

@echo ==============================(  1b - Creando Basede Datos Sistema SGA  )==============================
set PGPASSWORD=rcdto
C:\app\pentaho-ee\postgresql\bin\psql -d RCDTO -U rcdto -f 1b-Crea_SGA.sql

@echo ==============================(  1c - Creando Basede Datos STAGE  )==============================

C:\app\pentaho-ee\postgresql\bin\psql -d RCDTO -U rcdto -f 1c-Crea_STG.sql

@echo ==============================(  1d - Creando Basede Datos DW  )==============================
C:\app\pentaho-ee\postgresql\bin\psql -d RCDTO -U rcdto -f 1d-Crea_DW.sql

@echo ==============================(  1d - Creando Triggers para Referencias  )==============================
C:\app\pentaho-ee\postgresql\bin\psql -d RCDTO -U rcdto -f 1d-Crea_Triggers.sql

@echo ==============================(  2b - Cargando Valores Iniciales  )==============================
C:\app\pentaho-ee\postgresql\bin\psql -d RCDTO -U rcdto -f 2a-Carga_Valores_Iniciales.sql

@echo ==============================(  Proceso finalizado  )==============================

endlocal
@timeout 10