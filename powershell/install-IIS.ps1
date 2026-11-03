# ==================================
# IIS installation och konfiguration
# ==================================

# Parametrar
param (
    [string]$SourceFile = "C:\IaC-IIS\wwwroot\index.html",
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

    foreach ($feature in $Features) {
        try {
            
            #Kontroll om funktionen är akativerad
            $status = Get-WindowsOptionalFeature `
                -Online `
                -FeatureName $feature `
                -ErrorAction Stop
            if ($status.state -ne "Enabled") {

                Write-host "Installing $feature..." -ForegroundColor Yellow

                #Aktivera funktionen
                $result = Enable-WindowsOptionalFeature `
                    -Online `
                    -FeatureName $feature `
                    -All `
                    -NoRestart `
                    -ErrorAction Stop
                if ($result.RestartNeeded) {
                    write-warning "Restart windows"
                }
            }
            
            else {
                Write-host "$feature allready activated" -ForegroundColor Green
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
        Net-Item -Itemtype Directory -Path $Destination -Force -ErrorAction Stop

    }

    # Kopiera HTML-filen till IIS webbroot katalog
    Copy-Item `
        -Path $Source `
        -Destination "$Destination\index.html" `
        -Force `
        -ErrorAction Stop

        Write-Host "Website configured successfully" -ForegroundColor Green
}

