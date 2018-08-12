# storing-secure-string.ps1 - using powershell to store and load a string securely in an external file

# store or loads secure string 
function Get-Secret ($PathRoot) {
    
    # check if secure file already exists, if not create one
    if (!([System.IO.File]::Exists("$PathRoot\secret.cred"))) {
        
        Write-Host 'storing secret ...'

        $secret = Read-Host 'Enter a secret word, code or phrase longer than 10 characters'
        $secret | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File "$PathRoot\secret.cred" -Force

        return $secret
    }
    else {
        
        Write-Host 'loading secret ...'
        
        $secret_encrypted = Get-Content "$PathRoot\secret.cred" | ConvertTo-SecureString
        $secret = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR((($secret_encrypted))))

        return $secret
    }
}

################################# Starting Main Script #################################


# run Get-Secret - Creates and Retrieves Secure Strings from file
$Secret = Get-Secret $PSScriptRoot

# results of Get-Secret
# I added some logic to the output to only show last 5 characters. easy to validate and hide SECRET
Write-Host 'Your secret was' $Secret.Length 'characters long.'
Write-Host 'The last five characters of your secret are ...'$Secret.Substring($Secret.Length - 5, 5)

Exit
