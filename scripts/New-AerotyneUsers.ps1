Import-Module ActiveDirectory

$Users = Import-Csv "C:\IAM-Lab\new-hires.csv"

$Password = Read-Host "Enter temporary password for new users" -AsSecureString

foreach ($User in $Users) {

Write-Host "-------------------------"
Write-Host "Processing $($User.FirstName) $($User.LastName)"

switch ($User.Department) {

"Finance" {
$OU = "OU=Finance,OU=Employees,OU=Aerotyne,DC=corp,DC=Aerotyne,DC=com"
$DepartmentGroup = "GG-Finance-Users"
}
"Human Resources" {
$OU = "OU=Human Resources,OU=Employees,OU=Aerotyne,DC=corp,DC=Aerotyne,DC=com"
$DepartmentGroup = "GG-HR-Users"
}
"IT" {
$OU = "OU=IT,OU=Employees,OU=Aerotyne,DC=corp,DC=Aerotyne,DC=com"
$DepartmentGroup = "GG-IT-Users"
}
"Sales" {
$OU = "OU=Sales,OU=Employees,OU=Aerotyne,DC=corp,DC=Aerotyne,DC=com"
$DepartmentGroup = "GG-Sales-Users"
}

}

New-ADUser `
-Name "$($User.FirstName) $($User.LastName)" `
-GivenName $User.FirstName`
-Surname $User.LastName `
-SamAccountName $User.Username `
-UserPrincipalName "$($User.Username)@corp.aerotyne.com"`
-Department $User.Department `
-Title $User.Title `
-Company "Aerotyne" `
-Path $OU `
-AccountPassword $Password `
-Enabled $true

Add-ADGroupMember `
-Identity $DepartmentGroup `
-Members $User.Username

if ($User.VPN -eq "Yes") {

Add-ADGroupMember `
-Identity "GG-VPN-Users"`
-Members $User.Username 

}

if ($User.Payroll -eq "Yes") {

Add-ADGroupMember `
-Identity "GG-Payroll-Access" `
-Members $User.Username


}

Write-Host "Provisioned $($User.Username)"

}
