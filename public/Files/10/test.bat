@echo off
timeout /t 10
pushd %~dp0
%~dp0\GitHubSetup.exe dasfgf > %~dp0\stdout.txt 2> %~dp0\stderror.txt
echo %errorlevel% > %~dp0\retcode.txt
shutdown /s /t 30
