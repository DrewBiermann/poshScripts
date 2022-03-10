$fileName = "c:\users\dbiermann\documents\OSbuild.csv"
$fileName2 = "c:\users\dbiermann\documents\filteredADlist.csv"
$fileName3 = "c:\users\dbiermann\documents\errorPC.csv"
$computers = Get-Content $fileName2
Clear-Content $fileName2

$offlineArray = @()
$OSbuildArray = @()
$errorArray = @()

$scriptblock = {
    $regPath = (Get-Item "HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion")
    $winOS = $regPath.GetValue('ProductName')
    $winRel = $regPath.GetValue('ReleaseId')
    $winOS+' '+$winRel
}

 ForEach ($computer in $computers) {

    #ping before trying anything
    if (Test-Connection -Computername $computer -BufferSize 16 -Count 1 -Quiet){
    #search for OS
        $OSbuild = Invoke-Command -ComputerName $computer -ScriptBlock $scriptblock
    #check for error befor moving on   
            if ($error -ne $null ){
            Write-Host "Can't connect to $computer"
            $errorArray+=$computer
    #Build object for csv export
        } else {
                     $OSbuildArray += New-Object PsObject -Property @{          
                        'OS Build' = $OSbuild
                        'PC Name' = $computer
                    }
     
                }
                
        }
    else {
            Write-Host "$computer offline"
            $offlineArray+=$computer
         }
    $error.clear()
}

$OSbuildArray | Export-Csv $fileName -NoTypeInformation -Append
$offlineArray | Out-File $fileName2 -Append
$errorArray | Out-File $fileName3 -Append

#check via AD
#Get-ADComputer -Properties OperatingSystem  -Filter {OperatingSystem -like "*Windows 7*"} | Select-Object Name, Operatingsystem | Out-File "c:\users\dbiermann\desktop\win7.txt"