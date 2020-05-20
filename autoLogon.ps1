Write-Host "This script will bypass windows login screen. Computer will restart after entering password."
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$DefaultUsername = Read-Host -Prompt "Enter Username" #"your username"
$DefaultPassword = Read-Host -Prompt "Enter Password" #"your password"
#$DefaultDomainName = Read-Host -Prompt "Enter Domain"
Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String 
Set-ItemProperty $RegPath "DefaultUsername" -Value "$DefaultUsername" -type String 
Set-ItemProperty $RegPath "DefaultPassword" -Value "$DefaultPassword" -type String
Set-ItemProperty $RegPath "DefaultDomainName" -Value "$DefaultDomainName" -type String
Restart-Computer