function Install-IIS {

    param(
        [string[]]$Features
    )

    Write-Host "`nChecking IIS..." -ForegroundColor Cyan

    foreach ($feature in $Features) {

        Write-Host "Enabling $feature..." -ForegroundColor Yellow

        dism.exe /Online /Enable-Feature "/FeatureName:$feature" /All /NoRestart

        $exitCode = $LASTEXITCODE

        if ($exitCode -eq 0) {

            Write-Host "$feature successfully enabled" -ForegroundColor Green

        }
        elseif ($exitCode -eq 3010) {

            Write-Warning "Restart Windows to complete installation."

        }
        else {

            throw "Failed to enable $feature. Exit code: $exitCode"

        }

    }

    Write-Host "`nIIS features are enabled!" -ForegroundColor Green

}