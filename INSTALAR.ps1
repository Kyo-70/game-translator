# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                    GAME TRANSLATOR - INSTALADOR v2.0.0                       ║
# ║                     Visual Moderno com Animações                             ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
# Requer PowerShell 5.1 ou superior

$Host.UI.RawUI.WindowTitle = "🎮 Game Translator - Instalador v2.0.0"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# ═══════════════════════════════════════════════════════════════════════════════
# CONFIGURAÇÃO DE CORES MODERNAS
# ═══════════════════════════════════════════════════════════════════════════════
$script:Colors = @{
    Primary    = "Cyan"
    Secondary  = "Magenta"
    Success    = "Green"
    Error      = "Red"
    Warning    = "Yellow"
    Info       = "White"
    Accent     = "Blue"
    Highlight  = "DarkCyan"
    Dim        = "DarkGray"
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# ═══════════════════════════════════════════════════════════════════════════════
# FUNÇÕES DE ANIMAÇÃO E VISUAL
# ═══════════════════════════════════════════════════════════════════════════════

function Write-AnimatedText {
    param(
        [string]$Text,
        [string]$Color = "White",
        [int]$Delay = 5
    )
    foreach ($char in $Text.ToCharArray()) {
        Write-Host $char -NoNewline -ForegroundColor $Color
        Start-Sleep -Milliseconds $Delay
    }
    Write-Host ""
}

function Write-GradientLine {
    param([string]$Char = "═", [int]$Length = 76)
    $colors = @("DarkBlue", "Blue", "Cyan", "DarkCyan", "Cyan", "Blue", "DarkBlue")
    $segmentLength = [math]::Ceiling($Length / $colors.Count)
    
    for ($i = 0; $i -lt $colors.Count; $i++) {
        $remaining = $Length - ($i * $segmentLength)
        $currentLength = [math]::Min($segmentLength, $remaining)
        if ($currentLength -gt 0) {
            Write-Host ($Char * $currentLength) -NoNewline -ForegroundColor $colors[$i]
        }
    }
    Write-Host ""
}

function Write-CenteredText {
    param(
        [string]$Text,
        [string]$Color = "White",
        [int]$Width = 76
    )
    $padding = [math]::Max(0, ($Width - $Text.Length) / 2)
    Write-Host (" " * $padding) -NoNewline
    Write-Host $Text -ForegroundColor $Color
}

function Show-Spinner {
    param(
        [string]$Message,
        [int]$Duration = 3
    )
    $spinChars = @("⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏")
    $endTime = (Get-Date).AddSeconds($Duration)
    $i = 0
    
    while ((Get-Date) -lt $endTime) {
        Write-Host "`r  $($spinChars[$i % $spinChars.Count]) $Message" -NoNewline -ForegroundColor $Colors.Primary
        Start-Sleep -Milliseconds 80
        $i++
    }
    Write-Host "`r  ✓ $Message" -ForegroundColor $Colors.Success
}

function Show-ProgressAnimation {
    param(
        [string]$Task,
        [int]$Steps = 20
    )
    Write-Host ""
    Write-Host "  $Task" -ForegroundColor $Colors.Info
    Write-Host "  [" -NoNewline -ForegroundColor $Colors.Dim
    
    for ($i = 0; $i -lt $Steps; $i++) {
        Write-Host "█" -NoNewline -ForegroundColor $Colors.Primary
        Start-Sleep -Milliseconds 50
    }
    
    Write-Host "] " -NoNewline -ForegroundColor $Colors.Dim
    Write-Host "100%" -ForegroundColor $Colors.Success
}

function Show-Logo {
    Clear-Host
    Write-Host ""
    Write-GradientLine "═" 76
    Write-Host ""
    
    $logo = @(
        "   ██████╗  █████╗ ███╗   ███╗███████╗",
        "  ██╔════╝ ██╔══██╗████╗ ████║██╔════╝",
        "  ██║  ███╗███████║██╔████╔██║█████╗  ",
        "  ██║   ██║██╔══██║██║╚██╔╝██║██╔══╝  ",
        "  ╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗",
        "   ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝",
        "",
        "  ████████╗██████╗  █████╗ ███╗   ██╗███████╗██╗      █████╗ ████████╗ ██████╗ ██████╗ ",
        "  ╚══██╔══╝██╔══██╗██╔══██╗████╗  ██║██╔════╝██║     ██╔══██╗╚══██╔══╝██╔═══██╗██╔══██╗",
        "     ██║   ██████╔╝███████║██╔██╗ ██║███████╗██║     ███████║   ██║   ██║   ██║██████╔╝",
        "     ██║   ██╔══██╗██╔══██║██║╚██╗██║╚════██║██║     ██╔══██║   ██║   ██║   ██║██╔══██╗",
        "     ██║   ██║  ██║██║  ██║██║ ╚████║███████║███████╗██║  ██║   ██║   ╚██████╔╝██║  ██║",
        "     ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝"
    )
    
    $logoColors = @("Cyan", "Cyan", "DarkCyan", "Blue", "DarkBlue", "DarkBlue", 
                    "Magenta", "Magenta", "Magenta", "DarkMagenta", "DarkMagenta", "DarkMagenta", "DarkMagenta")
    
    for ($i = 0; $i -lt $logo.Count; $i++) {
        Write-CenteredText $logo[$i] $logoColors[$i] 90
        Start-Sleep -Milliseconds 30
    }
    
    Write-Host ""
    Write-CenteredText "═══════════════════════════════════════════════════════════" "DarkGray" 90
    Write-CenteredText "Sistema Profissional de Tradução para Jogos e Mods" "White" 90
    Write-CenteredText "Versão 2.0.0 | PowerShell Edition" "DarkGray" 90
    Write-CenteredText "═══════════════════════════════════════════════════════════" "DarkGray" 90
    Write-Host ""
}

function Show-Menu {
    Show-Logo
    
    Write-Host ""
    Write-Host "  ┌─────────────────────────────────────────────────────────────────────┐" -ForegroundColor $Colors.Accent
    Write-Host "  │                         " -NoNewline -ForegroundColor $Colors.Accent
    Write-Host "MENU PRINCIPAL" -NoNewline -ForegroundColor $Colors.Primary
    Write-Host "                            │" -ForegroundColor $Colors.Accent
    Write-Host "  ├─────────────────────────────────────────────────────────────────────┤" -ForegroundColor $Colors.Accent
    Write-Host "  │                                                                     │" -ForegroundColor $Colors.Accent
    
    # Opções do menu com ícones
    $menuItems = @(
        @{ Key = "1"; Icon = "🚀"; Text = "Instalação Completa"; Extra = "(Recomendado)" },
        @{ Key = "2"; Icon = "🔍"; Text = "Verificar Requisitos"; Extra = "" },
        @{ Key = "3"; Icon = "📦"; Text = "Instalar Dependências"; Extra = "" },
        @{ Key = "4"; Icon = "⚙️"; Text = "Criar Executável (.exe)"; Extra = "" },
        @{ Key = "5"; Icon = "▶️"; Text = "Executar Programa"; Extra = "(Dev Mode)" },
        @{ Key = "6"; Icon = "🧹"; Text = "Limpar Arquivos Temporários"; Extra = "" },
        @{ Key = "7"; Icon = "🖥️"; Text = "Limpar Tela do Terminal"; Extra = "" },
        @{ Key = "0"; Icon = "🚪"; Text = "Sair"; Extra = "" }
    )
    
    foreach ($item in $menuItems) {
        Write-Host "  │    [" -NoNewline -ForegroundColor $Colors.Accent
        Write-Host $item.Key -NoNewline -ForegroundColor $Colors.Primary
        Write-Host "] " -NoNewline -ForegroundColor $Colors.Accent
        Write-Host "$($item.Icon) " -NoNewline
        Write-Host $item.Text -NoNewline -ForegroundColor $Colors.Info
        if ($item.Extra) {
            Write-Host " $($item.Extra)" -NoNewline -ForegroundColor $Colors.Dim
        }
        $padding = 53 - $item.Text.Length - $item.Extra.Length
        Write-Host (" " * [math]::Max(1, $padding)) -NoNewline
        Write-Host "│" -ForegroundColor $Colors.Accent
    }
    
    Write-Host "  │                                                                     │" -ForegroundColor $Colors.Accent
    Write-Host "  └─────────────────────────────────────────────────────────────────────┘" -ForegroundColor $Colors.Accent
    Write-Host ""
}

function Show-SectionHeader {
    param([string]$Title, [string]$Icon = "⚡")
    
    Clear-Host
    Write-Host ""
    Write-GradientLine "═" 76
    Write-Host ""
    Write-Host "  $Icon " -NoNewline -ForegroundColor $Colors.Primary
    Write-Host $Title.ToUpper() -ForegroundColor $Colors.Info
    Write-Host ""
    Write-GradientLine "─" 76
    Write-Host ""
}

function Show-SuccessBox {
    param([string]$Message, [string]$SubMessage = "")
    
    Write-Host ""
    Write-Host "  ╔═══════════════════════════════════════════════════════════════════╗" -ForegroundColor $Colors.Success
    Write-Host "  ║                                                                   ║" -ForegroundColor $Colors.Success
    Write-Host "  ║  ✅ " -NoNewline -ForegroundColor $Colors.Success
    Write-Host $Message.PadRight(60) -NoNewline -ForegroundColor "White"
    Write-Host "║" -ForegroundColor $Colors.Success
    if ($SubMessage) {
        Write-Host "  ║     " -NoNewline -ForegroundColor $Colors.Success
        Write-Host $SubMessage.PadRight(60) -NoNewline -ForegroundColor $Colors.Dim
        Write-Host "║" -ForegroundColor $Colors.Success
    }
    Write-Host "  ║                                                                   ║" -ForegroundColor $Colors.Success
    Write-Host "  ╚═══════════════════════════════════════════════════════════════════╝" -ForegroundColor $Colors.Success
    Write-Host ""
}

function Show-ErrorBox {
    param([string]$Message, [string]$SubMessage = "")
    
    Write-Host ""
    Write-Host "  ╔═══════════════════════════════════════════════════════════════════╗" -ForegroundColor $Colors.Error
    Write-Host "  ║                                                                   ║" -ForegroundColor $Colors.Error
    Write-Host "  ║  ❌ " -NoNewline -ForegroundColor $Colors.Error
    Write-Host $Message.PadRight(60) -NoNewline -ForegroundColor "White"
    Write-Host "║" -ForegroundColor $Colors.Error
    if ($SubMessage) {
        Write-Host "  ║     " -NoNewline -ForegroundColor $Colors.Error
        Write-Host $SubMessage.PadRight(60) -NoNewline -ForegroundColor $Colors.Dim
        Write-Host "║" -ForegroundColor $Colors.Error
    }
    Write-Host "  ║                                                                   ║" -ForegroundColor $Colors.Error
    Write-Host "  ╚═══════════════════════════════════════════════════════════════════╝" -ForegroundColor $Colors.Error
    Write-Host ""
}

function Show-InfoBox {
    param([string]$Message)
    
    Write-Host ""
    Write-Host "  ┌───────────────────────────────────────────────────────────────────┐" -ForegroundColor $Colors.Primary
    Write-Host "  │  💡 " -NoNewline -ForegroundColor $Colors.Primary
    Write-Host $Message.PadRight(60) -NoNewline -ForegroundColor $Colors.Info
    Write-Host "│" -ForegroundColor $Colors.Primary
    Write-Host "  └───────────────────────────────────────────────────────────────────┘" -ForegroundColor $Colors.Primary
    Write-Host ""
}

function Write-Step {
    param(
        [int]$Current,
        [int]$Total,
        [string]$Message
    )
    Write-Host ""
    Write-Host "  [$Current/$Total] " -NoNewline -ForegroundColor $Colors.Primary
    Write-Host $Message -ForegroundColor $Colors.Info
}

function Write-SubStep {
    param([string]$Message, [string]$Status = "...")
    Write-Host "       → " -NoNewline -ForegroundColor $Colors.Dim
    Write-Host $Message -NoNewline -ForegroundColor $Colors.Info
    Write-Host " $Status" -ForegroundColor $Colors.Dim
}

function Write-SubStepSuccess {
    param([string]$Message)
    Write-Host "       ✓ " -NoNewline -ForegroundColor $Colors.Success
    Write-Host $Message -ForegroundColor $Colors.Info
}

function Write-SubStepError {
    param([string]$Message)
    Write-Host "       ✗ " -NoNewline -ForegroundColor $Colors.Error
    Write-Host $Message -ForegroundColor $Colors.Info
}

# ═══════════════════════════════════════════════════════════════════════════════
# FUNÇÕES UTILITÁRIAS
# ═══════════════════════════════════════════════════════════════════════════════

function Test-Python {
    try {
        $result = py --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            return $true
        }
    } catch {}
    return $false
}

function Clear-TempFiles {
    param([bool]$Silent = $false)
    
    $totalRemoved = 0
    $foldersToRemove = @("build", "dist", "__pycache__", "src\__pycache__", "src\gui\__pycache__")
    
    foreach ($folder in $foldersToRemove) {
        $folderPath = Join-Path $ScriptDir $folder
        if (Test-Path $folderPath) {
            try {
                Remove-Item -Path $folderPath -Recurse -Force -ErrorAction Stop
                if (-not $Silent) { Write-SubStepSuccess "Removido: $folder" }
                $totalRemoved++
            } catch {
                if (-not $Silent) { Write-SubStepError "Falha: $folder" }
            }
        }
    }
    
    # Remove arquivos .spec
    Get-ChildItem -Path $ScriptDir -Filter "*.spec" -ErrorAction SilentlyContinue | ForEach-Object {
        try {
            Remove-Item -Path $_.FullName -Force
            if (-not $Silent) { Write-SubStepSuccess "Removido: $($_.Name)" }
            $totalRemoved++
        } catch {}
    }
    
    # Remove __pycache__ recursivamente
    Get-ChildItem -Path $ScriptDir -Directory -Recurse -Filter "__pycache__" -ErrorAction SilentlyContinue | ForEach-Object {
        try {
            Remove-Item -Path $_.FullName -Recurse -Force
            $totalRemoved++
        } catch {}
    }
    
    # Remove .pyc e .pyo
    Get-ChildItem -Path $ScriptDir -Include "*.pyc", "*.pyo" -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
        try {
            Remove-Item -Path $_.FullName -Force
            $totalRemoved++
        } catch {}
    }
    
    return $totalRemoved
}

# ═══════════════════════════════════════════════════════════════════════════════
# FUNÇÕES PRINCIPAIS DO MENU
# ═══════════════════════════════════════════════════════════════════════════════

function Install-Complete {
    Show-SectionHeader "Instalação Completa" "🚀"
    
    Write-Step 1 5 "Verificando Python..."
    Start-Sleep -Milliseconds 500
    
    if (-not (Test-Python)) {
        Show-ErrorBox "Python não encontrado!" "Instale em: https://www.python.org/downloads/"
        Show-InfoBox "Durante a instalação, marque 'Add Python to PATH'"
        Read-Host "  Pressione Enter para continuar"
        return
    }
    
    $pythonVersion = py --version 2>&1
    Write-SubStepSuccess "$pythonVersion encontrado"
    
    Write-Step 2 5 "Limpando arquivos temporários anteriores..."
    $removed = Clear-TempFiles -Silent $true
    Write-SubStepSuccess "Removidos $removed itens temporários"
    
    Write-Step 3 5 "Instalando dependências..."
    Write-Host ""
    
    Write-SubStep "Atualizando pip"
    py -m pip install --upgrade pip --quiet 2>$null
    Write-SubStepSuccess "pip atualizado"
    
    $deps = @("PySide6", "requests", "psutil", "colorama", "pyinstaller")
    foreach ($dep in $deps) {
        Write-SubStep "Instalando $dep"
        py -m pip install $dep --quiet 2>$null
        Write-SubStepSuccess "$dep instalado"
    }
    
    Write-Step 4 5 "Criando executável..."
    Show-InfoBox "Isso pode levar alguns minutos, aguarde..."
    
    Set-Location $ScriptDir
    $srcPath = Join-Path $ScriptDir "src"
    $mainPath = Join-Path $srcPath "main.py"
    
    py -m PyInstaller --name="GameTranslator" --onefile --windowed --noconfirm --clean `
        --paths="$srcPath" `
        --hidden-import=PySide6.QtCore `
        --hidden-import=PySide6.QtGui `
        --hidden-import=PySide6.QtWidgets `
        --hidden-import=sqlite3 `
        --hidden-import=psutil `
        --add-data "src;src" `
        "$mainPath" 2>$null
    
    Write-Step 5 5 "Verificando resultado e limpando temporários..."
    
    $exePath = Join-Path $ScriptDir "dist\GameTranslator.exe"
    
    if (Test-Path $exePath) {
        # Limpa temporários mantendo dist/
        if (Test-Path "build") { Remove-Item -Recurse -Force "build" }
        Get-ChildItem -Path $ScriptDir -Filter "*.spec" -ErrorAction SilentlyContinue | Remove-Item -Force
        Get-ChildItem -Path $ScriptDir -Directory -Recurse -Filter "__pycache__" -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force
        
        Show-SuccessBox "INSTALAÇÃO CONCLUÍDA COM SUCESSO!" $exePath
        
        Write-Host "  Deseja abrir o programa agora? " -NoNewline -ForegroundColor $Colors.Info
        Write-Host "(S/N) " -NoNewline -ForegroundColor $Colors.Primary
        $response = Read-Host
        if ($response -match "^[SsYy]$") {
            Start-Process $exePath
        }
    } else {
        Show-ErrorBox "Falha ao criar executável!" "Verifique os erros acima."
    }
    
    Write-Host ""
    Read-Host "  Pressione Enter para continuar"
}

function Test-Requirements {
    Show-SectionHeader "Verificação de Requisitos" "🔍"
    
    if (-not (Test-Python)) {
        Show-ErrorBox "Python não encontrado!" "Instale em: https://www.python.org/downloads/"
        Read-Host "  Pressione Enter para continuar"
        return
    }
    
    Set-Location (Join-Path $ScriptDir "src")
    py verificar_sistema.py
    Set-Location $ScriptDir
    
    Write-Host ""
    Read-Host "  Pressione Enter para continuar"
}

function Install-Dependencies {
    Show-SectionHeader "Instalação de Dependências" "📦"
    
    if (-not (Test-Python)) {
        Show-ErrorBox "Python não encontrado!"
        Read-Host "  Pressione Enter para continuar"
        return
    }
    
    $steps = @(
        @{ Name = "pip"; Cmd = "py -m pip install --upgrade pip" },
        @{ Name = "PySide6"; Cmd = "py -m pip install PySide6" },
        @{ Name = "requests"; Cmd = "py -m pip install requests" },
        @{ Name = "psutil e colorama"; Cmd = "py -m pip install psutil colorama" },
        @{ Name = "PyInstaller"; Cmd = "py -m pip install pyinstaller" }
    )
    
    for ($i = 0; $i -lt $steps.Count; $i++) {
        Write-Step ($i + 1) $steps.Count "Instalando $($steps[$i].Name)..."
        Invoke-Expression $steps[$i].Cmd 2>$null
        Write-SubStepSuccess "$($steps[$i].Name) instalado com sucesso"
    }
    
    Show-SuccessBox "Todas as dependências foram instaladas!"
    Read-Host "  Pressione Enter para continuar"
}

function Build-Executable {
    Show-SectionHeader "Criação do Executável" "⚙️"
    
    if (-not (Test-Python)) {
        Show-ErrorBox "Python não encontrado!"
        Read-Host "  Pressione Enter para continuar"
        return
    }
    
    Write-Step 1 3 "Limpando arquivos temporários anteriores..."
    Clear-TempFiles -Silent $true
    Write-SubStepSuccess "Arquivos temporários removidos"
    
    Write-Step 2 3 "Criando executável..."
    Show-InfoBox "Isso pode levar alguns minutos..."
    
    Set-Location $ScriptDir
    $srcPath = Join-Path $ScriptDir "src"
    $mainPath = Join-Path $srcPath "main.py"
    
    py -m PyInstaller --name="GameTranslator" --onefile --windowed --noconfirm --clean `
        --paths="$srcPath" `
        --hidden-import=PySide6.QtCore `
        --hidden-import=PySide6.QtGui `
        --hidden-import=PySide6.QtWidgets `
        --hidden-import=sqlite3 `
        --hidden-import=psutil `
        --add-data "src;src" `
        "$mainPath" 2>$null
    
    Write-Step 3 3 "Finalizando..."
    
    $exePath = Join-Path $ScriptDir "dist\GameTranslator.exe"
    
    if (Test-Path $exePath) {
        if (Test-Path "build") { Remove-Item -Recurse -Force "build" }
        Get-ChildItem -Path $ScriptDir -Filter "*.spec" -ErrorAction SilentlyContinue | Remove-Item -Force
        Get-ChildItem -Path $ScriptDir -Directory -Recurse -Filter "__pycache__" -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force
        
        Show-SuccessBox "Executável criado com sucesso!" $exePath
        
        Write-Host "  Abrir pasta do executável? " -NoNewline -ForegroundColor $Colors.Info
        Write-Host "(S/N) " -NoNewline -ForegroundColor $Colors.Primary
        $response = Read-Host
        if ($response -match "^[SsYy]$") {
            explorer (Join-Path $ScriptDir "dist")
        }
    } else {
        Show-ErrorBox "Falha ao criar executável!"
    }
    
    Read-Host "  Pressione Enter para continuar"
}

function Start-Program {
    Show-SectionHeader "Executar Programa" "▶️"
    
    if (-not (Test-Python)) {
        Show-ErrorBox "Python não encontrado!"
        Read-Host "  Pressione Enter para continuar"
        return
    }
    
    Write-Host "  🎮 Iniciando Game Translator..." -ForegroundColor $Colors.Primary
    Write-Host ""
    
    Set-Location (Join-Path $ScriptDir "src")
    py main.py
    
    Write-Host ""
    Read-Host "  Pressione Enter para continuar"
}

function Show-CleanMenu {
    Show-SectionHeader "Limpeza de Arquivos Temporários" "🧹"
    
    Write-Host "  Esta função remove os seguintes arquivos/pastas:" -ForegroundColor $Colors.Info
    Write-Host ""
    Write-Host "    📁 build/          " -NoNewline -ForegroundColor $Colors.Warning
    Write-Host "(pasta de compilação do PyInstaller)" -ForegroundColor $Colors.Dim
    Write-Host "    📁 dist/           " -NoNewline -ForegroundColor $Colors.Warning
    Write-Host "(pasta do executável gerado)" -ForegroundColor $Colors.Dim
    Write-Host "    📁 __pycache__/    " -NoNewline -ForegroundColor $Colors.Warning
    Write-Host "(cache do Python)" -ForegroundColor $Colors.Dim
    Write-Host "    📄 *.spec          " -NoNewline -ForegroundColor $Colors.Warning
    Write-Host "(arquivos de especificação)" -ForegroundColor $Colors.Dim
    Write-Host "    📄 *.pyc / *.pyo   " -NoNewline -ForegroundColor $Colors.Warning
    Write-Host "(arquivos compilados)" -ForegroundColor $Colors.Dim
    Write-Host ""
    
    Write-Host "  Deseja continuar? " -NoNewline -ForegroundColor $Colors.Info
    Write-Host "(S/N) " -NoNewline -ForegroundColor $Colors.Primary
    $response = Read-Host
    
    if ($response -match "^[SsYy]$") {
        Write-Host ""
        $removed = Clear-TempFiles -Silent $false
        Show-SuccessBox "Limpeza concluída!" "Total de $removed itens removidos"
    } else {
        Show-InfoBox "Limpeza cancelada pelo usuário."
    }
    
    Read-Host "  Pressione Enter para continuar"
}

function Show-ExitAnimation {
    Clear-Host
    Write-Host ""
    Write-Host ""
    Write-CenteredText "╔═══════════════════════════════════════════════════════════╗" "Cyan" 76
    Write-CenteredText "║                                                           ║" "Cyan" 76
    Write-CenteredText "║      Obrigado por usar o Game Translator! 🎮             ║" "Cyan" 76
    Write-CenteredText "║                                                           ║" "Cyan" 76
    Write-CenteredText "║              Até a próxima! 👋                            ║" "Cyan" 76
    Write-CenteredText "║                                                           ║" "Cyan" 76
    Write-CenteredText "╚═══════════════════════════════════════════════════════════╝" "Cyan" 76
    Write-Host ""
    
    # Animação de saída
    $dots = @(".", "..", "...", "....", ".....")
    foreach ($dot in $dots) {
        Write-Host "`r                    Encerrando$dot" -NoNewline -ForegroundColor $Colors.Dim
        Start-Sleep -Milliseconds 300
    }
    Write-Host ""
}

# ═══════════════════════════════════════════════════════════════════════════════
# LOOP PRINCIPAL
# ═══════════════════════════════════════════════════════════════════════════════

do {
    Show-Menu
    Write-Host "  Digite sua opção: " -NoNewline -ForegroundColor $Colors.Info
    $option = Read-Host
    
    switch ($option) {
        "1" { Install-Complete }
        "2" { Test-Requirements }
        "3" { Install-Dependencies }
        "4" { Build-Executable }
        "5" { Start-Program }
        "6" { Show-CleanMenu }
        "7" { Clear-Host }
        "0" { 
            Show-ExitAnimation
            exit 0
        }
        default {
            Show-ErrorBox "Opção inválida!" "Por favor, escolha uma opção de 0 a 7."
            Start-Sleep -Seconds 2
        }
    }
} while ($true)
