# import modules
Import-Module ActiveDirectory

# Update, add or remove variable to come up with the application URL you need
$ptr_host = 'app.example.com'
$ptr_list = '8'
$ptr_auth = '111a1111-2223-333e-4ea4-55555555ee5e'

# assemble the application URL
# Sample URL format is 'https://app.example/api/lists/4/members.json'
$app_url = "https://$ptr_host/api/lists/$ptr_list/members.json"

# required to get around Certificate errors
$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

# build headers for the REST API Authentication
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", $ptr_auth)
    
# GET the members of the LIST
Invoke-RestMethod -Method Get -Uri $app_url -Headers $headers
