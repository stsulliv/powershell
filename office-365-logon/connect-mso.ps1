# This script prompts for credentials and stores them encrypted in the script directory.
# only the user account that created the stored credential can access it
#
# .\connectoToMso.ps1 "first.last.@example.com"

# Checks for UPN passed to script through CLI
[CmdletBinding()]
Param(

    [Parameter(Mandatory=$True,Position=0,HelpMessage="Enter MSO account (user@example.com)")][ValidateNotNullOrEmpty()]
        [string]$mso_account
)

# Always include Path instead of .\ for extensibility
$PathRoot = $PSScriptRoot

# below stores credentials or loads stored credentials
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

# create Exchange Online Session
$ExchOnlineSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $Credential -Authentication Basic -AllowRedirection

if ($null -ne $ExchOnlineSession) {
    
    try {

        Import-PSSession $ExchOnlineSession

    } catch {
        
        'STOPPING...Could not connect to Exchange Online'
        Stop
    }

    'SUCCESS...Connected to Exchange Online'
}

# create Exchange Online Protection (EOP) session
$EopSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $Credential -Authentication Basic -AllowRedirection

if ($null -ne $EopSession) {
    
    try {

        Import-PSSession $EopSession -AllowClobber
    
    } catch {
        
        'STOPPING...Could not connect to Exchange Online Protection (EOP)'
        Stop
    }

    'SUCCESS...Connected to Exchange Online Protection (EOP)'
} 

# Connect to Microsoft Online Session (MSO)
try {

    Connect-MsolService -Credential $Credential

    
    } catch {
        
        'STOPPING...Could not connect to Microsoft Online Service (MSO)'
        Stop
    }

'SUCCESS...Connected to Microsoft Online Service (MSO)'

'Before closing window run Get-PSSession | Remove-PSSession to close Exo and Eop sessions'

#################### the resulting prompt is connected to Exchange Online, EOP and Azure AD ########################

# Before closing window run
# Get-PSSession | Remove-PSSession

######################################### Sample Scripts to copu-and-paste #########################################

# Get-MailboxPermission -Identity "first.last@example.com"
# Get-MailboxPermission -Identity "first.last@example.com" | Where-Object {($_.IsInherited -ne "True") -and ($_.User -notlike "*SELF*")}

# Get-InboxRule -Mailbox "first.last@example.com"
# Get-InboxRule -Mailbox "first.last@example.com" | Where-Object {(($_.Enabled -eq $true) -and (($_.ForwardTo -ne $null) -or ($_.ForwardAsAttachmentTo -ne $null) -or ($_.RedirectTo -ne $null) -or ($_.SendTextMessageNotificationTo -ne $null)))}

# Search-UnifiedAuditLog -StartDate (Get-Date).AddDays(-7).ToString('MM/dd/yyyy') -EndDate (Get-Date).ToString('MM/dd/yyyy') -UserIds "first.last@example.com"

# Search-UnifiedAuditLog -StartDate 08/01/2018 -EndDate 08/03/2018
