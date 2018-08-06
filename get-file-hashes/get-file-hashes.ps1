# script accepts one parameter, the full file path to be hashed.

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True,Position=0)][ValidateNotNullOrEmpty()]
        [string]$filepath
)

Get-FileHash $filepath -Algorithm MD5

Get-FileHash $filepath -Algorithm SHA1

Get-FileHash $filepath -Algorithm SHA256

Get-FileHash $filepath -Algorithm SHA384

Get-FileHash $filepath -Algorithm SHA512

Get-FileHash $filepath -Algorithm MACTripleDES

Get-FileHash $filepath -Algorithm RIPEMD160

Exit
