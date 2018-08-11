# Sample file on how to store credentials and strings securely in a file and retrieve as needed
clear

function Get-PlainText ($PathRoot) {
    
    # check if a config file already exists, if not create one
    if (!([System.IO.File]::Exists("$PathRoot\configuration.xml"))) {
        
        "creating configuration ..."
        $first_name = Read-Host 'Please enter your first name'
        $last_name = Read-Host 'Please enter your last name'
        $favorite_color = Read-Host 'Please enter your favorite color'

        # I use this method to store configuration parameters in a list
        $Config =@{FirstName=$first_name;
                    LastName=$last_name;
                    FavoriteColor=$favorite_color}
        
        # write parameters to file
        $Config | export-clixml "$PathRoot\configuration.xml"

        return $Config
    }
    
    # if there is an existing file, load the parameters
    else {
        
        "loading configuration ..."
        $Config = Import-Clixml "$PathRoot\configuration.xml"

        return $Config
    }
}

function Get-Secret () {
    
    # check if secure file already exists, if not create one
    if (!([System.IO.File]::Exists("$PathRoot\secret.cred"))) {
        
        $secret = Read-Host "Enter a secret word, code or phrase longer than 10 characters"
        $secret | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File "$PathRoot\secret.cred" -Force

        return $secret
    }
    else {
        
        $secret_encrypted = Get-Content "$PathRoot\secret.cred" | ConvertTo-SecureString
        $secret = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR((($secret_encrypted))))

        return $secret
    }
}

# run Get-Config - Creates and Retrieves configuration files
$Config = Get-PlainText $PSScriptRoot

# plain text results
"First name is " + $Config.FirstName
"Last name is " + $Config.LastName
"Favorite color: " + $Config.FavoriteColor

# run Get-Secret - Creates and Retrieves Secure Strings from file, good for API keys
$Secret = Get-Secret $PSScriptRoot

# I added some logic to the output to only show last 5 characters
'The last five characters of your secret are ...' + $Secret.Substring($Secret.Length - 5, 5)
