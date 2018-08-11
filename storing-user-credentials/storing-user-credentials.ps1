# storing-user-credentials.ps1 - Sample file to store and load user credentials securely

# function returns configuration file with multiple parameters
function Get-Credentials ($PathRoot) { 
    
    # check if account and password .cred files exist
    if (!([System.IO.File]::Exists("$PathRoot\password.cred")) -Or !([System.IO.File]::Exists("$PathRoot\account.cred"))) {
        
        Write-Host 'storing credentials...'
        
        # request credentials - spawns Windows Login window
        $Credential = Get-Credential

        # store the credential username and password
        $Credential.UserName | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File "$PathRoot\account.cred" -Force
        $Credential.Password | ConvertFrom-SecureString | Out-File "$PathRoot\password.cred" -Force

        return $Credential
    }
    else {
        
        Write-Host 'loading credentials...'
        
        # load account name
        $UsernameSecure = Get-Content "$PathRoot\account.cred" | ConvertTo-SecureString
        $Username = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR((($UsernameSecure))))

        # load password
        $PwdSecureString = Get-Content "$PathRoot\password.cred" | ConvertTo-SecureString

        # Get credential using username and password
        $Credential = New-Object System.Management.Automation.PSCredential -ArgumentList $Username, $PwdSecureString

        return $Credential
    }
}

$Credential = Get-Credentials $PSScriptRoot

# results of Get-Credentials
Write-Host 'Returned credentials:' $Credential.UserName

Exit
