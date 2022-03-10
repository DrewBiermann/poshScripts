Function Get-Coordinates{
    [CmdletBinding()]

    param (
        [Parameter(Mandatory)]
        [string]$Computer
    )

    $scriptblock = {
        Set-Itemproperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location' -Name 'Value' -value 'Allow' -Force #sets the current user registry value to allow location access
        Add-Type -AssemblyName System.Device #Required to access System.Device.Location namespace
        $GeoWatcher = New-Object System.Device.Location.GeoCoordinateWatcher #Create the required object
        $GeoWatcher.Start() #Begin resolving current locaton

        while (($GeoWatcher.Status -ne 'Ready') -and ($GeoWatcher.Permission -ne 'Denied')) {
            Start-Sleep -Milliseconds 1000 #Wait for discovery.
        }  

        if ($GeoWatcher.Permission -eq 'Denied'){
            Write-Error 'Access Denied for Location Information'
        } else {
            $GeoWatcher.Position.Location
        }
    }

    $Coordinates=Invoke-Command -ComputerName $Computer -ScriptBlock $scriptblock
    Write-Host "$Computer is Located at:" 
    $Coordinates | Select Latitude,Longitude
    $Latitude = $Coordinates | Select -ExpandProperty Latitude
    $Longitude = $Coordinates | Select -ExpandProperty Longitude
    $GoogleMapsLink = "https://www.google.com/maps/search/?api=1&query=$Latitude,$Longitude"
    Start-Process $GoogleMapsLink
}