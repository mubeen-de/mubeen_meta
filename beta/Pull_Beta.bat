@echo off
setlocal EnableDelayedExpansion
cd /d "%~dp0\.."
title Kapmeta POS - Pull BETA Testing Updates from GitHub
color 0B

echo =======================================================================
echo         KAPMETA POS PLATFORM - PULL BETA TESTING BUILD
echo =======================================================================
echo.
echo  Target Branch : beta (Developer & QA Testing Channel)
echo  Target Remote : origin (https://github.com/mubeen-de/mubeen_meta)
echo =======================================================================
echo.

:: 1. Ensure logs directory exists
if not exist "logs\git" (
    mkdir "logs\git"
)

:: 2. Check Git Installation
where git >nul 2>nul
if %ERRORLEVEL% neq 0 (
    color 0C
    echo [ERROR] Git is not installed or not in system PATH.
    pause
    exit /b 1
)

:: 3. Switch to / Ensure on branch beta
git checkout beta >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo Fetching remote 'beta' branch...
    git checkout -b beta origin/beta >nul 2>nul
    if %ERRORLEVEL% neq 0 (
        git checkout -b beta
    )
)

:: 4. Pull latest beta commits
for /f "tokens=*" %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set dt=%%I
set LOG_FILE=logs\git\pull_beta_!dt!.log

echo Fetching and pulling latest commits from origin/beta...
echo.

git pull origin beta --progress --verbose 2>&1 | powershell -Command "$input | Tee-Object -FilePath '%LOG_FILE%'"

if %ERRORLEVEL% equ 0 (
    color 0A
    echo.
    echo =======================================================================
    echo  SUCCESS: Latest BETA updates pulled successfully!
    echo  Log saved to: !LOG_FILE!
    echo =======================================================================
    echo.
    echo Recent commits on beta:
    git log -n 3 --pretty=format:" [%h] %ad | %s (%an)" --date=short
    echo.
) else (
    color 0C
    echo.
    echo =======================================================================
    echo  PULL FAILED: Exit code %ERRORLEVEL%.
    echo  Log saved to: !LOG_FILE!
    echo =======================================================================
)

echo.
pause
