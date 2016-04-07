::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Descripción : Backup de esquemas en la base PostgreSQL
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::   Variables
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set PGHOST=localhost
set PGPORT=5432
set PGUSER=postgres
set PGPASSWORD=postgres
call:set_vars %1

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::   Proceso general de Backup
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::  Backup de las Bases de Datos
echo %DATE% %TIME% Backup de las Bases de Datos >> %FILE_LOG%
call:backup_db RRHH  %BKP_DIR%
call:backup_db RCDTO %BKP_DIR%

::  Backup del directorio C:\archivos
echo %DATE% %TIME% Backup de Archivos >> %FILE_LOG%
call:backup_dir ARCHIVOS "C:\archivos" %BKP_DIR%

echo %DATE% %TIME% Backup finalizado >> %FILE_LOG%
echo %DATE% %TIME% Backup finalizado
echo %DATE% %TIME% Pode ver el log en %FILE_LOG%

:: pause
goto:eof

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:backup_db
:::::: Función que hace el Backup de una Base de Datos
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: %1 = Base de Datos a resguardar
:: %2 = carpeta destino del Backup
set PDBASE=%1
set BKP_DIR=%~s2
set FILE_BCK=%BKP_DIR%\DB-%PDBASE%-%LOG_DATE%.backup
set FILE_ZIP=%BKP_DIR%\DB-%PDBASE%-%ZIP_DATE%.zip

echo %DATE% %TIME% ^| Creando Backup de la base de datos "%PDBASE%"
echo %DATE% %TIME% Creando Backup de la base de datos "%PDBASE%" >> %FILE_LOG%

%EXP_EXE% -i -h %PGHOST% -p %PGPORT% -U %PGUSER% -F c -b -v -f %FILE_BCK% %PDBASE% >> %FILE_LOG% 2>&1

echo %DATE% %TIME% ^| Procesando el archivo generado "%FILE_BCK%"

echo %DATE% %TIME% Comprimiendo el archivo "%FILE_BCK%" como "%FILE_ZIP%" >> %FILE_LOG%
%ZIP_EXE% %FILE_ZIP% %FILE_BCK% >> %FILE_LOG%
del %FILE_BCK% >> %FILE_LOG%

goto:eof

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:backup_dir
:::::: Hace el backaup de la carpeta especificade dentro del sistema de archivos
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: %1 = nome del archivo de salida
:: %2 = carpeta para hacer el backup
:: %3 = carpeta destino del archivo de backup
set BKP_NOME=%1
set SYS_DIR=%~s2
set BKP_DIR=%~s3
set FILE_ZIP=%BKP_DIR%\DIR-%BKP_NOME%-%ZIP_DATE%.zip

echo %DATE% %TIME% ^| Creando backup de la carpeta "%SYS_DIR%"
echo %DATE% %TIME% Creando backup de la carpeta "%SYS_DIR%" >> %FILE_LOG%

echo %DATE% %TIME% Creando archivo comprimido "%FILE_ZIP%" de la carpeta "%SYS_DIR%" >> %FILE_LOG%
%ZIP_EXE% -R %FILE_ZIP% %SYS_DIR%\* >> %FILE_LOG%

goto:eof

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:set_vars
:::::: Inicialización de las variables del sistema
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set ORIG_DIR=%%d

set FILE_DATE=%DATE:~6,4%%DATE:~3,2%%DATE:~0,2%
set LOG_DATE=%FILE_DATE%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%

for /F "tokens=1 delims=, " %%i In ('powershell date') do set DOW=%%i
set ZIP_DATE=%DOW:~0,3%

if "%1"=="P" (
	set ZIP_DATE=%ZIP_DATE%_%FILE_DATE%
)

set BKP_DIR="C:\Users\NAC\Dropbox\Backup"
set FILE_LOG=C:\Users\NAC\Dropbox\Backup\log\backup_%LOG_DATE%.log
set EXP_EXE=C:\app\pentaho-ee\postgresql\bin\pg_dump.exe
set ZIP_EXE="C:\Program Files\7-Zip\7z.exe" a -tzip 

goto:eof