function filter-OU{
    [CmdletBinding()]
    [Parameter(Mandatory)]
    param(
        [string[]]$OU
        )
    $filtered = $OU | ForEach-Object {get-adcomputer -Filter "*" -SearchBase $_} | Select -exp Name
    Write-Output $filtered
}

#EXAMPLE filter-OU -OU 'ou=Information Systems,dc=mydomain,dc=org','ou=Domain Controllers,dc=mydomain,dc=org'