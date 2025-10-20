@echo off

cd /D "%~dp0"

powershell -ExecutionPolicy Bypass -File scripts\Install.ps1
pause
