# import modules
# To connect to active directory we need the AD module.  Powershell includes support for JSON
Import-Module ActiveDirectory

# required to get around Certificate errors
$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
    
# GET the members of the LIST
# Note the Method called is a GET
Invoke-RestMethod -Method Get -Uri 'https://app.example.com/api/lists/5/members.json'
