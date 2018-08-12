# powershell script to store and load variables from an external file

# function stores or loades files variables depending on if variables.xml exists
function Get-Variables ($FilePath) {
    
    # check if variables.xml already exists, if not create it
    if (!([System.IO.File]::Exists("$FilePath\variables.xml"))) {
        
        Write-Host 'storing configuration ...'
        
        $first_name = Read-Host 'Please enter your first name'
        $last_name = Read-Host 'Please enter your last name'
        $favorite_color = Read-Host 'Please enter your favorite color'

        # use a HashTable to store configuration parameters
        $HashTable =@{FirstName=$first_name;
                    LastName=$last_name;
                    FavoriteColor=$favorite_color}
        
        # write HashTable to XML
        $HashTable | export-clixml "$FilePath\variables.xml"

        return $HashTable
    }

    # if there is an existing file, load the variables
    else {
        
        Write-Host 'loading configuration ...'
        
        $HashTable = Import-Clixml "$FilePath\variables.xml"

        return $HashTable
    }
}

################################# Starting Main Script #################################

# run Get-Variables - returns HashTable of parameters
# $PSScriptRoot is current script directory

$HashTable = Get-Variables $PSScriptRoot

# access data using $Config.<parameter>

Write-Host "First name is" $HashTable.FirstName
Write-Host "Last name is" $HashTable.LastName
Write-Host "Favorite color:" $HashTable.FavoriteColor

Exit
