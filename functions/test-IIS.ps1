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
    
    
    # webserver har behandlat HTTP-frågan utana problem
        Write-Host "Website is available!" -ForegroundColor Green
    # 200 = HTTP-fråga okej
        Write-Host "HTTP status code: $($response.StatusCode)" -ForegroundColor Green


}
catch {
    Write-Host "Website is not available!" -ForegroundColor Red
    #hämtar och skriver ut faktiska felmeddelandet
    #$_ = automatisk variabel, är det objekt powershell jobbar med nu
    #i det här fallet innehåller $_ felet
    #exception hämtar felet
    #.message = hämtar felmeddelandet som beskrivs
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Yellow
}
}