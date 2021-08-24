Steps to deploy Windows 2019 RDS in Workgroup without AD

1. Install a Fresh Windows 2019 Standard Server with Full GUI
   
   
2. Enable Remote Desktop Session Host & Remote Desktop Licensing Only
   
   
```
Import-Module ServerManager

Add-WindowsFeature -Name RDS-Licensing, RDS-RD-Server -IncludeManagementTools

```
3. Restart Server
```
Restart-Computer

```
4. Create a Local User and add it to Local Remote Desktop Users Group
```
$Password = ConvertTo-SecureString -AsPlainText "P@ssw0rd!@#$" -Force
$UserName = "UAT2"
New-LocalUser -Name $UserName -Description "UAT Account" -Password $Password

Add-LocalGroupMember -Group "Remote Desktop Users" -Member $UserName

```
5. Launch RDS Licensing Server and activate it
```
licmgr.exe 

```


6. Install the RDS Device CAL License with the License Key
Only RDS Device CAL License is supported in WorkGroup Enviroment


You can convert RDS User CAL to Device CAL and via visa by right click on the License installed – Convert License


7. Point RDS Server to use Specific Licensing Server with Pre-Device Mode
```
$RDSLicenseServer = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"

#Replace Value with the IP Address / FQDN of Valid RDS Licensing Server
New-ItemProperty -Path $RDSLicenseServer -Name LicenseServers -PropertyType "String" -Value "192.168.1.169"

#Set the Licensing Server to use Pre-Device Mode
New-ItemProperty -Path $RDSLicenseServer -Name LicensingMode -PropertyType "DWord" -Value "2"

```

Or You can open Group Policy Editor “gpedit.msc” and go to

Computer Configuration – Administrative Templates – Windows Components – Remote Desktop Services – Remote Desktop Session Host – Licensing


8. Login to RDS Server with username = UAT1 and you will see a Temporary Device CAL is assigned to the PC in the RDS Licensing Manager.
When you use the Per Device model, a temporary license is issued the first time a device connects to the RD Session Host. The second time that device connects, as long as the license server is activated and there are available CALs, the license server issues a permanent RDS Per Device CAL.
9. Log Off from RDS Server, and relogin again. You will see the Device CAL is assigned to to PC where the users login from

10. Revoke the RDS Device CAL license assigned to PC if the License is nearly full.
```
$licensepacks = Get-WmiObject win32_tslicensekeypack | where {($_.keypacktype -ne 0) -and ($_.keypacktype -ne 4) -and ($_.keypacktype -ne 6)}

#Check the total License installed for Device CAL only
$licensepacks.TotalLicenses

# Get all licenses currently assigned to devices
$TSLicensesAssigned = gwmi win32_tsissuedlicense | where {$_.licensestatus -eq 2}

#Specific the Name of the PC to revoke the Device CAL from
$RevokePC = $TSLicensesAssigned | ? sIssuedToComputer -EQ "LAB-EX16"

#Revoke the License 
$RevokePC.Revoke() 
```
