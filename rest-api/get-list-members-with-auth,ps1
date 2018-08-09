# import modules
Import-Module ActiveDirectory

# required to get around Certificate errors
$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

# build headers for the REST API Authentication
# pair 'Authorization' with Application key
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", '111a1111-2223-333e-4ea4-55555555ee5e')
    
# GET the members of the LIST
# add headers to include authentication $headers with request
Invoke-RestMethod -Method Get -Uri 'https://app.example.com/api/lists/8/members.json' -Headers $headers
