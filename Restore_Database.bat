@echo off
setlocal EnableDelayedExpansion
cd /d "%~dp0"
title Restore PetPooja / KapMeta Database
color 0B

echo =======================================================================
echo         PETPOOJA / KAPMETA DATABASE RESTORATION UTILITY
echo =======================================================================
echo.

set DB_HOST=localhost
set DB_PORT=5432
set DB_USER=pos
set DB_NAME=kapmeta
set PGPASSWORD=pos
set DUMP_FILE=db\backup\kapmeta_backup_sep14.sql

if not exist "%DUMP_FILE%" (
    if exist "kapmeta_backup_sep14.sql" (
        set DUMP_FILE=kapmeta_backup_sep14.sql
    ) else if exist "database_dump_sep14.sql" (
        set DUMP_FILE=database_dump_sep14.sql
    ) else (
        color 0C
        echo [ERROR] Could not find SQL dump file (%DUMP_FILE%).
        echo Please ensure the dump file is located in db\backup\
        pause
        exit /b 1
    )
)

echo Target Database : %DB_NAME% on %DB_HOST%:%DB_PORT%
echo Target User     : %DB_USER%
echo Source SQL Dump : %DUMP_FILE%
echo.

:: Check if psql is available in PATH or PostgreSQL default directories
set PSQL_CMD=psql
where psql >nul 2>nul
if %errorlevel% neq 0 (
    if exist "C:\Program Files\PostgreSQL\16\bin\psql.exe" (
        set PSQL_CMD="C:\Program Files\PostgreSQL\16\bin\psql.exe"
    ) else if exist "C:\Program Files\PostgreSQL\15\bin\psql.exe" (
        set PSQL_CMD="C:\Program Files\PostgreSQL\15\bin\psql.exe"
    ) else if exist "C:\Program Files\PostgreSQL\14\bin\psql.exe" (
        set PSQL_CMD="C:\Program Files\PostgreSQL\14\bin\psql.exe"
    ) else (
        color 0C
        echo [ERROR] psql.exe was not found in PATH or standard PostgreSQL installation folders.
        echo Please ensure PostgreSQL is installed or run the SQL file via pgAdmin.
        pause
        exit /b 1
    )
)

echo [1/2] Verifying and preparing database '%DB_NAME%'...
%PSQL_CMD% -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d postgres -c "CREATE DATABASE %DB_NAME%;" 2>nul

echo [2/2] Restoring schema and data from %DUMP_FILE%...
%PSQL_CMD% -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d %DB_NAME% -f "%DUMP_FILE%"

if %errorlevel% equ 0 (
    color 0A
    echo.
    echo =======================================================================
    echo [SUCCESS] Database restored successfully into '%DB_NAME%'!
    echo You can now start the application with Start_PetPooja.bat
    echo =======================================================================
) else (
    color 0E
    echo.
    echo [NOTE] Restoration finished. Check any warnings above.
)

pause
