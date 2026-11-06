function menu {
    #tar bort all text tidigare i terminalen som clear i linux
    Clear-Host
    Write-Host "=======================================" -ForegroundColor DarkMagenta
    Write-Host "               IIS MENU                " -ForegroundColor Yellow
    Write-host "=======================================" -ForegroundColor DarkMagenta
    Write-host "1. Install IIS" -ForegroundColor Cyan
    Write-Host "2. Deploy site" -ForegroundColor Cyan
    Write-host "3. Destroy site" -ForegroundColor Cyan
    Write-host "4. Test site" -ForegroundColor Cyan
    Write-host "5. Show log" -ForegroundColor Cyan
    Write-Host "6. Exit" -ForegroundColor Cyan
    write-host "=======================================" -ForegroundColor DarkMagenta
}
menu