@echo off

@echo ==============================(  Cargando Fichadas  )==============================

C:\app\pentaho-ee\postgresql\bin\psql -d HORAS -U postgres -f C:\archivos\PROCESOS\Manual\Carga_Fichadas.sql

@echo ==============================(  Proceso finalizado  )==============================

@timeout 10