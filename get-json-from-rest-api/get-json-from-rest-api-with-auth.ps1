# function stores or loades files variables depending on if variables.xml exists
# see https://ugliscripts.com/storing-script-variables for details on Get-Variables
function Get-Variables ($path) {
    
    # check if variables.xml already exists, if not create it
    if (!([System.IO.File]::Exists("$path\variables.xml"))) {
        
        Write-Host 'storing configuration ...'
        
        $ptr_host = Read-Host 'Please enter the FQDN or IP of your PTR host'
        $ptr_listId = Read-Host 'Please enter the Threat Response list number'

        # use a HashTable to store configuration parameters
        $HashTable =@{ptrHost=$ptr_host;
                    ptrListId=$ptr_listId}
        
        # write HashTable to XML
        $HashTable | export-clixml "$path\variables.xml"

        return $HashTable
    }

    # if there is an existing file, load the variables
    else {
        
        Write-Host 'loading configuration ...'
        
        $HashTable = Import-Clixml "$path\variables.xml"

        return $HashTable
    }
}

# function stores a string securely
# see https://ugliscripts.com/storing-secure-strings for details on Get-Secret 
function Get-Secret ($path) {
    
    # check if secure file already exists, if not create one
    if (!([System.IO.File]::Exists("$path\secret.cred"))) {
        
        Write-Host 'storing secret ...'

        $secret = Read-Host 'Enter your Threat Response API Key'
        $secret | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File "$path\secret.cred" -Force

        return $secret
    }
    else {
        
        Write-Host 'loading secret ...'
        
        $secret_encrypted = Get-Content "$path\secret.cred" | ConvertTo-SecureString
        $secret = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR((($secret_encrypted))))

        return $secret
    }
}

# run Get-Variables - returns HashTable of parameters
# $PSScriptRoot is current script directory
$HashTable = Get-Variables $PSScriptRoot

$ptr_host = $HashTable.ptrHost
$ptr_listId = $HashTable.ptrListId

# run Get-Secret - returns stored secret
$ptr_apiKey = Get-Secret $PSScriptRoot

# assemble the application URL
# Sample URL format is 'https://app.example/api/lists/4/members.json'
$app_url = "https://$ptr_host/api/lists/$ptr_listId/members.json"

# required to get around Certificate errors
$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

# build headers for the REST API Authentication
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", $ptr_apiKey)
    
# GET the members of the LIST
Invoke-RestMethod -Method Get -Uri $app_url -Headers $headers

exit
