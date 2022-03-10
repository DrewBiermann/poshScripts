$list= Get-ADComputer -Filter '*' -SearchBase 'ou=WCRDC,dc=cityofmontrose,dc=org' | Select -Exp Name

$scriptblock = {
    New-PSDrive -PSProvider registry -Root HKEY_USERS -Name HKU
    #grab all profiles on machine plus default for any new user that logs in
    $users = (Get-ChildItem -path c:\users).name+'Default'
    #iterate through each profile
    foreach($account in $users)
     {
     #IF user is logged in ntuser.dat will be locked and changes won't apply
     #grab .dat to reference profile's registry
     reg load "HKU\hive" "C:\Users\$account\NTUSER.DAT"
     #set mouse to show location when hitting ctrl
     New-ItemProperty -Path "HKU:\hive\Control Panel\Desktop" -Name UserPreferencesMask -Value  ([byte[]](0x9E,0x5E,0x07,0x80,0x12,0x00,0x00,0x00)) -PropertyType Binary -Force
     reg unload "HKU\hive"
     }
 }

 #iterate against list of computers provided
 foreach ($computer in $list){
    Invoke-Command -ComputerName $computer -ScriptBlock $scriptblock
}