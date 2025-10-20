@echo off

set install_dir=%~dp0
cd /D "%install_dir%"

powershell -ExecutionPolicy Bypass -File scripts\Uninstall.ps1
pause
if %ERRORLEVEL% neq 0 (
    exit /b %ERRORLEVEL%
)
start /min "" /d "%TEMP%" cmd /c "timeout /t 2 && rd /S /Q ""%install_dir%"""