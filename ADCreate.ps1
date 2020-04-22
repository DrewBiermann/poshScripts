# Import CSV
$configFile = Import-Clixml -path '.\ADCreationConfig.xml'
$UserList = Import-Csv -Path $configFile.ADaccount.CSVpath
# Load .Net for pword creation
[Reflection.Assembly]::LoadWithPartialName(“System.Web”)

$date = Get-Date -Format “yyyyMMdd”
$fileName = ".\"+$date+"_"+$configFile.ADaccount.fileName

foreach ($User in $UserList) {

    $department = $User.Department
    $RandoPass = [system.web.security.membership]::GeneratePassword(16,1) <#Get-Random -maximum 20000 -Minimum 100#>
    $RandoPass = <# "@" + "User" + #> $RandoPass.ToString()
    $fullName = "$($User.'First Name') $($User.'Last Name')"
    $firstInitial = "$($User.'First Name'.Substring(0,1))$($User.'Last Name')"

    # Set AD Attributes
    $Attributes = @{

        Enabled = $true
        ChangePasswordAtLogon = $true
        Path = "OU=$department,"+$configFile.ADaccount.Path

        Name = $fullName
        UserPrincipalName = $firstInitial+"@"+$configFile.ADaccount.Domain
        SamAccountName = $firstInitial

        GivenName = $User.'First Name'
        Surname = $User.'Last Name'

        Company = $configFile.ADaccount.Company
        Department = $department
        Title = $User.Title
        Description = $User.Title
        EmailAddress = $firstInitial+"@"+$configFile.ADaccount.Domain
        AccountPassword = convertto-securestring $RandoPass -asplaintext -force
        
        }

        try{
            New-ADUser @attributes
            Write-Host "User Created $fullName"
            Write-Host "Password: $RandoPass"
            Write-Output "User Created: $fullName Password: $RandoPass" | Out-File $fileName -Append
        }
        catch{
            Write-Warning "Failed to create user: $fullName $($error[0])"
            Write-Output "Failed to create user: $fullName $($error[0])" | Out-File $fileName -Append
        }
}

#Send e-mail notification

Send-MailMessage -From $configFile.Email.From -to 'dbiermann@cityofmontrose.org'<#$configFile.Email.To#> -Subject $configFile.Email.Subject -Body $configFile.Email.Body -SmtpServer $configFile.Email.SmtpServer -port $configFile.Email.Port -Attachments $fileName –DeliveryNotificationOption OnSuccess