@echo off
chcp 65001 >nul 2>&1
title Game Translator - Build Executável

:: Habilita suporte a cores ANSI no Windows 10+ via registro
reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1

:: Define cores customizadas usando ANSI escape codes
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%b"

:: Cores personalizadas
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
echo %COLOR_TITULO%     GAME TRANSLATOR - BUILD EXECUTAVEL                                %COLOR_RESET%
echo %COLOR_TITULO%                                                                        %COLOR_RESET%
echo %COLOR_TITULO%     Criacao de executavel standalone (.exe)                           %COLOR_RESET%
echo %COLOR_TITULO%                                                                        %COLOR_RESET%
echo %COLOR_TITULO%========================================================================%COLOR_RESET%
echo.

:: Verifica se Python está instalado
echo %COLOR_INFO%[1/5] Verificando Python...%COLOR_RESET%
echo.

py --version >nul 2>&1
if errorlevel 1 (
    echo %COLOR_ERRO%[ERRO] Python nao encontrado!%COLOR_RESET%
    echo.
    echo %COLOR_INFO%Instale Python de: https://www.python.org/downloads/%COLOR_RESET%
    echo %COLOR_INFO%Durante a instalacao, marque "Add Python to PATH"%COLOR_RESET%
    echo.
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('py --version') do echo %COLOR_SUCESSO%[OK] %%i encontrado%COLOR_RESET%
echo.

:: Verifica se PyInstaller está instalado
echo %COLOR_INFO%[2/5] Verificando PyInstaller...%COLOR_RESET%
echo.

py -c "import PyInstaller" >nul 2>&1
if errorlevel 1 (
    echo %COLOR_AVISO%PyInstaller nao encontrado. Instalando...%COLOR_RESET%
    echo.
    py -m pip install pyinstaller --quiet
    if errorlevel 1 (
        echo %COLOR_ERRO%[ERRO] Falha ao instalar PyInstaller!%COLOR_RESET%
        echo.
        pause
        exit /b 1
    )
    echo %COLOR_SUCESSO%[OK] PyInstaller instalado!%COLOR_RESET%
) else (
    echo %COLOR_SUCESSO%[OK] PyInstaller ja instalado%COLOR_RESET%
)
echo.

:: Limpa diretórios antigos
echo %COLOR_INFO%[3/5] Limpando builds anteriores...%COLOR_RESET%
echo.

cd /d "%~dp0"

if exist "build" (
    echo %COLOR_INFO%   Removendo diretorio build...%COLOR_RESET%
    rmdir /s /q "build" >nul 2>&1
)

if exist "dist" (
    echo %COLOR_INFO%   Removendo diretorio dist...%COLOR_RESET%
    rmdir /s /q "dist" >nul 2>&1
)

if exist "GameTranslator.spec" (
    echo %COLOR_INFO%   Removendo arquivo .spec antigo...%COLOR_RESET%
    del /q "GameTranslator.spec" >nul 2>&1
)

echo %COLOR_SUCESSO%[OK] Limpeza concluida%COLOR_RESET%
echo.

:: Cria o executável
echo %COLOR_INFO%[4/5] Criando executavel...%COLOR_RESET%
echo.
echo %COLOR_AVISO%   Isso pode levar alguns minutos, aguarde...%COLOR_RESET%
echo.

:: Comando PyInstaller completo (seguindo padrão do projeto)
py -m PyInstaller ^
  --name="GameTranslator" ^
  --onefile ^
  --windowed ^
  --noconfirm ^
  --clean ^
  --paths="%~dp0src" ^
  --hidden-import=PySide6.QtCore ^
  --hidden-import=PySide6.QtGui ^
  --hidden-import=PySide6.QtWidgets ^
  --hidden-import=sqlite3 ^
  --hidden-import=psutil ^
  --add-data "src;src" ^
  "%~dp0src\main.py"

if errorlevel 1 (
    echo.
    echo %COLOR_ERRO%========================================================================%COLOR_RESET%
    echo %COLOR_ERRO%  [ERRO] Falha ao criar executavel!%COLOR_RESET%
    echo %COLOR_ERRO%========================================================================%COLOR_RESET%
    echo.
    echo %COLOR_AVISO%Verifique os erros acima e tente novamente.%COLOR_RESET%
    echo.
    pause
    exit /b 1
)

echo.

:: Verifica resultado
echo %COLOR_INFO%[5/5] Verificando resultado...%COLOR_RESET%
echo.

if exist "%~dp0dist\GameTranslator.exe" (
    echo %COLOR_SUCESSO%========================================================================%COLOR_RESET%
    echo %COLOR_SUCESSO%                                                                        %COLOR_RESET%
    echo %COLOR_SUCESSO%  [OK] EXECUTAVEL CRIADO COM SUCESSO!                                 %COLOR_RESET%
    echo %COLOR_SUCESSO%                                                                        %COLOR_RESET%
    echo %COLOR_SUCESSO%  Local: %~dp0dist\GameTranslator.exe                                 %COLOR_RESET%
    echo %COLOR_SUCESSO%                                                                        %COLOR_RESET%
    echo %COLOR_SUCESSO%========================================================================%COLOR_RESET%
    echo.
    
    :: Mostra tamanho do arquivo
    for %%A in ("%~dp0dist\GameTranslator.exe") do (
        set "TAMANHO=%%~zA"
    )
    
    :: Converte bytes para MB
    set /a TAMANHO_MB=%TAMANHO% / 1048576
    echo %COLOR_INFO%Tamanho do executavel: %TAMANHO_MB% MB%COLOR_RESET%
    echo.
    
    :: Pergunta se deseja abrir a pasta
    set /p ABRIR="%COLOR_INFO%Deseja abrir a pasta dist? (S/N):%COLOR_RESET% "
    if /i "%ABRIR%"=="S" explorer "%~dp0dist"
    if /i "%ABRIR%"=="Y" explorer "%~dp0dist"
    
    echo.
    
    :: Pergunta se deseja executar
    set /p EXECUTAR="%COLOR_INFO%Deseja executar o programa agora? (S/N):%COLOR_RESET% "
    if /i "%EXECUTAR%"=="S" start "" "%~dp0dist\GameTranslator.exe"
    if /i "%EXECUTAR%"=="Y" start "" "%~dp0dist\GameTranslator.exe"
    
) else (
    echo %COLOR_ERRO%========================================================================%COLOR_RESET%
    echo %COLOR_ERRO%  [ERRO] Executavel nao foi criado!%COLOR_RESET%
    echo %COLOR_ERRO%========================================================================%COLOR_RESET%
    echo.
    echo %COLOR_AVISO%Verifique se todas as dependencias estao instaladas.%COLOR_RESET%
    echo %COLOR_INFO%Execute INSTALAR.bat para instalar todas as dependencias.%COLOR_RESET%
    echo.
    pause
    exit /b 1
)

echo.
echo %COLOR_DESTAQUE%Build concluido!%COLOR_RESET%
echo.
pause
