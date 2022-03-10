$dcuProcess=Get-Process DellCommandUpdate -ErrorAction SilentlyContinue
$dcuPath="C:\Program Files\Dell\CommandUpdate\dcu-cli.exe"
$dcuPathx86="C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe"

if ($dcuProcess){
    Write-Host "Killing DCU process..."
    $dcuProcess | Stop-Process -Force
}

if (Test-Path -Path $dcuPath -PathType Leaf){
    Write-Host "DCU 64bit installed, applying updates and schedule..."
    try {
        .$dcuPath /configure '-scheduleMonthly=31,00:00'
        .$dcuPath /applyupdates
    }
    catch {
        Write-Host "Something went wrong with DCU"
    }
}elseif (Test-Path $dcuPathx86 -PathType Leaf) {
    Write-Host "DCU 32bit installed, applying updates and schedule..."
    try {
        .$dcuPathx86 /configure '-scheduleMonthly=31,00:00'
        .$dcuPathx86 /applyupdates  
    }
    catch{
        Write-Host "Something went wrong with DCU"
    }
    
}else{
    Write-Host "DCU not installed"
}       