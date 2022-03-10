$fileName='\\it\install\PC Deployment\Dell Command Update\dbutil.csv'

.'\\it\Install\PC Deployment\Dell Command Update\DBUtilRemovalTool.exe' /s |Tee-Object -Variable 'dbUtilLogs'

$DellUtilArray = New-Object PsObject -Property @{          
    'Dell Log' = $dbUtilLogs[6]+$dbUtilLogs[9]
    'PC Name' = $env:COMPUTERNAME
}

$DellUtilArray | Export-Csv $fileName -NoTypeInformation -Append -Force