function filter-OU{
    [CmdletBinding()]
    [Parameter(Mandatory)]
    param(
        [string[]]$OU
        )
    $filtered = $OU | ForEach-Object {get-adcomputer -Filter "*" -SearchBase $_} | Select -exp Name
    Write-Output $filtered
}
$computers = filter-OU -OU #filtered domains here
$onlineComputers = @()
$fileName = "c:\users\dbiermann\documents\log4jSearch.csv"

$scriptblock = {
    #write-verbose "Hello" -verbose 4>&1
    New-Object PsObject -Property @{          
        'Log4J Location' = (Get-PSDrive C -PSProvider FileSystem) | foreach { Get-ChildItem "$($_.Name):\" -Recurse -Include *log4j.jar* -ErrorAction SilentlyContinue }
        'PC Name' = hostname
    }
}

foreach ($machine in $computers) {
    if (Test-Connection -Computername $machine -BufferSize 16 -Count 1 -Quiet){
        $onlineComputers+=$machine
        
        } else {
            Write-Host "$machine offline"
            }
}

Write-Host "Search for Log4J on $onlineComputers, please be patient..."
try{
    $log4jSearch = Invoke-Command -ComputerName $onlineComputers -ScriptBlock $scriptblock
    write-output $log4jSearch
}catch{
    Write-Host "Error running invoke-command"
}


$log4jSearch | Select-Object 'pc name','log4j location'| Export-Csv $fileName -NoTypeInformation -Append