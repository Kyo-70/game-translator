@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion

:: Cores
set "GREEN=[92m"
set "YELLOW=[93m"
set "CYAN=[96m"
set "RED=[91m"
set "RESET=[0m"

title Game Translator

:: Verifica se o executável existe
set "SCRIPT_DIR=%~dp0"
set "EXE_PATH=%SCRIPT_DIR%dist\GameTranslator.exe"

if exist "%EXE_PATH%" (
    echo.
    echo %CYAN%🎮 Iniciando Game Translator...%RESET%
    start "" "%EXE_PATH%"
    exit /b 0
)

:: Se não existe executável, tenta executar via Python
echo.
echo %YELLOW%⚠️  Executável não encontrado. Tentando modo desenvolvimento...%RESET%
echo.

python --version >nul 2>&1
if errorlevel 1 (
    echo %RED%❌ Python não encontrado!%RESET%
    echo.
    echo %CYAN%Execute o arquivo INSTALAR.bat para configurar o programa.%RESET%
    echo.
    pause
    exit /b 1
)

:: Verifica dependências
python -c "import PySide6" >nul 2>&1
if errorlevel 1 (
    echo %YELLOW%📦 Instalando dependências necessárias...%RESET%
    pip install PySide6 requests psutil >nul 2>&1
)

echo %GREEN%▶️  Iniciando Game Translator...%RESET%
echo.

cd /d "%SCRIPT_DIR%src"
python main.py

pause
