# you can include the UPN as a parameter or you will be prompted/
[CmdletBinding()]
Param(

    [Parameter(Mandatory=$True,Position=0,HelpMessage="Enter MSO account (user@example.com)")][ValidateNotNullOrEmpty()]
        [string]$mso_account
)

$PathRoot = $PSScriptRoot

# below stores credentials and loads stored credentials
if (!([System.IO.File]::Exists("$PathRoot\$mso_account.pwd"))) {
    
    $Credential = Get-Credential -Username $mso_account -Message "Enter a user name and password"

    $Credential.Password | ConvertFrom-SecureString | Out-File "$PathRoot\$mso_account.pwd" -Force

}
else {
    $PwdSecureString = Get-Content "$PathRoot\$mso_account.pwd" | ConvertTo-SecureString

    $Credential = New-Object System.Management.Automation.PSCredential -ArgumentList $mso_account, $PwdSecureString
}

# wait until you need to MSOnline module
import-module MSOnline

# Connect to Exchange Online
$ExchOnlineSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $Credential -Authentication Basic -AllowRedirection

if ($null -ne $ExoSession) {

    Import-PSSession $ExoSession
}

# Connect to EOP
$EopSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $Credential -Authentication Basic -AllowRedirection

if ($null -ne $EopSession) {

    Import-PSSession $EopSession -AllowClobber
} 

# Connect to MS Online
Connect-MsolService -Credential $Credential

# this leaves an open connection to Exchange Online, EOP and Azure AD

#Load "System.Web" assembly in PowerShell console 
#[Reflection.Assembly]::LoadWithPartialName("System.Web")

# close the Exchange Online and EOP sessions
# Remove-PSSession $ExchOnlineSession
# Remove-PSSession $EopSession

# if you need to close orphaned PS-sessions
# Get-PSSession | Remove-PSSession

# MsolService connection closes when you close powershell
