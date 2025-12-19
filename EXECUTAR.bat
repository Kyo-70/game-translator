@echo off
setlocal EnableDelayedExpansion

:: ============================================================================
:: GAME TRANSLATOR - EXECUCAO RAPIDA
:: Versao: 1.0.2 - Compativel com Windows 11
:: ============================================================================

chcp 65001 >nul 2>&1
title Game Translator

:: Variaveis
set "SCRIPT_DIR=%~dp0"
set "EXE_PATH=%SCRIPT_DIR%dist\GameTranslator.exe"

:: Verifica se o executavel existe
if exist "%EXE_PATH%" (
    echo.
    echo [INFO] Iniciando Game Translator...
    start "" "%EXE_PATH%"
    exit /b 0
)

:: Se nao existe executavel, tenta executar via Python
echo.
echo [AVISO] Executavel nao encontrado. Tentando modo desenvolvimento...
echo.

:: Verifica Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERRO] Python nao encontrado!
    echo.
    echo Execute o arquivo INSTALAR.bat para configurar o programa.
    echo.
    pause
    exit /b 1
)

:: Verifica e instala dependencias
echo [INFO] Verificando dependencias...

python -c "import PySide6" >nul 2>&1
if errorlevel 1 (
    echo [INFO] Instalando PySide6...
    pip install PySide6 >nul 2>&1
)

python -c "import requests" >nul 2>&1
if errorlevel 1 (
    echo [INFO] Instalando requests...
    pip install requests >nul 2>&1
)

python -c "import psutil" >nul 2>&1
if errorlevel 1 (
    echo [INFO] Instalando psutil...
    pip install psutil >nul 2>&1
)

echo [OK] Dependencias verificadas!
echo.
echo [INFO] Iniciando Game Translator...
echo.

cd /d "%SCRIPT_DIR%src"
python main.py

pause
