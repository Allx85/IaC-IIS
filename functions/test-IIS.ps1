function Test-IIS {

    param(
        [string]$WebsiteUrl
    )

    Write-Host "`nVerifying IIS..." -ForegroundColor Cyan

    # Hämta IIS-tjänsten
    $service = Get-Service -Name "W3SVC" -ErrorAction Stop

    # Kontrollera om tjänsten körs
    if ($service.Status -ne "Running") {

        Write-Host "Starting IIS service..." -ForegroundColor Yellow

        Start-Service -Name "W3SVC" -ErrorAction Stop

    }

    else {

        Write-Host "IIS service is running" -ForegroundColor Green

    }

    # Kontrollera att webbplatsen svarar
    $response = Invoke-WebRequest `
        -Uri $WebsiteUrl `
        -UseBasicParsing `
        -ErrorAction Stop

    if ($response.StatusCode -eq 200) {

        Write-Host "Website is available!" -ForegroundColor Green

        Write-Host "HTTP status code: $($response.StatusCode)" -ForegroundColor Green

    }

    else {

        throw "Website is not available."

    }

}