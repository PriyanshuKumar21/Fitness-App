@echo off
echo Fitness App Backup and Cleanup Tool
echo ===================================
echo This script will:
echo 1. Create a backup of your fitness app
echo 2. Clean up old/unnecessary files
echo.

:: Check for admin privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running with administrator privileges...
) else (
    echo Please run this script as administrator for best results.
    pause
)

:: Run the PowerShell script
echo Starting backup and cleanup process...
powershell.exe -ExecutionPolicy Bypass -File "%~dp0backup_fitness_app.ps1"

echo.
echo Process completed!
pause 