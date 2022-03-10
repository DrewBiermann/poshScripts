[CmdletBinding()]
[Parameter(Mandatory)]
    param(
        [string[]]$Update
        )
$SearchUpdates = dism /online /get-packages | findstr "Package_for"
$updates = $SearchUpdates.replace("Package Identity : ", "") | findstr $using:Update
try{
    Write-Warning "Removing $updates"
    DISM.exe /Online /Remove-Package /PackageName:$updates /quiet #/NoRestart
}catch{Write-Warning "Failed to remove KB"}