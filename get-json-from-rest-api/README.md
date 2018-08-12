Scripts use PowerShell Invoke-RestMethod to GET json result from REST API.

Two Versions of script (no auth and auth)
---
get-json-from-rest-api.ps1
- function stores or loades files variables depending on if variables.xml exists
- see https://ugliscripts.com/storing-script-variables for details on Get-Variables

get-json-from-rest-api-with-auth.ps1
- function stores or loades files variables depending on if variables.xml exists
- see https://ugliscripts.com/storing-script-variables for details on Get-Variables
- see https://ugliscripts.com/storing-secure-strings for details on Get-Secret
