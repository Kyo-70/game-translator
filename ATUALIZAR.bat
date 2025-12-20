@echo off
chcp 65001 >nul 2>&1
title Game Translator - Atualizador v1.0.1

:: Habilita suporte a cores ANSI no Windows 10+ via registro
reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1

:: Define cores customizadas usando códigos ANSI diretos (mais robusto que o for /F)
set "ESC="
set "COLOR_RESET=%ESC%[0m"
set "COLOR_TITULO=%ESC%[95m%ESC%[1m"
set "COLOR_SUCESSO=%ESC%[92m%ESC%[1m"
set "COLOR_ERRO=%ESC%[91m%ESC%[1m"
set "COLOR_AVISO=%ESC%[93m%ESC%[1m"
set "COLOR_INFO=%ESC%[96m%ESC%[1m"
set "COLOR_DESTAQUE=%ESC%[97m%ESC%[1m"
set "COLOR_SECAO=%ESC%[94m%ESC%[1m"

cls
echo.
echo %COLOR_TITULO%========================================================================%COLOR_RESET%
echo %COLOR_TITULO%                                                                        %COLOR_RESET%
echo %COLOR_TITULO%     GAME TRANSLATOR - ATUALIZADOR v1.0.1                              %COLOR_RESET%
echo %COLOR_TITULO%                                                                        %COLOR_RESET%
echo %COLOR_TITULO%     Sistema de Atualizacao Automatica do Repositorio                  %COLOR_RESET%
echo %COLOR_TITULO%                                                                        %COLOR_RESET%
echo %COLOR_TITULO%========================================================================%COLOR_RESET%
echo.

:MENU
echo.
echo %COLOR_INFO%  [1]%COLOR_RESET% %COLOR_DESTAQUE%Atualizar Repositorio Completo%COLOR_RESET% (Recomendado)
echo %COLOR_INFO%  [2]%COLOR_RESET% Verificar Atualizacoes Disponiveis
echo %COLOR_INFO%  [3]%COLOR_RESET% Atualizar Apenas Dependencias Python
echo %COLOR_INFO%  [4]%COLOR_RESET% Recriar Executavel (.exe)
echo %COLOR_INFO%  [0]%COLOR_RESET% Sair
echo.
set /p OPCAO="%COLOR_INFO%Digite sua opcao:%COLOR_RESET% "

if "%OPCAO%"=="1" goto ATUALIZAR_COMPLETO
if "%OPCAO%"=="2" goto VERIFICAR_UPDATES
if "%OPCAO%"=="3" goto ATUALIZAR_DEPS
if "%OPCAO%"=="4" goto CRIAR_EXE
if "%OPCAO%"=="0" goto SAIR

echo.
echo %COLOR_ERRO%[ERRO]%COLOR_RESET% Opcao invalida! Tente novamente.
echo.
pause
cls
goto MENU

:VERIFICAR_GIT
:: Função para verificar se o Git está instalado e se é um repositório
git --version >nul 2>&1
if errorlevel 1 (
    echo %COLOR_ERRO%[ERRO]%COLOR_RESET% Git nao encontrado!
    echo.
    echo %COLOR_INFO%Instale o Git em:%COLOR_RESET% https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)

if not exist ".git" (
    echo %COLOR_ERRO%[ERRO]%COLOR_RESET% Este diretorio nao e um repositorio Git!
    echo.
    echo %COLOR_INFO%Para obter atualizacoes, baixe manualmente de:%COLOR_RESET%
    echo %COLOR_DESTAQUE%https://github.com/Kyo-70/Tradutor_XML-JSON%COLOR_RESET%
    echo.
    pause
    exit /b 1
)
exit /b 0

:VERIFICAR_UPDATES
cls
echo.
echo %COLOR_SECAO%========================================================================%COLOR_RESET%
echo %COLOR_SECAO%  VERIFICANDO ATUALIZACOES DISPONIVEIS%COLOR_RESET%
echo %COLOR_SECAO%========================================================================%COLOR_RESET%
echo.

call :VERIFICAR_GIT
if errorlevel 1 goto MENU

echo %COLOR_INFO%Buscando atualizacoes do servidor remoto...%COLOR_RESET%
echo.

git fetch origin
if errorlevel 1 (
    echo.
    echo %COLOR_ERRO%[ERRO]%COLOR_RESET% Falha ao buscar atualizacoes do servidor remoto
    echo %COLOR_AVISO%Verifique sua conexao com a internet%COLOR_RESET%
    echo.
    pause
    cls
    goto MENU
)

echo %COLOR_SUCESSO%[OK]%COLOR_RESET% Informacoes atualizadas do servidor remoto
echo.

:: Verifica se ha commits novos
git status -uno | find "Your branch is behind" >nul
if errorlevel 0 (
    echo %COLOR_AVISO%========================================================================%COLOR_RESET%
    echo %COLOR_AVISO%  [!] ATUALIZACAO DISPONIVEL!%COLOR_RESET%
    echo %COLOR_AVISO%========================================================================%COLOR_RESET%
    echo.
    echo %COLOR_INFO%Use a opcao [1] para atualizar o repositorio completo.%COLOR_RESET%
) else (
    echo %COLOR_SUCESSO%========================================================================%COLOR_RESET%
    echo %COLOR_SUCESSO%  [OK] REPOSITORIO ATUALIZADO!%COLOR_RESET%
    echo %COLOR_SUCESSO%========================================================================%COLOR_RESET%
    echo.
    echo %COLOR_INFO%Voce ja possui a versao mais recente do Game Translator.%COLOR_RESET%
)

echo.
pause
cls
goto MENU

:ATUALIZAR_COMPLETO
cls
echo.
echo %COLOR_SECAO%========================================================================%COLOR_RESET%
echo %COLOR_SECAO%  ATUALIZACAO COMPLETA DO REPOSITORIO%COLOR_RESET%
echo %COLOR_SECAO%========================================================================%COLOR_RESET%
echo.

call :VERIFICAR_GIT
if errorlevel 1 goto MENU

:: Passo 1: Verifica alteracoes locais e faz stash se necessario
echo %COLOR_INFO%[1/3]%COLOR_RESET% Verificando alteracoes locais...
echo.

git diff --quiet
if errorlevel 1 (
    echo %COLOR_AVISO%[AVISO]%COLOR_RESET% Existem alteracoes locais nao commitadas
    echo.
    set /p CONTINUAR="%COLOR_AVISO%Deseja continuar? Alteracoes locais serao salvas temporariamente (S/N):%COLOR_RESET% "
    if /i not "%CONTINUAR%"=="S" (
        echo.
        echo %COLOR_INFO%Atualizacao cancelada.%COLOR_RESET%
        echo.
        pause
        cls
        goto MENU
    )
    echo.
    echo %COLOR_INFO%Salvando alteracoes locais temporariamente...%COLOR_RESET%
    git stash push -m "Backup automatico antes da atualizacao"
    echo.
)

:: Passo 2: Faz o pull
echo %COLOR_INFO%[2/3]%COLOR_RESET% Aplicando atualizacoes...
echo.

git pull
if errorlevel 1 (
    echo.
    echo %COLOR_ERRO%[ERRO]%COLOR_RESET% Falha ao aplicar atualizacoes
    echo %COLOR_AVISO%Pode haver conflitos que precisam ser resolvidos manualmente%COLOR_RESET%
    echo.
    pause
    cls
    goto MENU
)

echo %COLOR_SUCESSO%[OK]%COLOR_RESET% Repositorio atualizado com sucesso!
echo.

:: Passo 3: Aplica stash se houver
git stash pop --quiet 2>nul
if not errorlevel 1 (
    echo %COLOR_INFO%[3/3]%COLOR_RESET% Aplicando alteracoes locais salvas...
    echo %COLOR_AVISO%[AVISO]%COLOR_RESET% Conflitos podem ter ocorrido. Verifique o status do Git.
    echo.
)

echo %COLOR_SUCESSO%========================================================================%COLOR_RESET%
echo %COLOR_SUCESSO%  [OK] ATUALIZACAO CONCLUIDA!%COLOR_RESET%
echo %COLOR_SUCESSO%========================================================================%COLOR_RESET%
echo.
pause
cls
goto MENU

:ATUALIZAR_DEPS
cls
echo.
echo %COLOR_SECAO%========================================================================%COLOR_RESET%
echo %COLOR_SECAO%  ATUALIZACAO DE DEPENDENCIAS PYTHON%COLOR_RESET%
echo %COLOR_SECAO%========================================================================%COLOR_RESET%
echo.

echo %COLOR_INFO%Verificando Python...%COLOR_RESET%
py --version >nul 2>&1
if errorlevel 1 (
    echo %COLOR_ERRO%[ERRO] Python nao encontrado!%COLOR_RESET%
    echo %COLOR_INFO%Instale Python de: https://www.python.org/downloads/%COLOR_RESET%
    pause
    goto MENU
)

echo.
echo %COLOR_INFO%Atualizando dependencias...%COLOR_RESET%
echo.

echo %COLOR_INFO%[1/2] Atualizando pip...%COLOR_RESET%
py -m pip install --upgrade pip

echo.
echo %COLOR_INFO%[2/2] Instalando/Atualizando dependencias do requirements.txt...%COLOR_RESET%
py -m pip install -r requirements.txt --upgrade

echo.
echo %COLOR_SUCESSO%========================================================================%COLOR_RESET%
echo %COLOR_SUCESSO%  [OK] Dependencias atualizadas!%COLOR_RESET%
echo %COLOR_SUCESSO%========================================================================%COLOR_RESET%
echo.
pause
cls
goto MENU

:CRIAR_EXE
cls
echo.
echo %COLOR_SECAO%========================================================================%COLOR_RESET%
echo %COLOR_SECAO%  RECRIACAO DO EXECUTAVEL%COLOR_RESET%
echo %COLOR_SECAO%========================================================================%COLOR_RESET%
echo.

echo %COLOR_INFO%Verificando Python...%COLOR_RESET%
py --version >nul 2>&1
if errorlevel 1 (
    echo %COLOR_ERRO%[ERRO] Python nao encontrado!%COLOR_RESET%
    pause
    goto MENU
)

echo.
echo %COLOR_INFO%Criando executavel (isso pode levar alguns minutos)...%COLOR_RESET%
echo.

:: Limpa builds anteriores
if exist "build" rmdir /s /q "build" >nul 2>&1
if exist "dist" rmdir /s /q "dist" >nul 2>&1

:: Comando PyInstaller completo em uma única linha para evitar problemas com ^
py -m PyInstaller --name="GameTranslator" --onefile --windowed --noconfirm --clean --paths="%~dp0src" --hidden-import=PySide6.QtCore --hidden-import=PySide6.QtGui --hidden-import=PySide6.QtWidgets --hidden-import=sqlite3 --hidden-import=psutil --add-data "src;src" "%~dp0src\main.py"
if errorlevel 1 (
    echo.
    echo %COLOR_ERRO%[ERRO] Falha ao criar executavel!%COLOR_RESET%
    echo.
    pause
    cls
    goto MENU
)

echo.

if exist "%~dp0dist\GameTranslator.exe" (
    echo %COLOR_SUCESSO%[OK] Executavel criado com sucesso!%COLOR_RESET%
    echo %COLOR_INFO%Local: %~dp0dist\GameTranslator.exe%COLOR_RESET%
) else (
    echo %COLOR_ERRO%[ERRO] Falha ao criar executavel!%COLOR_RESET%
)

echo.
pause
cls
goto MENU

:SAIR
echo.
echo %COLOR_DESTAQUE%Obrigado por usar o Game Translator!%COLOR_RESET%
echo.
timeout /t 2 >nul
exit /b 0
