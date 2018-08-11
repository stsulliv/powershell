# storing-script-variable.ps1 - Sample script to store and load a file with variables

# function stores or loades files variables
function Get-Variables ($PathRoot) {
    
    # check if the file already exists, if not create it
    if (!([System.IO.File]::Exists("$PathRoot\variables.xml"))) {
        
        Write-Host 'storing configuration ...'
        
        $first_name = Read-Host 'Please enter your first name'
        $last_name = Read-Host 'Please enter your last name'
        $favorite_color = Read-Host 'Please enter your favorite color'

        # use a HashTable to store configuration parameters
        $Config =@{FirstName=$first_name;
                    LastName=$last_name;
                    FavoriteColor=$favorite_color}
        
        # write HashTable to XML
        $Config | export-clixml "$PathRoot\variables.xml"

        return $Config
    }

    # if there is an existing file, load the variables
    else {
        
        Write-Host 'loading configuration ...'
        
        $Variables = Import-Clixml "$PathRoot\variables.xml"

        return $Variables
    }
}

################################# Starting Main Script #################################

# run Get-Config - returns HashTable of parameters
# $PSScriptRoot is current script directory

$Variables = Get-Variables $PSScriptRoot

# access data using $Config.<parameter>

Write-Host "First name is" $Variables.FirstName
Write-Host "Last name is" $Variables.LastName
Write-Host "Favorite color:" $Variables.FavoriteColor

Exit
