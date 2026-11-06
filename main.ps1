# ==================================
# IIS installation and configuration
# ==================================

# Ladda in funktionerna för orkestrering
#$PSScriptRoot = mappen där skriptet ligger, mitt är C:\IT-infrastruktur25\iac kursen\projekt-IIS\IaC-IIS
. "$PSScriptRoot\functions\Install-IIS.ps1"
. "$PSScriptRoot\functions\Set-IISwebsite.ps1"
. "$PSScriptRoot\functions\Test-IIS.ps1"
. "$PSScirptRoot\functions\menu.ps1"


# Variabler till skriptet
$DestinationPath = "C:\inetpub\wwwroot"
$Url = "http://localhost"
$Logfile ="C:\IT-infrastruktur25\iac kursen\projekt-IIS\IaC-IIS\logs"
$Terraformpath = "$PSScriptRoot\terraform"


# IIS-funktioner som ska aktiveras och skickas in i Install-IIS
$iisFeatures = @(
    "IIS-WebServerRole",
    "IIS-ManagementConsole"
)

# Huvudskript
#variabel som lagrar true
$running = $true
#while (true) körs loopen
while ($running) {
    #anropa funktionen menu
    menu
    # sparar användarens val i variabeln choice
    $choice = Read-Host "Select an option (1-6)"

    # Validering, godkänner bara 1 till 6 med operator -notin som kontrollerar om värdet INTE finns i listan.
    if ($choice -notin "1","2","3","4","5","6") {
        Write-Host "Invalid choice. Select a number between 1-6" -ForegroundColor Red
        Read-Host "Press enter to try again"
    # hoppar tillbaka till början av loopen
        continue
    }

    try {
        #switch jämför ett värde mot flera alternativ, $choice innehåller siffran användaren skrev.
        #switch jämför $choice värdet mot listan
        switch ($choice) {
            "1" {
                write-host "Installing IIS" -ForegroundColor Cyan
                Install-IIS -Features $iisFeatures
            }
                #terraform apply kopierar index.html och startar W3SVC tjänsten
            "2" {
                Write-Host "Deploying site - terraform apply" -ForegroundColor Cyan
                #push-location =sparar nuvarande katalog, byter till katalgon som anges i $Terraformpath
                #för att kunna köra terrafrom kommandon
                Push-Location $Terraformpath
                try {
                    #terraform initiering, läser konfig, hämtar providers
                    terraform init
                    #testar om terraform lyckas, kod notequal to 0 kasta felmeddelande (0 är bra det fungerar)
                    if ($LASTEXITCODE -ne 0) {throw "terraform init failed, Exit code $LASTEXITCODE"}
                    #skapar det som är angivet i terraform main.tf
                    terraform apply -auto-approve
                    #testar om terraform lyckas, kod notequal to 0 kasta felmeddelande (0 är bra det fungerar)
                    if ($LASTEXITCODE -ne 0) {throw "terraform apply failed, Exit code $LASTEXITCODE"}
                }
                #Körs oavsett om terraform misslyckas, utan finally blir man kvar i terrafrom om den misslyckas.
                finally {
                    # byter tillbaka till den sparade katalogen
                    Pop-Location
                }
            }
                #terraform destroy, tar bort det som skapats och stopar tjänsten W3SVC
            "3" {
                Write-Host "Destroying site - terraform destroy" -ForegroundColor Cyan
                Push-Location $Terraformpath
                try {
                    terraform destroy -auto-approve
                    if ($LASTEXITCODE -ne 0) {throw "terraform destroy failed, Exit code $LASTEXITCODE"}
                }
                finally {
                    Pop-Location
                }

            }
            "4" {
                # testar om tjänst körs och om site är uppe
                write-host "Testing service and site" -ForegroundColor Cyan
                test-IIS -websiteURL $Url
            }
            "5" {
                #Get-content läser filen i variabeln $Logfile, fångar fel om filen inte finns
                #Omvandlar icke terminating error till terminating error
                Write-Host "Show log" -ForegroundColor Cyan
                Get-content -Path $Logfile -ErrorAction Stop
            }
            "6" {
                #stänger skriptet genom att ändra running till false
                Write-Host "Exiting script" -ForegroundColor Cyan
                $running = $false
            }
        }  
    }
    catch {
        #körs när fel fångas i try blocket.
        #$_ innehåller felet som uppstod
        #.Exception hämtar felinformationen, property
        #.message hämtar texten som beskriver felet, property

        Write-Host "`nAn error occurred" -ForegroundColor Red
        Write-host $_.Exception.Message -ForegroundColor Red
    }
    #Kontroll om programmet körs, True = väntar på Enter Fale = hoppas över
    if ($running) {
        Read-Host "`nPress Enter to go back to menu"
    }










}