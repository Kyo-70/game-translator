@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion

:: Cores
set "RESET=[0m"
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "MAGENTA=[95m"
set "CYAN=[96m"
set "WHITE=[97m"
set "BOLD=[1m"

title Game Translator - Verificação do Sistema

cls
echo.
echo %CYAN%╔══════════════════════════════════════════════════════════════════════════════╗%RESET%
echo %CYAN%║%RESET%  %BOLD%%MAGENTA%🔍 GAME TRANSLATOR - VERIFICAÇÃO COMPLETA DO SISTEMA%RESET%                       %CYAN%║%RESET%
echo %CYAN%╚══════════════════════════════════════════════════════════════════════════════╝%RESET%
echo.

set "ERROS=0"
set "AVISOS=0"

:: ============================================================================
:: VERIFICAÇÃO DO SISTEMA OPERACIONAL
:: ============================================================================
echo %CYAN%━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%RESET%
echo %BOLD%📋 SISTEMA OPERACIONAL%RESET%
echo %CYAN%━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%RESET%

for /f "tokens=2 delims==" %%a in ('wmic os get Caption /value 2^>nul') do set "OS_NAME=%%a"
for /f "tokens=2 delims==" %%a in ('wmic os get Version /value 2^>nul') do set "OS_VERSION=%%a"
for /f "tokens=2 delims==" %%a in ('wmic os get OSArchitecture /value 2^>nul') do set "OS_ARCH=%%a"

echo    Sistema: %GREEN%!OS_NAME!%RESET%
echo    Versão: %GREEN%!OS_VERSION!%RESET%
echo    Arquitetura: %GREEN%!OS_ARCH!%RESET%

:: Verifica se é Windows 10/11
echo !OS_NAME! | findstr /i "Windows 10 Windows 11" >nul
if errorlevel 1 (
    echo    %YELLOW%⚠️  Sistema operacional pode não ser totalmente compatível%RESET%
    set /a AVISOS+=1
) else (
    echo    %GREEN%✅ Sistema operacional compatível%RESET%
)

:: ============================================================================
:: VERIFICAÇÃO DE HARDWARE
:: ============================================================================
echo.
echo %CYAN%━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%RESET%
echo %BOLD%💻 HARDWARE%RESET%
echo %CYAN%━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%RESET%

:: CPU
for /f "tokens=2 delims==" %%a in ('wmic cpu get Name /value 2^>nul') do set "CPU_NAME=%%a"
for /f "tokens=2 delims==" %%a in ('wmic cpu get NumberOfCores /value 2^>nul') do set "CPU_CORES=%%a"
echo    CPU: %GREEN%!CPU_NAME!%RESET%
echo    Núcleos: %GREEN%!CPU_CORES!%RESET%

:: RAM
for /f "tokens=2 delims==" %%a in ('wmic os get TotalVisibleMemorySize /value 2^>nul') do set "RAM_TOTAL=%%a"
for /f "tokens=2 delims==" %%a in ('wmic os get FreePhysicalMemory /value 2^>nul') do set "RAM_FREE=%%a"
set /a "RAM_TOTAL_MB=!RAM_TOTAL!/1024" 2>nul
set /a "RAM_FREE_MB=!RAM_FREE!/1024" 2>nul
echo    RAM Total: %GREEN%!RAM_TOTAL_MB! MB%RESET%
echo    RAM Livre: %GREEN%!RAM_FREE_MB! MB%RESET%

if !RAM_FREE_MB! LSS 500 (
    echo    %RED%❌ Memória RAM insuficiente (mínimo: 500 MB livres)%RESET%
    set /a ERROS+=1
) else if !RAM_FREE_MB! LSS 1000 (
    echo    %YELLOW%⚠️  Memória RAM baixa, pode afetar performance%RESET%
    set /a AVISOS+=1
) else (
    echo    %GREEN%✅ Memória RAM adequada%RESET%
)

:: Disco
for /f "tokens=2 delims==" %%a in ('wmic logicaldisk where "DeviceID='C:'" get FreeSpace /value 2^>nul') do set "DISK_FREE=%%a"
set /a "DISK_FREE_GB=!DISK_FREE!/1073741824" 2>nul
echo    Espaço livre (C:): %GREEN%!DISK_FREE_GB! GB%RESET%

if !DISK_FREE_GB! LSS 1 (
    echo    %RED%❌ Espaço em disco insuficiente (mínimo: 1 GB)%RESET%
    set /a ERROS+=1
) else if !DISK_FREE_GB! LSS 5 (
    echo    %YELLOW%⚠️  Espaço em disco baixo%RESET%
    set /a AVISOS+=1
) else (
    echo    %GREEN%✅ Espaço em disco adequado%RESET%
)

:: ============================================================================
:: VERIFICAÇÃO DO PYTHON
:: ============================================================================
echo.
echo %CYAN%━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%RESET%
echo %BOLD%🐍 PYTHON%RESET%
echo %CYAN%━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%RESET%

python --version >nul 2>&1
if errorlevel 1 (
    echo    %RED%❌ Python NÃO INSTALADO%RESET%
    echo    %CYAN%   Baixe em: https://www.python.org/downloads/%RESET%
    set /a ERROS+=1
) else (
    for /f "tokens=2" %%v in ('python --version 2^>nul') do set "PYTHON_VER=%%v"
    echo    Versão: %GREEN%!PYTHON_VER!%RESET%
    
    :: Verifica se é 3.8+
    for /f "tokens=1,2 delims=." %%a in ("!PYTHON_VER!") do (
        set "PY_MAJOR=%%a"
        set "PY_MINOR=%%b"
    )
    
    if !PY_MAJOR! GEQ 3 (
        if !PY_MINOR! GEQ 8 (
            echo    %GREEN%✅ Versão compatível (3.8+)%RESET%
        ) else (
            echo    %YELLOW%⚠️  Versão antiga, recomendado 3.8+%RESET%
            set /a AVISOS+=1
        )
    ) else (
        echo    %RED%❌ Versão incompatível (necessário 3.8+)%RESET%
        set /a ERROS+=1
    )
    
    :: Verifica PATH
    where python >nul 2>&1
    if errorlevel 1 (
        echo    %YELLOW%⚠️  Python não está no PATH do sistema%RESET%
        set /a AVISOS+=1
    ) else (
        echo    %GREEN%✅ Python está no PATH%RESET%
    )
)

:: ============================================================================
:: VERIFICAÇÃO DO PIP
:: ============================================================================
echo.
echo %CYAN%━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%RESET%
echo %BOLD%📦 PIP (Gerenciador de Pacotes)%RESET%
echo %CYAN%━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%RESET%

pip --version >nul 2>&1
if errorlevel 1 (
    echo    %RED%❌ pip NÃO INSTALADO%RESET%
    set /a ERROS+=1
) else (
    for /f "tokens=2" %%v in ('pip --version 2^>nul') do set "PIP_VER=%%v"
    echo    Versão: %GREEN%!PIP_VER!%RESET%
    echo    %GREEN%✅ pip instalado%RESET%
)

:: ============================================================================
:: VERIFICAÇÃO DAS BIBLIOTECAS
:: ============================================================================
echo.
echo %CYAN%━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%RESET%
echo %BOLD%📚 BIBLIOTECAS PYTHON%RESET%
echo %CYAN%━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%RESET%

:: PySide6
python -c "import PySide6; print(PySide6.__version__)" >nul 2>&1
if errorlevel 1 (
    echo    %YELLOW%⚠️  PySide6: Não instalado%RESET%
    set /a AVISOS+=1
) else (
    for /f %%v in ('python -c "import PySide6; print(PySide6.__version__)" 2^>nul') do set "PYSIDE_VER=%%v"
    echo    PySide6: %GREEN%!PYSIDE_VER!%RESET% ✅
)

:: requests
python -c "import requests; print(requests.__version__)" >nul 2>&1
if errorlevel 1 (
    echo    %YELLOW%⚠️  requests: Não instalado%RESET%
    set /a AVISOS+=1
) else (
    for /f %%v in ('python -c "import requests; print(requests.__version__)" 2^>nul') do set "REQ_VER=%%v"
    echo    requests: %GREEN%!REQ_VER!%RESET% ✅
)

:: psutil
python -c "import psutil; print(psutil.__version__)" >nul 2>&1
if errorlevel 1 (
    echo    %YELLOW%⚠️  psutil: Não instalado%RESET%
    set /a AVISOS+=1
) else (
    for /f %%v in ('python -c "import psutil; print(psutil.__version__)" 2^>nul') do set "PSU_VER=%%v"
    echo    psutil: %GREEN%!PSU_VER!%RESET% ✅
)

:: PyInstaller
pyinstaller --version >nul 2>&1
if errorlevel 1 (
    echo    %YELLOW%⚠️  PyInstaller: Não instalado (necessário para criar .exe)%RESET%
    set /a AVISOS+=1
) else (
    for /f %%v in ('pyinstaller --version 2^>nul') do set "PYINST_VER=%%v"
    echo    PyInstaller: %GREEN%!PYINST_VER!%RESET% ✅
)

:: ============================================================================
:: VERIFICAÇÃO DOS ARQUIVOS DO PROJETO
:: ============================================================================
echo.
echo %CYAN%━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%RESET%
echo %BOLD%📁 ARQUIVOS DO PROJETO%RESET%
echo %CYAN%━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%RESET%

set "SCRIPT_DIR=%~dp0"

if exist "%SCRIPT_DIR%src\main.py" (
    echo    src\main.py: %GREEN%✅ Encontrado%RESET%
) else (
    echo    src\main.py: %RED%❌ NÃO ENCONTRADO%RESET%
    set /a ERROS+=1
)

if exist "%SCRIPT_DIR%src\database.py" (
    echo    src\database.py: %GREEN%✅ Encontrado%RESET%
) else (
    echo    src\database.py: %RED%❌ NÃO ENCONTRADO%RESET%
    set /a ERROS+=1
)

if exist "%SCRIPT_DIR%src\gui\main_window.py" (
    echo    src\gui\main_window.py: %GREEN%✅ Encontrado%RESET%
) else (
    echo    src\gui\main_window.py: %RED%❌ NÃO ENCONTRADO%RESET%
    set /a ERROS+=1
)

if exist "%SCRIPT_DIR%requirements.txt" (
    echo    requirements.txt: %GREEN%✅ Encontrado%RESET%
) else (
    echo    requirements.txt: %YELLOW%⚠️  Não encontrado%RESET%
    set /a AVISOS+=1
)

if exist "%SCRIPT_DIR%dist\GameTranslator.exe" (
    echo    dist\GameTranslator.exe: %GREEN%✅ Executável criado%RESET%
) else (
    echo    dist\GameTranslator.exe: %YELLOW%⚠️  Executável não criado ainda%RESET%
)

:: ============================================================================
:: RESUMO FINAL
:: ============================================================================
echo.
echo %CYAN%╔══════════════════════════════════════════════════════════════════════════════╗%RESET%
echo %CYAN%║%RESET%  %BOLD%📊 RESUMO DA VERIFICAÇÃO%RESET%                                                    %CYAN%║%RESET%
echo %CYAN%╠══════════════════════════════════════════════════════════════════════════════╣%RESET%

if !ERROS! EQU 0 (
    if !AVISOS! EQU 0 (
        echo %CYAN%║%RESET%                                                                              %CYAN%║%RESET%
        echo %CYAN%║%RESET%   %GREEN%✅ SISTEMA TOTALMENTE COMPATÍVEL!%RESET%                                      %CYAN%║%RESET%
        echo %CYAN%║%RESET%                                                                              %CYAN%║%RESET%
        echo %CYAN%║%RESET%   Seu sistema está pronto para executar o Game Translator.                  %CYAN%║%RESET%
        echo %CYAN%║%RESET%   Execute INSTALAR.bat para criar o executável.                             %CYAN%║%RESET%
    ) else (
        echo %CYAN%║%RESET%                                                                              %CYAN%║%RESET%
        echo %CYAN%║%RESET%   %YELLOW%⚠️  SISTEMA COMPATÍVEL COM AVISOS%RESET%                                       %CYAN%║%RESET%
        echo %CYAN%║%RESET%                                                                              %CYAN%║%RESET%
        echo %CYAN%║%RESET%   Avisos encontrados: %YELLOW%!AVISOS!%RESET%                                              %CYAN%║%RESET%
        echo %CYAN%║%RESET%   O programa deve funcionar, mas pode haver limitações.                     %CYAN%║%RESET%
    )
) else (
    echo %CYAN%║%RESET%                                                                              %CYAN%║%RESET%
    echo %CYAN%║%RESET%   %RED%❌ PROBLEMAS ENCONTRADOS%RESET%                                                  %CYAN%║%RESET%
    echo %CYAN%║%RESET%                                                                              %CYAN%║%RESET%
    echo %CYAN%║%RESET%   Erros críticos: %RED%!ERROS!%RESET%                                                    %CYAN%║%RESET%
    echo %CYAN%║%RESET%   Avisos: %YELLOW%!AVISOS!%RESET%                                                            %CYAN%║%RESET%
    echo %CYAN%║%RESET%                                                                              %CYAN%║%RESET%
    echo %CYAN%║%RESET%   Corrija os erros antes de continuar.                                        %CYAN%║%RESET%
)

echo %CYAN%║%RESET%                                                                              %CYAN%║%RESET%
echo %CYAN%╚══════════════════════════════════════════════════════════════════════════════╝%RESET%
echo.

pause
