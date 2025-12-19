@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion

:: ============================================================================
:: GAME TRANSLATOR - INSTALADOR E CONSTRUTOR DE EXECUTÁVEL
:: Versão: 1.0.0
:: ============================================================================

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

:: Variáveis
set "PYTHON_MIN_VERSION=3.8"
set "SCRIPT_DIR=%~dp0"
set "VENV_DIR=%SCRIPT_DIR%venv"
set "DIST_DIR=%SCRIPT_DIR%dist"
set "BUILD_DIR=%SCRIPT_DIR%build"

:: Título da janela
title Game Translator - Instalador v1.0.0

:MENU_PRINCIPAL
cls
echo.
echo %CYAN%╔══════════════════════════════════════════════════════════════════════════════╗%RESET%
echo %CYAN%║%RESET%                                                                              %CYAN%║%RESET%
echo %CYAN%║%RESET%  %BOLD%%MAGENTA%   ██████╗  █████╗ ███╗   ███╗███████╗                                  %RESET%%CYAN%║%RESET%
echo %CYAN%║%RESET%  %BOLD%%MAGENTA%  ██╔════╝ ██╔══██╗████╗ ████║██╔════╝                                  %RESET%%CYAN%║%RESET%
echo %CYAN%║%RESET%  %BOLD%%MAGENTA%  ██║  ███╗███████║██╔████╔██║█████╗                                    %RESET%%CYAN%║%RESET%
echo %CYAN%║%RESET%  %BOLD%%MAGENTA%  ██║   ██║██╔══██║██║╚██╔╝██║██╔══╝                                    %RESET%%CYAN%║%RESET%
echo %CYAN%║%RESET%  %BOLD%%MAGENTA%  ╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗                                  %RESET%%CYAN%║%RESET%
echo %CYAN%║%RESET%  %BOLD%%MAGENTA%   ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝                                  %RESET%%CYAN%║%RESET%
echo %CYAN%║%RESET%                                                                              %CYAN%║%RESET%
echo %CYAN%║%RESET%  %BOLD%%YELLOW%  ████████╗██████╗  █████╗ ███╗   ██╗███████╗██╗      █████╗ ████████╗ %RESET%%CYAN%║%RESET%
echo %CYAN%║%RESET%  %BOLD%%YELLOW%  ╚══██╔══╝██╔══██╗██╔══██╗████╗  ██║██╔════╝██║     ██╔══██╗╚══██╔══╝ %RESET%%CYAN%║%RESET%
echo %CYAN%║%RESET%  %BOLD%%YELLOW%     ██║   ██████╔╝███████║██╔██╗ ██║███████╗██║     ███████║   ██║    %RESET%%CYAN%║%RESET%
echo %CYAN%║%RESET%  %BOLD%%YELLOW%     ██║   ██╔══██╗██╔══██║██║╚██╗██║╚════██║██║     ██╔══██║   ██║    %RESET%%CYAN%║%RESET%
echo %CYAN%║%RESET%  %BOLD%%YELLOW%     ██║   ██║  ██║██║  ██║██║ ╚████║███████║███████╗██║  ██║   ██║    %RESET%%CYAN%║%RESET%
echo %CYAN%║%RESET%  %BOLD%%YELLOW%     ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝╚═╝  ╚═╝   ╚═╝    %RESET%%CYAN%║%RESET%
echo %CYAN%║%RESET%                                                                              %CYAN%║%RESET%
echo %CYAN%║%RESET%          %WHITE%Sistema Profissional de Tradução para Jogos e Mods%RESET%               %CYAN%║%RESET%
echo %CYAN%║%RESET%                         %CYAN%Versão 1.0.0%RESET%                                       %CYAN%║%RESET%
echo %CYAN%║%RESET%                                                                              %CYAN%║%RESET%
echo %CYAN%╠══════════════════════════════════════════════════════════════════════════════╣%RESET%
echo %CYAN%║%RESET%                                                                              %CYAN%║%RESET%
echo %CYAN%║%RESET%   %GREEN%[1]%RESET% 🚀 Instalação Completa (Recomendado)                                 %CYAN%║%RESET%
echo %CYAN%║%RESET%                                                                              %CYAN%║%RESET%
echo %CYAN%║%RESET%   %YELLOW%[2]%RESET% 🔍 Verificar Requisitos do Sistema                                   %CYAN%║%RESET%
echo %CYAN%║%RESET%                                                                              %CYAN%║%RESET%
echo %CYAN%║%RESET%   %BLUE%[3]%RESET% 📦 Instalar Dependências (pip)                                        %CYAN%║%RESET%
echo %CYAN%║%RESET%                                                                              %CYAN%║%RESET%
echo %CYAN%║%RESET%   %MAGENTA%[4]%RESET% 🔨 Criar Executável (.exe)                                            %CYAN%║%RESET%
echo %CYAN%║%RESET%                                                                              %CYAN%║%RESET%
echo %CYAN%║%RESET%   %CYAN%[5]%RESET% ▶️  Executar Programa (modo desenvolvimento)                           %CYAN%║%RESET%
echo %CYAN%║%RESET%                                                                              %CYAN%║%RESET%
echo %CYAN%║%RESET%   %WHITE%[6]%RESET% 🛠️  Configurar PATH do Sistema                                         %CYAN%║%RESET%
echo %CYAN%║%RESET%                                                                              %CYAN%║%RESET%
echo %CYAN%║%RESET%   %RED%[0]%RESET% ❌ Sair                                                                %CYAN%║%RESET%
echo %CYAN%║%RESET%                                                                              %CYAN%║%RESET%
echo %CYAN%╚══════════════════════════════════════════════════════════════════════════════╝%RESET%
echo.

set /p "OPCAO=%BOLD%Digite sua opção: %RESET%"

if "%OPCAO%"=="1" goto INSTALACAO_COMPLETA
if "%OPCAO%"=="2" goto VERIFICAR_REQUISITOS
if "%OPCAO%"=="3" goto INSTALAR_DEPENDENCIAS
if "%OPCAO%"=="4" goto CRIAR_EXECUTAVEL
if "%OPCAO%"=="5" goto EXECUTAR_PROGRAMA
if "%OPCAO%"=="6" goto CONFIGURAR_PATH
if "%OPCAO%"=="0" goto SAIR

echo.
echo %RED%⚠️  Opção inválida! Pressione qualquer tecla para continuar...%RESET%
pause >nul
goto MENU_PRINCIPAL

:: ============================================================================
:: INSTALAÇÃO COMPLETA
:: ============================================================================
:INSTALACAO_COMPLETA
cls
call :MOSTRAR_CABECALHO "INSTALAÇÃO COMPLETA"
echo.
echo %CYAN%Esta opção irá:%RESET%
echo   %GREEN%✓%RESET% Verificar se Python está instalado
echo   %GREEN%✓%RESET% Instalar todas as dependências necessárias
echo   %GREEN%✓%RESET% Criar o executável (.exe)
echo   %GREEN%✓%RESET% Configurar atalhos
echo.
echo %YELLOW%⚠️  Este processo pode levar alguns minutos.%RESET%
echo.
set /p "CONFIRMA=%BOLD%Deseja continuar? (S/N): %RESET%"
if /i not "%CONFIRMA%"=="S" goto MENU_PRINCIPAL

echo.
echo %CYAN%══════════════════════════════════════════════════════════════════════════════%RESET%
echo %BOLD%ETAPA 1/4: Verificando Python...%RESET%
echo %CYAN%══════════════════════════════════════════════════════════════════════════════%RESET%
call :VERIFICAR_PYTHON
if errorlevel 1 goto MENU_PRINCIPAL

echo.
echo %CYAN%══════════════════════════════════════════════════════════════════════════════%RESET%
echo %BOLD%ETAPA 2/4: Instalando dependências...%RESET%
echo %CYAN%══════════════════════════════════════════════════════════════════════════════%RESET%
call :INSTALAR_DEPS
if errorlevel 1 goto MENU_PRINCIPAL

echo.
echo %CYAN%══════════════════════════════════════════════════════════════════════════════%RESET%
echo %BOLD%ETAPA 3/4: Criando executável...%RESET%
echo %CYAN%══════════════════════════════════════════════════════════════════════════════%RESET%
call :CRIAR_EXE
if errorlevel 1 goto MENU_PRINCIPAL

echo.
echo %CYAN%══════════════════════════════════════════════════════════════════════════════%RESET%
echo %BOLD%ETAPA 4/4: Finalizando instalação...%RESET%
echo %CYAN%══════════════════════════════════════════════════════════════════════════════%RESET%
call :FINALIZAR_INSTALACAO

echo.
echo %GREEN%╔══════════════════════════════════════════════════════════════════════════════╗%RESET%
echo %GREEN%║%RESET%                                                                              %GREEN%║%RESET%
echo %GREEN%║%RESET%   %BOLD%%GREEN%✅ INSTALAÇÃO CONCLUÍDA COM SUCESSO!%RESET%                                    %GREEN%║%RESET%
echo %GREEN%║%RESET%                                                                              %GREEN%║%RESET%
echo %GREEN%║%RESET%   O executável foi criado em:                                                %GREEN%║%RESET%
echo %GREEN%║%RESET%   %CYAN%%DIST_DIR%\GameTranslator.exe%RESET%                         %GREEN%║%RESET%
echo %GREEN%║%RESET%                                                                              %GREEN%║%RESET%
echo %GREEN%║%RESET%   Você pode executar o programa diretamente ou criar um atalho              %GREEN%║%RESET%
echo %GREEN%║%RESET%   na área de trabalho.                                                       %GREEN%║%RESET%
echo %GREEN%║%RESET%                                                                              %GREEN%║%RESET%
echo %GREEN%╚══════════════════════════════════════════════════════════════════════════════╝%RESET%
echo.
set /p "ABRIR=%BOLD%Deseja abrir o programa agora? (S/N): %RESET%"
if /i "%ABRIR%"=="S" (
    start "" "%DIST_DIR%\GameTranslator.exe"
)
echo.
pause
goto MENU_PRINCIPAL

:: ============================================================================
:: VERIFICAR REQUISITOS
:: ============================================================================
:VERIFICAR_REQUISITOS
cls
call :MOSTRAR_CABECALHO "VERIFICAÇÃO DE REQUISITOS"
echo.

:: Verifica Python
echo %CYAN%🔍 Verificando Python...%RESET%
call :VERIFICAR_PYTHON_SILENCIOSO
if errorlevel 1 (
    echo    %RED%❌ Python não encontrado ou versão incompatível%RESET%
    set "PYTHON_OK=NAO"
) else (
    echo    %GREEN%✅ Python encontrado: !PYTHON_VERSION!%RESET%
    set "PYTHON_OK=SIM"
)

:: Verifica pip
echo.
echo %CYAN%🔍 Verificando pip...%RESET%
pip --version >nul 2>&1
if errorlevel 1 (
    echo    %RED%❌ pip não encontrado%RESET%
    set "PIP_OK=NAO"
) else (
    for /f "tokens=2" %%v in ('pip --version 2^>nul') do set "PIP_VERSION=%%v"
    echo    %GREEN%✅ pip encontrado: !PIP_VERSION!%RESET%
    set "PIP_OK=SIM"
)

:: Verifica bibliotecas
echo.
echo %CYAN%🔍 Verificando bibliotecas necessárias...%RESET%

call :VERIFICAR_BIBLIOTECA PySide6
call :VERIFICAR_BIBLIOTECA requests
call :VERIFICAR_BIBLIOTECA psutil

:: Verifica espaço em disco
echo.
echo %CYAN%🔍 Verificando espaço em disco...%RESET%
for /f "tokens=3" %%a in ('dir /-c "%SCRIPT_DIR%" 2^>nul ^| find "bytes free"') do set "ESPACO_LIVRE=%%a"
echo    %GREEN%✅ Espaço disponível: !ESPACO_LIVRE! bytes%RESET%

:: Verifica memória
echo.
echo %CYAN%🔍 Verificando memória do sistema...%RESET%
for /f "skip=1" %%p in ('wmic os get FreePhysicalMemory 2^>nul') do (
    set "MEM_LIVRE=%%p"
    goto :MEM_DONE
)
:MEM_DONE
set /a "MEM_LIVRE_MB=!MEM_LIVRE!/1024" 2>nul
echo    %GREEN%✅ Memória livre: !MEM_LIVRE_MB! MB%RESET%

echo.
echo %CYAN%══════════════════════════════════════════════════════════════════════════════%RESET%
echo %BOLD%RESUMO:%RESET%
echo %CYAN%══════════════════════════════════════════════════════════════════════════════%RESET%

if "%PYTHON_OK%"=="SIM" (
    echo   %GREEN%✅%RESET% Python: OK
) else (
    echo   %RED%❌%RESET% Python: NECESSÁRIO INSTALAR
)

if "%PIP_OK%"=="SIM" (
    echo   %GREEN%✅%RESET% pip: OK
) else (
    echo   %RED%❌%RESET% pip: NECESSÁRIO INSTALAR
)

echo.
pause
goto MENU_PRINCIPAL

:VERIFICAR_BIBLIOTECA
set "LIB_NAME=%~1"
python -c "import %LIB_NAME%" >nul 2>&1
if errorlevel 1 (
    echo    %YELLOW%⚠️  %LIB_NAME%: Não instalado%RESET%
) else (
    echo    %GREEN%✅ %LIB_NAME%: Instalado%RESET%
)
exit /b 0

:: ============================================================================
:: INSTALAR DEPENDÊNCIAS
:: ============================================================================
:INSTALAR_DEPENDENCIAS
cls
call :MOSTRAR_CABECALHO "INSTALAÇÃO DE DEPENDÊNCIAS"
echo.

call :VERIFICAR_PYTHON
if errorlevel 1 goto MENU_PRINCIPAL

echo.
echo %CYAN%📦 Atualizando pip...%RESET%
python -m pip install --upgrade pip

echo.
echo %CYAN%📦 Instalando dependências do requirements.txt...%RESET%
echo.

if exist "%SCRIPT_DIR%requirements.txt" (
    pip install -r "%SCRIPT_DIR%requirements.txt"
    if errorlevel 1 (
        echo.
        echo %RED%❌ Erro ao instalar dependências!%RESET%
        pause
        goto MENU_PRINCIPAL
    )
) else (
    echo %YELLOW%⚠️  Arquivo requirements.txt não encontrado. Instalando manualmente...%RESET%
    pip install PySide6>=6.6.0
    pip install requests>=2.31.0
    pip install psutil>=5.9.0
)

echo.
echo %CYAN%📦 Instalando PyInstaller para criar executável...%RESET%
pip install pyinstaller

echo.
echo %GREEN%✅ Todas as dependências foram instaladas com sucesso!%RESET%
echo.
pause
goto MENU_PRINCIPAL

:INSTALAR_DEPS
python -m pip install --upgrade pip >nul 2>&1
echo %CYAN%   📦 Instalando PySide6...%RESET%
pip install PySide6>=6.6.0 >nul 2>&1
echo %CYAN%   📦 Instalando requests...%RESET%
pip install requests>=2.31.0 >nul 2>&1
echo %CYAN%   📦 Instalando psutil...%RESET%
pip install psutil>=5.9.0 >nul 2>&1
echo %CYAN%   📦 Instalando PyInstaller...%RESET%
pip install pyinstaller >nul 2>&1
echo %GREEN%   ✅ Dependências instaladas!%RESET%
exit /b 0

:: ============================================================================
:: CRIAR EXECUTÁVEL
:: ============================================================================
:CRIAR_EXECUTAVEL
cls
call :MOSTRAR_CABECALHO "CRIAÇÃO DO EXECUTÁVEL"
echo.

call :VERIFICAR_PYTHON
if errorlevel 1 goto MENU_PRINCIPAL

:: Verifica PyInstaller
echo %CYAN%🔍 Verificando PyInstaller...%RESET%
pyinstaller --version >nul 2>&1
if errorlevel 1 (
    echo %YELLOW%⚠️  PyInstaller não encontrado. Instalando...%RESET%
    pip install pyinstaller
)

echo.
echo %CYAN%🔨 Criando executável...%RESET%
echo %YELLOW%   ⏳ Este processo pode levar alguns minutos...%RESET%
echo.

call :CRIAR_EXE

echo.
if exist "%DIST_DIR%\GameTranslator.exe" (
    echo %GREEN%✅ Executável criado com sucesso!%RESET%
    echo.
    echo %CYAN%📁 Localização: %DIST_DIR%\GameTranslator.exe%RESET%
    echo.
    set /p "ABRIR_PASTA=%BOLD%Deseja abrir a pasta do executável? (S/N): %RESET%"
    if /i "!ABRIR_PASTA!"=="S" (
        explorer "%DIST_DIR%"
    )
) else (
    echo %RED%❌ Erro ao criar executável!%RESET%
    echo %YELLOW%   Verifique os logs acima para mais detalhes.%RESET%
)

echo.
pause
goto MENU_PRINCIPAL

:CRIAR_EXE
cd /d "%SCRIPT_DIR%"

:: Limpa builds anteriores
if exist "%BUILD_DIR%" rmdir /s /q "%BUILD_DIR%" >nul 2>&1
if exist "%DIST_DIR%" rmdir /s /q "%DIST_DIR%" >nul 2>&1

:: Cria o executável
pyinstaller --name="GameTranslator" ^
    --onefile ^
    --windowed ^
    --noconfirm ^
    --clean ^
    --add-data "profiles;profiles" ^
    --add-data "src;src" ^
    --hidden-import=PySide6.QtCore ^
    --hidden-import=PySide6.QtGui ^
    --hidden-import=PySide6.QtWidgets ^
    --hidden-import=sqlite3 ^
    --hidden-import=psutil ^
    src/main.py

if errorlevel 1 (
    echo %RED%   ❌ Erro durante a criação do executável%RESET%
    exit /b 1
)

:: Copia arquivos necessários para a pasta dist
if not exist "%DIST_DIR%\profiles" mkdir "%DIST_DIR%\profiles"
xcopy /s /y "%SCRIPT_DIR%profiles\*" "%DIST_DIR%\profiles\" >nul 2>&1

echo %GREEN%   ✅ Executável criado!%RESET%
exit /b 0

:: ============================================================================
:: EXECUTAR PROGRAMA
:: ============================================================================
:EXECUTAR_PROGRAMA
cls
call :MOSTRAR_CABECALHO "EXECUTAR PROGRAMA"
echo.

call :VERIFICAR_PYTHON
if errorlevel 1 goto MENU_PRINCIPAL

echo %CYAN%▶️  Iniciando Game Translator em modo desenvolvimento...%RESET%
echo.

cd /d "%SCRIPT_DIR%src"
python main.py

echo.
echo %CYAN%Programa encerrado.%RESET%
pause
goto MENU_PRINCIPAL

:: ============================================================================
:: CONFIGURAR PATH
:: ============================================================================
:CONFIGURAR_PATH
cls
call :MOSTRAR_CABECALHO "CONFIGURAR PATH DO SISTEMA"
echo.
echo %YELLOW%⚠️  ATENÇÃO: Esta operação requer privilégios de administrador.%RESET%
echo.
echo %CYAN%Esta opção irá adicionar o diretório do executável ao PATH do sistema,%RESET%
echo %CYAN%permitindo executar 'GameTranslator' diretamente do CMD.%RESET%
echo.
echo %CYAN%Diretório a ser adicionado:%RESET%
echo %WHITE%   %DIST_DIR%%RESET%
echo.

set /p "CONFIRMA=%BOLD%Deseja continuar? (S/N): %RESET%"
if /i not "%CONFIRMA%"=="S" goto MENU_PRINCIPAL

:: Verifica se está executando como administrador
net session >nul 2>&1
if errorlevel 1 (
    echo.
    echo %YELLOW%⚠️  Solicitando privilégios de administrador...%RESET%
    echo.
    
    :: Cria script temporário para executar como admin
    echo @echo off > "%TEMP%\add_path.bat"
    echo setx PATH "%%PATH%%;%DIST_DIR%" /M >> "%TEMP%\add_path.bat"
    echo echo. >> "%TEMP%\add_path.bat"
    echo echo PATH atualizado com sucesso! >> "%TEMP%\add_path.bat"
    echo pause >> "%TEMP%\add_path.bat"
    
    powershell -Command "Start-Process '%TEMP%\add_path.bat' -Verb RunAs"
) else (
    setx PATH "%PATH%;%DIST_DIR%" /M
    echo.
    echo %GREEN%✅ PATH atualizado com sucesso!%RESET%
)

echo.
echo %CYAN%Após reiniciar o terminal, você poderá executar:%RESET%
echo %WHITE%   GameTranslator%RESET%
echo.
pause
goto MENU_PRINCIPAL

:: ============================================================================
:: FINALIZAR INSTALAÇÃO
:: ============================================================================
:FINALIZAR_INSTALACAO
:: Cria atalho na área de trabalho
echo %CYAN%   📌 Criando atalho na área de trabalho...%RESET%

set "DESKTOP=%USERPROFILE%\Desktop"
set "SHORTCUT=%DESKTOP%\Game Translator.lnk"

:: Usa PowerShell para criar atalho
powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%SHORTCUT%'); $Shortcut.TargetPath = '%DIST_DIR%\GameTranslator.exe'; $Shortcut.WorkingDirectory = '%DIST_DIR%'; $Shortcut.Description = 'Game Translator - Sistema de Tradução para Jogos'; $Shortcut.Save()" >nul 2>&1

if exist "%SHORTCUT%" (
    echo %GREEN%   ✅ Atalho criado na área de trabalho!%RESET%
) else (
    echo %YELLOW%   ⚠️  Não foi possível criar atalho automaticamente%RESET%
)

exit /b 0

:: ============================================================================
:: FUNÇÕES AUXILIARES
:: ============================================================================

:MOSTRAR_CABECALHO
echo.
echo %CYAN%╔══════════════════════════════════════════════════════════════════════════════╗%RESET%
echo %CYAN%║%RESET%  %BOLD%%MAGENTA%🎮 GAME TRANSLATOR%RESET% - %~1
echo %CYAN%╚══════════════════════════════════════════════════════════════════════════════╝%RESET%
exit /b 0

:VERIFICAR_PYTHON
python --version >nul 2>&1
if errorlevel 1 (
    echo.
    echo %RED%╔══════════════════════════════════════════════════════════════════════════════╗%RESET%
    echo %RED%║%RESET%  %BOLD%%RED%❌ PYTHON NÃO ENCONTRADO!%RESET%                                                %RED%║%RESET%
    echo %RED%╠══════════════════════════════════════════════════════════════════════════════╣%RESET%
    echo %RED%║%RESET%                                                                              %RED%║%RESET%
    echo %RED%║%RESET%  O Python é necessário para executar este programa.                         %RED%║%RESET%
    echo %RED%║%RESET%                                                                              %RED%║%RESET%
    echo %RED%║%RESET%  %CYAN%Para instalar o Python:%RESET%                                                   %RED%║%RESET%
    echo %RED%║%RESET%  1. Acesse: %YELLOW%https://www.python.org/downloads/%RESET%                             %RED%║%RESET%
    echo %RED%║%RESET%  2. Baixe a versão mais recente (3.8 ou superior)                           %RED%║%RESET%
    echo %RED%║%RESET%  3. Durante a instalação, marque %GREEN%"Add Python to PATH"%RESET%                      %RED%║%RESET%
    echo %RED%║%RESET%  4. Reinicie este instalador                                                %RED%║%RESET%
    echo %RED%║%RESET%                                                                              %RED%║%RESET%
    echo %RED%╚══════════════════════════════════════════════════════════════════════════════╝%RESET%
    echo.
    set /p "ABRIR_SITE=%BOLD%Deseja abrir o site de download do Python? (S/N): %RESET%"
    if /i "!ABRIR_SITE!"=="S" (
        start https://www.python.org/downloads/
    )
    echo.
    pause
    exit /b 1
)

for /f "tokens=2" %%v in ('python --version 2^>nul') do set "PYTHON_VERSION=%%v"
echo %GREEN%   ✅ Python encontrado: %PYTHON_VERSION%%RESET%
exit /b 0

:VERIFICAR_PYTHON_SILENCIOSO
python --version >nul 2>&1
if errorlevel 1 exit /b 1
for /f "tokens=2" %%v in ('python --version 2^>nul') do set "PYTHON_VERSION=%%v"
exit /b 0

:SAIR
cls
echo.
echo %CYAN%╔══════════════════════════════════════════════════════════════════════════════╗%RESET%
echo %CYAN%║%RESET%                                                                              %CYAN%║%RESET%
echo %CYAN%║%RESET%   %GREEN%Obrigado por usar o Game Translator!%RESET%                                      %CYAN%║%RESET%
echo %CYAN%║%RESET%                                                                              %CYAN%║%RESET%
echo %CYAN%║%RESET%   %WHITE%Desenvolvido por Manus AI%RESET%                                                 %CYAN%║%RESET%
echo %CYAN%║%RESET%                                                                              %CYAN%║%RESET%
echo %CYAN%╚══════════════════════════════════════════════════════════════════════════════╝%RESET%
echo.
timeout /t 2 >nul
exit /b 0
