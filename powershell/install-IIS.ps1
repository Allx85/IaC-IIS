# ==================================
# IIS installation och konfiguration
# ==================================

# Parametrar
param (
    [string]$SourceFile = "C:\IT-infrastruktur25\iac kursen\projekt-IIS\IaC-IIS\wwwroot\index.html",
    [string]$DestinationPath = "C:\inetpub\wwwroot",
    [string]$Url = "http://localhost"
)

#==========================================
#Installera IIS
#=========================================
function Install-IIS {
    param(
        [string[]]$Features
    )

    Write-host "`nChecking if IIS is installed..." -ForegroundColor Cyan
# kontrollera om det är Windows 10/11 = type 1 eller windows server = type 3 DC = type 2
    $isWindowsServer = (Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop).ProductType -ne 1

    foreach ($feature in $Features) {
        try {
            if ($isWindowsServer) {
                $serverFeature = switch ($feature) {
                    "IIS-WebServerRole" { "Web-Server" }
                    "IIS-ManagementConsole" { "Web-Mgmt-Console" }
                    default { throw "No Windows Server feature mapping exists for '$feature'." }
                }

                $status = Get-WindowsFeature -Name $serverFeature -ErrorAction Stop
                if (-not $status.Installed) {
                    Write-host "Installing $serverFeature..." -ForegroundColor Yellow
                    $result = Install-WindowsFeature -Name $serverFeature -ErrorAction Stop
                    if (-not $result.Success) {
                        throw "Windows Server could not install feature '$serverFeature'."
                    }
                    if ($result.RestartNeeded -eq "Yes") {
                        Write-warning "Restart Windows to complete the installation."
                    }
                }
                else {
                    Write-host "$serverFeature already activated" -ForegroundColor Green
                }
            }
            else {
                # Use native DISM because its PowerShell cmdlets can fail with COM
                # registration errors on some Windows client installations.
                $dismPath = Join-Path $env:windir "System32\dism.exe"
                if ([Environment]::Is64BitOperatingSystem -and -not [Environment]::Is64BitProcess) {
                    $dismPath = Join-Path $env:windir "Sysnative\dism.exe"
                }

                Write-host "Enabling $feature..." -ForegroundColor Yellow
                & $dismPath /Online /Enable-Feature "/FeatureName:$feature" /All /NoRestart
                $dismExitCode = $LASTEXITCODE
                if ($dismExitCode -eq 3010) {
                    Write-warning "Restart Windows to complete the installation."
                }
                elseif ($dismExitCode -ne 0) {
                    throw "DISM failed to enable '$feature' (exit code $dismExitCode)."
                }
            }
        }
        catch {
            throw "Could not install IIS-feature '$feature': $_"
        }
    }

    Write-host "IIS-functions are correctly installed" -ForegroundColor Green
}

#==========================================
# Configure IIS
#=========================================

function Configure-IIS {
    param(
        [string]$Source,
        [string]$Destination
    )

    Write-host "`nConfiguring Website..." -ForegroundColor Cyan

    #Kontrollera att HTML-filen finns
    if (!(Test-Path -Path $Source -Pathtype Leaf)) {
        throw "HTML-file not found in: $Source"

    }

    #Kontrollera att katalogen finns
    if (!(Test-Path -Path $Destination -Pathtype Container)) {

        # skapa katalog om den inte finns
        New-Item -ItemType Directory -Path $Destination -Force -ErrorAction Stop

    }

    # Kopiera HTML-filen till IIS webbroot katalog
    Copy-Item `
        -Path $Source `
        -Destination "$Destination\index.html" `
        -Force `
        -ErrorAction Stop

        Write-Host "Website configured successfully" -ForegroundColor Green
}

#==========================================
# Verify IIS installation
#=========================================

function Test-IIS {

    param(
        [string]$WebsiteUrl
    )

    Write-host "`nVerifying IIS..." -ForegroundColor Cyan

    # Hämta IIS tjänsten
    $Service = Get-Service -Name "W3SVC" -ErrorAction Stop

    # Kontroll om tjänsten körs
    if ($Service.status -ne "Running") {
        Write-host "Starting IIS-servce..." -ForegroundColor Yellow
        Start-Service -Name "W3SVC" -ErrorAction Stop

    }
    else {
        Write-host "IIS-service is running" -ForegroundColor Green
    }

    # Kontrollera att webbplatsen är tillgänglig
    $response = Invoke-WebRequest `
        -Uri $WebsiteUrl `
        -UseBasicParsing `
        -ErrorAction Stop
    if ($response.statuscode -eq 200) {

        Write-Host "Website is available" -ForegroundColor Green
        Write-Host "HTTP-status code: $($response.statuscode)" -ForegroundColor Green

    }
    else {
        throw "Website is not available. HTTP-status code: $($response.statuscode)"
    }
}

#==========================================
# Huvud skript
#==========================================

try {

    Write-Host "================================" -ForegroundColor Cyan
    Write-Host "Starting IIS installation and configuration..."
    Write-Host "================================" -ForegroundColor Cyan

    # Array med IIS-funktioner som ska aktiveras
    $iisFeatures = @(
        "IIS-WebServerRole",
        "IIS-ManagementConsole"
    )

    # Steg 1: installera IIS
    Install-IIS -Features $iisFeatures

    # Steg 2: Konfigurera Webbplatsen
    Configure-IIS `
        -source $SourceFile `
        -destination $DestinationPath
    
    # Steg 3: Verifiera webbserver
    Test-IIS -WebsiteUrl $Url

    Write-Host "================================" -ForegroundColor Cyan
    Write-Host "Installation is completed successfully!"
    Write-Host "================================" -ForegroundColor Cyan




}
catch {
    Write-host "`nAn error occurred during the installation and configuration of IIS:" -ForegroundColor Red
    Write-Host $_ -ForegroundColor Red
}
