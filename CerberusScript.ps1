#exporrt a backup of cerberus (tools> export)
#To generate a list of user with public shares run 
#select-string ns1:sharedBy .\<Cerberus backup .xml file> | out-file -filepath .\CerberusUserList.txt
#This will need to be trimmed to just the AD names

#Get-email uses the above list of AD users to build the coresponding list of emails pulled from AD
function Get-email {
    $users = ForEach ($user in $(Get-Content C:\Users\$env:UserName\Documents\CerberusUserList.txt)) {

        Get-AdUser $user -Properties Mail     
    }
    
     $users.mail | Out-File "C:\Users\$env:UserName\Documents\useremail.txt"   
}

#Update-Shares uses the list of users and list of emails to update the Cerberus public share list with the users email to deal with the %HOME issue
function Update-Shares {
    $adusers = get-content 'C:\Users\$env:UserName\Documents\CerberusUserList.txt'
    $emailusers = get-content 'C:\Users\$env:UserName\Documents\useremail.txt'

    $count = 0

    foreach ($email in $emailusers) {
        ((Get-Content -path C:\Users\$env:UserName\Documents\<Cerberus backup .xml file>) -replace $adusers[$count], $emailusers[$count]) | Set-Content -Path C:\Users\$env:UserName\Documents\<Cerberus backup .xml file>
        $adusers[$count]
        $emailusers[$count]
        $count ++
        $count
    }
}

#correct folders will need to be made 
# this renames folders to email addresses
function rename-directory {
    $adusers = get-content 'C:\Users\$env:UserName\Documents\<list of ad usernames that have folders with the old name (AD)>'
    $emailusers = get-content 'C:\Users\$env:UserName\Documents\<list of the emails to replace the ad name with>'

    $count = 0

    foreach ($email in $emailusers) {
        $user = $adusers[$count]
        $email = $emailusers[$count]
        "C:\Users\$env:UserName\Documents\$user"
        Rename-Item C:\Users\$env:UserName\Documents\$adusers C:\Users\$env:UserName\Documents\$emailusers
        $count
        $count ++
    }
}

#Files will need to be moved somehow
#this function copies the files 
function Update-Directory {
    $adusers = get-content 'C:\Users\$env:UserName\Documents\Public files powershell\Copying files\userFolderstest.old.txt'
    $emailusers = get-content 'C:\Users\$env:UserName\Documents\Public files powershell\Copying files\userEmailstest.old.txt'

    $count = 0

    foreach ($email in $emailusers) {
        $user = $adusers[$count]
        $email = $emailusers[$count]
        "C:\Users\$env:UserName\Documents\$user"
        Copy-Item "C:\Users\$env:UserName\Documents\$user\*" -Destination "C:\Users\$env:UserName\Documents\$email\"
        $count
        $count ++
    }
}

# Menu

function Show-Menu
{
     param (
           [string]$Title = 'Cerberus FTP script '
     )
     cls
     Write-Host "================ $Title ================"
    
     Write-Host "1: Press '1' to get emails from the list of Cerberus AD users."
     Write-Host "2: Press '2' to update the public share links with the email addresses."
     Write-Host "3: Press '3' rename the users home folders to match the new links."
     Write-Host "4: Press '4' to copy the folder contents of the AD named folder for any folders that couldnt be renamed due to having both AD and email variants"
     Write-Host "Q: Press 'Q' to quit."
}

do
{
     Show-Menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' {
                cls
                'Generating list of emails associated with the AD users...'
                Get-email
           } '2' {
                cls
                'Updating the public share links with the users email address...'
                Update-Shares
           } '3' {
                cls
                'Renaming folders that did not have an email variant'
                rename-directory
           } '4' {
                cls
                'Copying files for folders that already had an email variant'
                Update-Directory
           }
            'q' {
                return
           }
     }
     pause
}
until ($input -eq 'q')

