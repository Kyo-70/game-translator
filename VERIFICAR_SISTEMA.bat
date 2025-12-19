@echo off
chcp 65001 >nul 2>&1
title Game Translator - Verificacao do Sistema

echo.
echo ========================================================================
echo   GAME TRANSLATOR - VERIFICACAO DO SISTEMA v1.0.6
echo ========================================================================
echo.

set "ERROS=0"
set "AVISOS=0"
set "NEED_PYSIDE=0"
set "NEED_REQUESTS=0"
set "NEED_PSUTIL=0"
set "NEED_PYINSTALLER=0"

echo [1/4] Verificando Python...
echo.

py --version >nul 2>&1
if errorlevel 1 (
    echo    [X] Python NAO ENCONTRADO
    echo.
    echo    Baixe em: https://www.python.org/downloads/
    echo    Durante a instalacao, marque "Add Python to PATH"
    set /a ERROS+=1
    goto CHECK_FILES
) else (
    for /f "tokens=*" %%i in ('py --version') do echo    [OK] %%i encontrado
)

echo.
echo [2/4] Verificando pip...
echo.

py -m pip --version >nul 2>&1
if errorlevel 1 (
    echo    [X] pip NAO ENCONTRADO
    set /a ERROS+=1
) else (
    echo    [OK] pip instalado
)

echo.
echo [3/4] Verificando bibliotecas...
echo.

py -c "import PySide6" >nul 2>&1
if errorlevel 1 (
    echo    [!] PySide6: Nao instalado
    set /a AVISOS+=1
    set "NEED_PYSIDE=1"
) else (
    echo    [OK] PySide6: instalado
)

py -c "import requests" >nul 2>&1
if errorlevel 1 (
    echo    [!] requests: Nao instalado
    set /a AVISOS+=1
    set "NEED_REQUESTS=1"
) else (
    echo    [OK] requests: instalado
)

py -c "import psutil" >nul 2>&1
if errorlevel 1 (
    echo    [!] psutil: Nao instalado
    set /a AVISOS+=1
    set "NEED_PSUTIL=1"
) else (
    echo    [OK] psutil: instalado
)

py -m PyInstaller --version >nul 2>&1
if errorlevel 1 (
    echo    [!] PyInstaller: Nao instalado
    set /a AVISOS+=1
    set "NEED_PYINSTALLER=1"
) else (
    echo    [OK] PyInstaller: instalado
)

:CHECK_FILES
echo.
echo [4/4] Verificando arquivos do projeto...
echo.

if exist "%~dp0src\main.py" (
    echo    [OK] src\main.py
) else (
    echo    [X] src\main.py NAO ENCONTRADO
    set /a ERROS+=1
)

if exist "%~dp0src\gui\main_window.py" (
    echo    [OK] src\gui\main_window.py
) else (
    echo    [X] src\gui\main_window.py NAO ENCONTRADO
    set /a ERROS+=1
)

if exist "%~dp0src\database.py" (
    echo    [OK] src\database.py
) else (
    echo    [X] src\database.py NAO ENCONTRADO
    set /a ERROS+=1
)

if exist "%~dp0dist\GameTranslator.exe" (
    echo    [OK] Executavel ja criado
) else (
    echo    [i] Executavel ainda nao criado
)

echo.
echo ========================================================================
echo   RESUMO
echo ========================================================================
echo.

if %ERROS% EQU 0 (
    if %AVISOS% EQU 0 (
        echo    [OK] SISTEMA PRONTO!
        echo    Execute INSTALAR.bat para criar o executavel.
    ) else (
        echo    [!] Sistema OK, mas faltam %AVISOS% dependencia(s).
        echo.
        set /p INSTALAR="Instalar dependencias agora? (S/N): "
        if /i "%INSTALAR%"=="S" (
            echo.
            echo Instalando dependencias...
            echo.
            
            if "%NEED_PYSIDE%"=="1" (
                echo    Instalando PySide6...
                py -m pip install PySide6
            )
            
            if "%NEED_REQUESTS%"=="1" (
                echo    Instalando requests...
                py -m pip install requests
            )
            
            if "%NEED_PSUTIL%"=="1" (
                echo    Instalando psutil...
                py -m pip install psutil
            )
            
            if "%NEED_PYINSTALLER%"=="1" (
                echo    Instalando PyInstaller...
                py -m pip install pyinstaller
            )
            
            echo.
            echo [OK] Pronto! Execute INSTALAR.bat para criar o executavel.
        )
    )
) else (
    echo    [X] PROBLEMAS ENCONTRADOS: %ERROS% erro(s), %AVISOS% aviso(s)
    echo    Corrija os erros antes de continuar.
)

echo.
echo ========================================================================
echo.
echo Pressione qualquer tecla para fechar...
pause >nul
