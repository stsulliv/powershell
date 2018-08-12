Scripts use PowerShell Invoke-RestMethod to GET json result from REST API.

Two Versions of script (no auth and auth)
---
get-json-from-rest-api.ps1
- uses function Get-Variables that stores or loads script variables
- see https://ugliscripts.com/storing-script-variables for details on 

get-json-from-rest-api-with-auth.ps1
- uses function Get-Variables that stores or loads script variables
- see https://ugliscripts.com/storing-script-variables for details on Get-Variables
- uses function Get-Secret that stores or loads a string securely
- see https://ugliscripts.com/storing-secure-strings for details on Get-Secret
