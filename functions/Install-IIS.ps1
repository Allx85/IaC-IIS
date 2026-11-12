#skapa funktion Install-IIS
function Install-IIS {
    #tar emot en lista med IIS-funktioner, lista med strängar "text" från $iisfeatures i main.ps1
    param(
        [string[]]$Features
    )

    Write-Host "`nChecking IIS..." -ForegroundColor Cyan
    #Loopar igenom alla listan $Features
    foreach ($feature in $Features) {

        Write-Host "Enabling $feature..." -ForegroundColor Yellow
        #DISM (deployment image servicing and management) för Win 11. Aktiverar Windows-funktioner
        #/online = aktiva windows systemet, /enable-feature = aktivera features
        #aktiverar funktion ur $feature, /All tar med dependencies, /norestart startar inte om datorn automatiskt
        dism.exe /Online /Enable-Feature "/FeatureName:$feature" /All /NoRestart
        #hämtar exit code från senast körda program
        $exitCode = $LASTEXITCODE
        #Kollar om exit code är 0 då lyckades  det
        if ($exitCode -eq 0) {

            Write-Host "$feature successfully enabled" -ForegroundColor Green

        }
        #3010 är en DISM kod som betyder att det lyckades men omstart krävs
        elseif ($exitCode -eq 3010) {

            Write-Warning "Restart Windows to complete installation."

        }
        #alla andra fel hanteras här och visar koden
        #throw kastar ett fel och avbryter
        else {

            throw "Failed to enable $feature. Exit code: $exitCode"

        }

    }
    #har allt gått bra så printas det här
    Write-Host "`nIIS features are enabled!" -ForegroundColor Green

}