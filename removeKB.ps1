$Update = Read-Host -Prompt "Specify KB build number e.g. 19041.867"
$Computers = Read-Host -Prompt "Enter computer name"

$scriptblock = {
    $SearchUpdates = dism /online /get-packages | findstr "Package_for"
    $updates = $SearchUpdates.replace("Package Identity : ", "") | findstr $using:Update
    try{
        Write-Warning "Removing KB $updates" 
        Write-Warning "$machine will restart shortly"
        DISM.exe /Online /Remove-Package /PackageName:$updates /quiet #/NoRestart
        #msg * "Please reboot computer at earliest convencience. A windows update has been removed to fix printer issues. -City of Montrose IT Dept."
    }catch{Write-Host "Failed to remove KB"}
    
}

Invoke-Command -ComputerName $Computer -ScriptBlock $scriptblock