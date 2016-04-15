@echo off
:: ATENCIÓN: La carpeta "C:\archivos" debe existir previamente

@echo ==============================(  1a - Creando Esquema  )==============================
mkdir C:\archivos\dto\personal
mkdir C:\archivos\dto\procesado
copy "DTO_Personal.csv" C:\archivos\dto\personal
copy "cck -gral al 22-02.csv" C:\archivos\dto
copy "desc gral cck 01-02.csv" C:\archivos\dto
copy "desc gral cck 02-03.csv" C:\archivos\dto
copy "desc gral febrero.csv" C:\archivos\dto
copy "impecable oct. nov. dic..csv" C:\archivos\dto

@echo ==============================(  Proceso Finalizado  )==============================
timeout 10
