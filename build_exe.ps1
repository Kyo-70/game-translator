# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                    GAME TRANSLATOR - BUILD SCRIPT v2.0.0                     ║
# ║                     Visual Moderno com Animações                             ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
# Requer PowerShell 5.1 ou superior

$Host.UI.RawUI.WindowTitle = "⚙️ Game Translator - Build Script"
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
    Dim        = "DarkGray"
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# ═══════════════════════════════════════════════════════════════════════════════
# FUNÇÕES DE ANIMAÇÃO E VISUAL
# ═══════════════════════════════════════════════════════════════════════════════

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
    param([string]$Text, [string]$Color = "White", [int]$Width = 76)
    $padding = [math]::Max(0, ($Width - $Text.Length) / 2)
    Write-Host (" " * $padding) -NoNewline
    Write-Host $Text -ForegroundColor $Color
}

function Show-Spinner {
    param([string]$Message, [int]$Duration = 2)
    $spinChars = @("⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏")
    $endTime = (Get-Date).AddSeconds($Duration)
    $i = 0
    
    while ((Get-Date) -lt $endTime) {
        Write-Host "`r  $($spinChars[$i % $spinChars.Count]) $Message" -NoNewline -ForegroundColor $Colors.Primary
        Start-Sleep -Milliseconds 80
        $i++
    }
    Write-Host "`r  ✓ $Message                              " -ForegroundColor $Colors.Success
}

function Show-BuildAnimation {
    $frames = @(
        @("  ⚙️  ", "     ", "     "),
        @("     ", "  ⚙️  ", "     "),
        @("     ", "     ", "  ⚙️  "),
        @("     ", "  ⚙️  ", "     "),
        @("  ⚙️  ", "     ", "     ")
    )
    
    for ($j = 0; $j -lt 3; $j++) {
        foreach ($frame in $frames) {
            Write-Host "`r  Compilando " -NoNewline -ForegroundColor $Colors.Info
            Write-Host $frame[0] -NoNewline -ForegroundColor $Colors.Primary
            Write-Host $frame[1] -NoNewline -ForegroundColor $Colors.Secondary
            Write-Host $frame[2] -NoNewline -ForegroundColor $Colors.Accent
            Start-Sleep -Milliseconds 150
        }
    }
    Write-Host "`r  Compilando ⚙️ ⚙️ ⚙️                    " -ForegroundColor $Colors.Success
}

function Show-ProgressBar {
    param([string]$Task, [int]$Percent)
    $filled = [math]::Floor($Percent / 5)
    $empty = 20 - $filled
    
    Write-Host "`r  $Task [" -NoNewline -ForegroundColor $Colors.Info
    Write-Host ("█" * $filled) -NoNewline -ForegroundColor $Colors.Primary
    Write-Host ("░" * $empty) -NoNewline -ForegroundColor $Colors.Dim
    Write-Host "] $Percent%" -NoNewline -ForegroundColor $Colors.Info
}

function Show-Header {
    Clear-Host
    Write-Host ""
    Write-GradientLine "═" 76
    Write-Host ""
    
    $gears = @(
        "       ⚙️     ⚙️     ⚙️",
        "         \\   |   /",
        "          \\  |  /",
        "           \\ | /",
        "            \\|/",
        "         ════╪════",
        "            /|\\",
        "           / | \\",
        "          /  |  \\",
        "         /   |   \\"
    )
    
    $gearColors = @("Cyan", "DarkCyan", "DarkCyan", "Blue", "Blue", "Magenta", "Blue", "DarkCyan", "DarkCyan", "Cyan")
    
    for ($i = 0; $i -lt $gears.Count; $i++) {
        Write-CenteredText $gears[$i] $gearColors[$i] 76
        Start-Sleep -Milliseconds 50
    }
    
    Write-Host ""
    Write-CenteredText "═══════════════════════════════════════════════════════════" "DarkGray" 76
    Write-Host ""
    Write-CenteredText "GAME TRANSLATOR" "Cyan" 76
    Write-CenteredText "Build Script - Criação do Executável" "DarkCyan" 76
    Write-Host ""
    Write-CenteredText "═══════════════════════════════════════════════════════════" "DarkGray" 76
    Write-Host ""
}

function Show-SuccessBox {
    param([string]$Message, [string]$Path = "")
    Write-Host ""
    Write-Host "  ╔═══════════════════════════════════════════════════════════════════╗" -ForegroundColor $Colors.Success
    Write-Host "  ║                                                                   ║" -ForegroundColor $Colors.Success
    Write-Host "  ║  ✅ " -NoNewline -ForegroundColor $Colors.Success
    Write-Host $Message.PadRight(60) -NoNewline -ForegroundColor "White"
    Write-Host "║" -ForegroundColor $Colors.Success
    if ($Path) {
        Write-Host "  ║                                                                   ║" -ForegroundColor $Colors.Success
        Write-Host "  ║  📁 " -NoNewline -ForegroundColor $Colors.Success
        Write-Host $Path.PadRight(60) -NoNewline -ForegroundColor $Colors.Primary
        Write-Host "║" -ForegroundColor $Colors.Success
    }
    Write-Host "  ║                                                                   ║" -ForegroundColor $Colors.Success
    Write-Host "  ╚═══════════════════════════════════════════════════════════════════╝" -ForegroundColor $Colors.Success
    Write-Host ""
}

function Show-ErrorBox {
    param([string]$Message)
    Write-Host ""
    Write-Host "  ╔═══════════════════════════════════════════════════════════════════╗" -ForegroundColor $Colors.Error
    Write-Host "  ║  ❌ " -NoNewline -ForegroundColor $Colors.Error
    Write-Host $Message.PadRight(60) -NoNewline -ForegroundColor "White"
    Write-Host "║" -ForegroundColor $Colors.Error
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
    param([int]$Current, [int]$Total, [string]$Message)
    Write-Host ""
    Write-Host "  [$Current/$Total] " -NoNewline -ForegroundColor $Colors.Primary
    Write-Host $Message -ForegroundColor $Colors.Info
}

function Write-SubStepSuccess {
    param([string]$Message)
    Write-Host "       ✓ " -NoNewline -ForegroundColor $Colors.Success
    Write-Host $Message -ForegroundColor $Colors.Info
}

# ═══════════════════════════════════════════════════════════════════════════════
# LÓGICA PRINCIPAL
# ═══════════════════════════════════════════════════════════════════════════════

Show-Header

Write-Host "  🚀 Iniciando processo de build..." -ForegroundColor $Colors.Info
Write-Host ""

# ETAPA 1: Verificar Python
Write-Step 1 4 "Verificando Python..."
try {
    $pythonVersion = py --version 2>&1
    if ($LASTEXITCODE -ne 0) { throw "Python não encontrado" }
    Write-SubStepSuccess "Python encontrado: $pythonVersion"
} catch {
    Show-ErrorBox "Python não encontrado! Instale primeiro."
    Read-Host "  Pressione Enter para sair"
    exit 1
}

# ETAPA 2: Instalar PyInstaller
Write-Step 2 4 "Instalando/Atualizando PyInstaller..."
Show-Spinner "Verificando PyInstaller" 1
py -m pip install pyinstaller --quiet 2>$null
Write-SubStepSuccess "PyInstaller pronto"

# ETAPA 3: Limpar e preparar
Write-Step 3 4 "Preparando ambiente de build..."
Set-Location $ScriptDir

if (Test-Path "build") { 
    Remove-Item -Recurse -Force "build" 
    Write-SubStepSuccess "Pasta build/ removida"
}
if (Test-Path "dist") { 
    Remove-Item -Recurse -Force "dist" 
    Write-SubStepSuccess "Pasta dist/ removida"
}
Get-ChildItem -Path $ScriptDir -Filter "*.spec" -ErrorAction SilentlyContinue | Remove-Item -Force

# ETAPA 4: Compilar
Write-Step 4 4 "Compilando executável..."
Show-InfoBox "Este processo pode levar alguns minutos..."
Write-Host ""

Show-BuildAnimation

$profilesPath = Join-Path $ScriptDir "profiles"
$mainPath = Join-Path $ScriptDir "src\main.py"
$srcPath = Join-Path $ScriptDir "src"

# Executa PyInstaller
if (Test-Path $profilesPath) {
    py -m PyInstaller --name="GameTranslator" --onefile --windowed --noconfirm --clean `
        --paths="$srcPath" `
        --hidden-import=PySide6.QtCore `
        --hidden-import=PySide6.QtGui `
        --hidden-import=PySide6.QtWidgets `
        --hidden-import=sqlite3 `
        --hidden-import=psutil `
        --add-data "profiles;profiles" `
        --add-data "src;src" `
        "$mainPath" 2>$null
} else {
    py -m PyInstaller --name="GameTranslator" --onefile --windowed --noconfirm --clean `
        --paths="$srcPath" `
        --hidden-import=PySide6.QtCore `
        --hidden-import=PySide6.QtGui `
        --hidden-import=PySide6.QtWidgets `
        --hidden-import=sqlite3 `
        --hidden-import=psutil `
        --add-data "src;src" `
        "$mainPath" 2>$null
}

Write-Host ""

# Verificar resultado
$exePath = Join-Path $ScriptDir "dist\GameTranslator.exe"

if (Test-Path $exePath) {
    # Limpar arquivos temporários
    if (Test-Path "build") { Remove-Item -Recurse -Force "build" }
    Get-ChildItem -Path $ScriptDir -Filter "*.spec" -ErrorAction SilentlyContinue | Remove-Item -Force
    Get-ChildItem -Path $ScriptDir -Directory -Recurse -Filter "__pycache__" -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force
    
    Write-GradientLine "═" 76
    Show-SuccessBox "BUILD CONCLUÍDO COM SUCESSO!" "dist\GameTranslator.exe"
    
    # Informações do arquivo
    $fileInfo = Get-Item $exePath
    $fileSize = [math]::Round($fileInfo.Length / 1MB, 2)
    
    Write-Host "  📊 Informações do executável:" -ForegroundColor $Colors.Info
    Write-Host "     • Tamanho: " -NoNewline -ForegroundColor $Colors.Dim
    Write-Host "$fileSize MB" -ForegroundColor $Colors.Primary
    Write-Host "     • Criado em: " -NoNewline -ForegroundColor $Colors.Dim
    Write-Host "$($fileInfo.CreationTime)" -ForegroundColor $Colors.Primary
    Write-Host ""
    
    Write-Host "  Abrir pasta do executável? " -NoNewline -ForegroundColor $Colors.Info
    Write-Host "(S/N) " -NoNewline -ForegroundColor $Colors.Primary
    $response = Read-Host
    if ($response -match "^[SsYy]$") {
        explorer (Join-Path $ScriptDir "dist")
    }
} else {
    Show-ErrorBox "Falha ao criar executável! Verifique os erros acima."
}

Write-Host ""
Write-GradientLine "═" 76
Write-Host ""
Read-Host "  Pressione Enter para sair"
