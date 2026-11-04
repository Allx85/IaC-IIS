function Set-IISWebsite {

    param(
        [string]$Source,
        [string]$Destination
    )

    Write-Host "`nConfiguring website..." -ForegroundColor Cyan

    # Kontrollera att HTML-filen finns
    if (!(Test-Path -Path $Source -PathType Leaf)) {

        throw "HTML file not found: $Source"

    }

    # Skapa katalogen om den inte finns
    if (!(Test-Path -Path $Destination -PathType Container)) {

        New-Item -ItemType Directory -Path $Destination -Force -ErrorAction Stop

    }

    # Kopiera HTML-filen
    Copy-Item `
        -Path $Source `
        -Destination "$Destination\index.html" `
        -Force `
        -ErrorAction Stop

    Write-Host "Website configured successfully!" -ForegroundColor Green

}