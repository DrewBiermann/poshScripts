# PASTE THE FOLLOWING INTO AN ADMIN SHELL: .'\\it\install\pc deployment\caselle-clarity\clarityInstall.ps1' 
#ICONS/SHORTCUTS WILL UPDATE FOLLOWING EXPLORER PROCESS RESTART.

#copy .bat for drive mapping after reboot.

#not necessary if using UNC path for 
#shortcut Copy-Item "\\it\install\PC Deployment\Caselle-Clarity\driveMap.bat" -Destination "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp" -Force

#install

$msiExecArgs = @(
    "/i"
    """\\it\Install\PC Deployment\Caselle-Clarity\CaselleClarity4.msi"""
    "ALLUSERS=1"
    "/qn"
    "/norestart"
)

Start-Process "msiexec.exe" -ArgumentList $msiExecArgs -Wait

#copy clarity folder
try{
    Write-Host "Caselle files copying to local computer. Please be patient. Clicking window will cause script to pause, if window title displays select press any key to continue."
    Write-Host "Copying...."
    Copy-Item "\\it\install\PC Deployment\Caselle-Clarity\Update\*" -Destination "C:\Program Files (x86)\Caselle Clarity 4" -Recurse -Force -ErrorAction Stop
    Write-Host "Files finished copying. Creating new shortcut, updating start path and icon. Restart explorer process to update shortcuts"
    }
catch{
    Write-Warning "Failed to copy items: $($error[0])"
    }

#create shotrcut

$TargetFile = "C:\Program Files (x86)\Caselle Clarity 4\Caselle.exe"
$StartIn = "\\ch-sql16\Caselle\csldata"
$iconPath = "\\it\install\PC Deployment\Caselle-Clarity\clarity.ico"
$ShortcutFile = "$env:Public\Desktop\Caselle.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $TargetFile
$Shortcut.IconLocation = $iconPath
$Shortcut.WorkingDirectory = $StartIn
$Shortcut.Save()

#delete shortcut created by caselle msi

Remove-Item "C:\users\public\desktop\Caselle Clarity.lnk"

#Fix DPI scaling issues with registry flag

New-Item -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers\"-Force | New-ItemProperty -Name "C:\Program Files (x86)\Caselle Clarity 4\Caselle.exe" -Value ~DPIUNAWARE -Force | Out-Null

#Kill explorer

#Stop-Process -processName: Explorer

#Start-Process -processName: Explorer

#Write-Host "Restarting Computer"

#Restart-Computer