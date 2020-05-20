
#This will prompt for the profile you want to copy the logitech appdata from
$profile = Read-Host -Prompt "Enter profile to copy Logitech AppData from"

#Deletes logi appdata from all profiles except source. Copies from source to default profile and all other profiles on computer.
$scriptblock = {
    $message = "Logitech AppData copied successfully!"
    try{
        $source = "C:\Users\$Using:profile\AppData\Roaming\LogiShrd" 
        $destination = Get-ChildItem 'C:\Users' | Where-Object {$_.Name -ne $Using:profile} | Select-Object -ExpandProperty name
        Write-Host $destination
        #remove/copy appdata to default profile for new user
        Remove-Item -LiteralPath 'c:\users\default\appdata\roaming\logishrd' -Verbose -Recurse -Force
        Copy-Item -LiteralPath $source -Destination "c:\users\default\appdata\roaming" -Verbose -Recurse -Force -ErrorAction Stop
        #copy logi appdata to every profile on pc
        foreach ($user in $destination){
        $path = "C:\Users\$user\Appdata\Roaming\LogiShrd"
        Remove-Item -LiteralPath $path -Verbose -Recurse -Force
        Copy-Item -LiteralPath $source -Destination $path -Verbose -Recurse -Force -ErrorAction Stop
        }
    } catch { $message = "Logitech AppData copy failed!"}
    Write-Host $message

}

#Prompts for computer you wish to run the script on
$computerName = Read-Host -Prompt "Enter PC Name you wish to run script on"

Invoke-Command -ComputerName $computerName  -ScriptBlock $scriptblock