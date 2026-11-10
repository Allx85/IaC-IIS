# skapar en funktion Test-IIS
function Test-IIS {
    # tar in en sträng från main.ps1 sparas i variabel $WebsiteUrl
    # från main.ps1 test-IIS -websiteURL $Url
    param(
        [string]$WebsiteUrl
    )

    Write-Host "`nVerifying IIS..." -ForegroundColor Cyan

    # Hämta IIS-tjänsten W3SVC (world wide web publishing service)
    # sparar resultat i variabel $service
    $service = Get-Service -Name "W3SVC"

    # Kontrollera om status not equal to running, skriv då detta
    if ($service.Status -ne "Running") {

        Write-Host "IIS service is not running" -ForegroundColor Yellow

    }
    # tjänsten var running skriv detta
    else {

        Write-Host "IIS service is running" -ForegroundColor Green

    }

    # Try testar att köra kod som kan orsaka fel
    # $response sparar svaret från Invoke-WebRequest
    # UseBasicParsing är förenklad parsing istället för Internet explorer baserad
    # erroraction stop - fel avbryter och skickat till catch
try {
    $response = Invoke-WebRequest `
        -Uri $WebsiteUrl `
        -UseBasicParsing `
        -ErrorAction Stop

    if ($response.StatusCode -eq 200) {

        Write-Host "Website is available!" -ForegroundColor Green

        Write-Host "HTTP status code: $($response.StatusCode)" -ForegroundColor Green

    }

    else {
        # kastar fal och avbryter
        throw "Website is not available."

    }
}
catch {
    Write-Host "Website is not available!" -ForegroundColor Red
    #hämtar och skriver ut faktiska felmeddelandet
    Write-Host "No HTTP response received" -ForegroundColor Yellow
}
}