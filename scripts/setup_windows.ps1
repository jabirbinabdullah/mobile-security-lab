# Mobile Security Lab Setup (Windows 11)
# Run from an Administrator PowerShell session

Write-Host "=== Mobile Security Lab Setup (Windows 11) ===" -ForegroundColor Cyan

# 1. Install via Winget / Scoop if available
Write-Host "[1/4] Checking winget package manager..." -ForegroundColor Yellow
if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Host "Installing OpenJDK 17, Android Platform Tools, and Git..."
    winget install --id EclipseAdoptium.Temurin.17.JDK -e --silent
    winget install --id Google.PlatformTools -e --silent
    winget install --id Git.Git -e --silent
    winget install --id Python.Python.3.12 -e --silent
} else {
    Write-Warning "winget not found. Please install Scoop, Chocolatey, or manually install JDK and Platform Tools."
}

# 2. Setup Python Virtual Environment
Write-Host "[2/4] Setting up Python Virtual Environment..." -ForegroundColor Yellow
$VenvPath = "$HOME\.mobile-lab-venv"
if (!(Test-Path $VenvPath)) {
    python -m venv $VenvPath
}

& "$VenvPath\Scripts\python.exe" -m pip install --upgrade pip
& "$VenvPath\Scripts\pip.exe" install frida frida-tools objection

# 3. Enable Hypervisor Platform for Android Studio AVD
Write-Host "[3/4] Checking Windows Hypervisor features..." -ForegroundColor Yellow
Enable-WindowsOptionalFeature -Online -FeatureName HypervisorPlatform, VirtualMachinePlatform -NoRestart

Write-Host "`nSetup script finished! Please restart PowerShell to refresh PATH variables." -ForegroundColor Green
