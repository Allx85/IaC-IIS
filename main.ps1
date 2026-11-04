# ==================================
# IIS installation and configuration
# ==================================

# Ladda in funktionerna
. "$PSScriptRoot\functions\Install-IIS.ps1"
. "$PSScriptRoot\functions\Configure-IIS.ps1"
. "$PSScriptRoot\functions\Test-IIS.ps1"


# Parametrar
$SourceFile = "$PSScriptRoot\wwwroot\index.html"
$DestinationPath = "C:\inetpub\wwwroot"
$Url = "http://localhost"


# IIS-funktioner som ska aktiveras
$iisFeatures = @(
    "IIS-WebServerRole",
    "IIS-ManagementConsole"
)


# Huvudskript
try {

    Write-Host "================================" -ForegroundColor Cyan
    Write-Host "Starting IIS installation..."
    Write-Host "================================" -ForegroundColor Cyan

    # Steg 1: Installera IIS
    Install-IIS -Features $iisFeatures

    # Steg 2: Konfigurera webbplatsen
    Set-IISWebsite `
        -Source $SourceFile `
        -Destination $DestinationPath

    # Steg 3: Verifiera webbservern
    Test-IIS -WebsiteUrl $Url

    Write-Host "================================" -ForegroundColor Cyan
    Write-Host "Installation completed successfully!" -ForegroundColor Green
    Write-Host "================================" -ForegroundColor Cyan

}

catch {

    Write-Host "`nAn error occurred:" -ForegroundColor Red
    Write-Host $_ -ForegroundColor Red

}