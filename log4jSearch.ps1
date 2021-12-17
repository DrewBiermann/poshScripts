function filter-OU{
    [CmdletBinding()]
    [Parameter(Mandatory)]
    param(
        [string[]]$OU
        )
    $filtered = $OU | ForEach-Object {get-adcomputer -Filter "*" -SearchBase $_} | Select -exp Name
    Write-Output $filtered
}
$computers = 
$log4jArray = @()
$fileName = "c:\users\dbiermann\documents\log4jSearch.csv"

$scriptblock = {
    (Get-PSDrive C -PSProvider FileSystem) | foreach { Get-ChildItem "$($_.Name):\" -Recurse -Include log4j.jar -ErrorAction SilentlyContinue}
}

foreach ($machine in $computers) {
    if (Test-Connection -Computername $machine -BufferSize 16 -Count 1 -Quiet){
        $log4jSearch = Invoke-Command -ComputerName $machine -ScriptBlock $scriptblock
        $log4jArray += New-Object PsObject -Property @{          
            'Log4J Location' = $log4jSearch
            'PC Name' = $machine
        }
    } else {
            Write-Host "$machine offline"
            $log4jArray += New-Object PsObject -Property @{          
                'Log4J Location' = "Maschine Offline/Unavailable- Any Doubts???"
                'PC Name' = $machine
            }
        }
    
}

$log4jArray | Export-Csv $fileName -NoTypeInformation -Append