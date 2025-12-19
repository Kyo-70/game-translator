@echo off
setlocal EnableDelayedExpansion

:: ============================================================================
:: GAME TRANSLATOR - VERIFICACAO COMPLETA DO SISTEMA
:: Versao: 1.0.2 - Compativel com Windows 11
:: ============================================================================

chcp 65001 >nul 2>&1
title Game Translator - Verificacao do Sistema

cls
echo.
echo ========================================================================
echo  GAME TRANSLATOR - VERIFICACAO COMPLETA DO SISTEMA
echo ========================================================================
echo.

set "ERROS=0"
set "AVISOS=0"
set "SCRIPT_DIR=%~dp0"

:: ============================================================================
:: VERIFICACAO DO SISTEMA OPERACIONAL
:: ============================================================================
echo ------------------------------------------------------------------------
echo  SISTEMA OPERACIONAL
echo ------------------------------------------------------------------------
echo.

:: Usa systeminfo em vez de wmic (compativel com Windows 11)
for /f "tokens=*" %%a in ('systeminfo ^| findstr /B /C:"OS Name" /C:"Nome do sistema"') do (
    echo    %%a
)
for /f "tokens=*" %%a in ('systeminfo ^| findstr /B /C:"OS Version" /C:"Versao do sistema"') do (
    echo    %%a
)
echo.

:: ============================================================================
:: VERIFICACAO DO PYTHON
:: ============================================================================
echo ------------------------------------------------------------------------
echo  PYTHON
echo ------------------------------------------------------------------------
echo.

python --version >nul 2>&1
if errorlevel 1 (
    echo    [ERRO] Python NAO INSTALADO
    echo    Baixe em: https://www.python.org/downloads/
    set /a ERROS+=1
) else (
    for /f "tokens=2" %%v in ('python --version 2^>nul') do (
        echo    [OK] Versao: %%v
    )
    
    :: Verifica se esta no PATH
    where python >nul 2>&1
    if errorlevel 1 (
        echo    [AVISO] Python nao esta no PATH do sistema
        set /a AVISOS+=1
    ) else (
        echo    [OK] Python esta no PATH
    )
)
echo.

:: ============================================================================
:: VERIFICACAO DO PIP
:: ============================================================================
echo ------------------------------------------------------------------------
echo  PIP (Gerenciador de Pacotes)
echo ------------------------------------------------------------------------
echo.

pip --version >nul 2>&1
if errorlevel 1 (
    echo    [ERRO] pip NAO INSTALADO
    set /a ERROS+=1
) else (
    for /f "tokens=2" %%v in ('pip --version 2^>nul') do (
        echo    [OK] Versao: %%v
    )
)
echo.

:: ============================================================================
:: VERIFICACAO DAS BIBLIOTECAS
:: ============================================================================
echo ------------------------------------------------------------------------
echo  BIBLIOTECAS PYTHON
echo ------------------------------------------------------------------------
echo.

:: PySide6
python -c "import PySide6; print(PySide6.__version__)" >nul 2>&1
if errorlevel 1 (
    echo    [AVISO] PySide6: Nao instalado
    set /a AVISOS+=1
) else (
    for /f %%v in ('python -c "import PySide6; print(PySide6.__version__)" 2^>nul') do (
        echo    [OK] PySide6: %%v
    )
)

:: requests
python -c "import requests; print(requests.__version__)" >nul 2>&1
if errorlevel 1 (
    echo    [AVISO] requests: Nao instalado
    set /a AVISOS+=1
) else (
    for /f %%v in ('python -c "import requests; print(requests.__version__)" 2^>nul') do (
        echo    [OK] requests: %%v
    )
)

:: psutil
python -c "import psutil; print(psutil.__version__)" >nul 2>&1
if errorlevel 1 (
    echo    [AVISO] psutil: Nao instalado
    set /a AVISOS+=1
) else (
    for /f %%v in ('python -c "import psutil; print(psutil.__version__)" 2^>nul') do (
        echo    [OK] psutil: %%v
    )
)

:: PyInstaller
pyinstaller --version >nul 2>&1
if errorlevel 1 (
    echo    [AVISO] PyInstaller: Nao instalado (necessario para criar .exe)
    set /a AVISOS+=1
) else (
    for /f %%v in ('pyinstaller --version 2^>nul') do (
        echo    [OK] PyInstaller: %%v
    )
)
echo.

:: ============================================================================
:: VERIFICACAO DOS ARQUIVOS DO PROJETO
:: ============================================================================
echo ------------------------------------------------------------------------
echo  ARQUIVOS DO PROJETO
echo ------------------------------------------------------------------------
echo.

if exist "%SCRIPT_DIR%src\main.py" (
    echo    [OK] src\main.py: Encontrado
) else (
    echo    [ERRO] src\main.py: NAO ENCONTRADO
    set /a ERROS+=1
)

if exist "%SCRIPT_DIR%src\database.py" (
    echo    [OK] src\database.py: Encontrado
) else (
    echo    [ERRO] src\database.py: NAO ENCONTRADO
    set /a ERROS+=1
)

if exist "%SCRIPT_DIR%src\gui\main_window.py" (
    echo    [OK] src\gui\main_window.py: Encontrado
) else (
    echo    [ERRO] src\gui\main_window.py: NAO ENCONTRADO
    set /a ERROS+=1
)

if exist "%SCRIPT_DIR%requirements.txt" (
    echo    [OK] requirements.txt: Encontrado
) else (
    echo    [AVISO] requirements.txt: Nao encontrado
    set /a AVISOS+=1
)

if exist "%SCRIPT_DIR%dist\GameTranslator.exe" (
    echo    [OK] dist\GameTranslator.exe: Executavel criado
) else (
    echo    [INFO] dist\GameTranslator.exe: Executavel nao criado ainda
)
echo.

:: ============================================================================
:: INSTALAR DEPENDENCIAS FALTANTES
:: ============================================================================
if !AVISOS! GTR 0 (
    echo ------------------------------------------------------------------------
    echo  INSTALAR DEPENDENCIAS FALTANTES
    echo ------------------------------------------------------------------------
    echo.
    set /p "INSTALAR=Deseja instalar as dependencias faltantes agora? (S/N): "
    if /i "!INSTALAR!"=="S" (
        echo.
        echo [INFO] Instalando dependencias...
        
        python -c "import PySide6" >nul 2>&1
        if errorlevel 1 (
            echo    [+] Instalando PySide6...
            pip install PySide6>=6.6.0
        )
        
        python -c "import requests" >nul 2>&1
        if errorlevel 1 (
            echo    [+] Instalando requests...
            pip install requests>=2.31.0
        )
        
        python -c "import psutil" >nul 2>&1
        if errorlevel 1 (
            echo    [+] Instalando psutil...
            pip install psutil>=5.9.0
        )
        
        pyinstaller --version >nul 2>&1
        if errorlevel 1 (
            echo    [+] Instalando PyInstaller...
            pip install pyinstaller
        )
        
        echo.
        echo [OK] Dependencias instaladas!
        echo.
        echo Executando verificacao novamente...
        timeout /t 2 >nul
        goto :eof
        call "%~f0"
    )
)

:: ============================================================================
:: RESUMO FINAL
:: ============================================================================
echo.
echo ========================================================================
echo  RESUMO DA VERIFICACAO
echo ========================================================================
echo.

if !ERROS! EQU 0 (
    if !AVISOS! EQU 0 (
        echo   [OK] SISTEMA TOTALMENTE COMPATIVEL!
        echo.
        echo   Seu sistema esta pronto para executar o Game Translator.
        echo   Execute INSTALAR.bat para criar o executavel.
    ) else (
        echo   [AVISO] SISTEMA COMPATIVEL COM AVISOS
        echo.
        echo   Avisos encontrados: !AVISOS!
        echo   O programa deve funcionar, mas pode haver limitacoes.
    )
) else (
    echo   [ERRO] PROBLEMAS ENCONTRADOS
    echo.
    echo   Erros criticos: !ERROS!
    echo   Avisos: !AVISOS!
    echo.
    echo   Corrija os erros antes de continuar.
)

echo.
echo ========================================================================
echo.

pause
