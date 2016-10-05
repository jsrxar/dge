@echo off

@echo ==============================(  Cargando Ciardi  )==============================

C:\app\pentaho-ee\postgresql\bin\psql -d HORAS -U postgres -f C:\archivos\PROCESOS\Manual\Carga_Ciardi.sql

@echo ==============================(  Proceso finalizado  )==============================

@timeout 10