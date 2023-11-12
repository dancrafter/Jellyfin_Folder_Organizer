# Set the base Movie directory
$baseDirectory = "\\192.168.1.1\Media-Libarary\Movies"

#exclude Directorys 
$exludedDirectorys = "Basic_Movie_Layout"

#Basic Movie Layout Directories
$FolderNames = "behind the scenes","deleted scenes","extras","interviews","shorts","trailers"

#Data retrive Functions
function Show-Menu {
    param (
        [string]$Title = 'Resulution Selection'
    )
    Write-Host "`n================ $Title ================ `n1: Press '1' for 720p `n2: Press '2' for 1080p `n3: Press '3' for 2160p `n2: Press 'q' to quit"
}

function Get-MovieDate {
    Clear-Host
    Write-Host "================ Input Date ================"    
    [int]$GetDate = Read-Host "Input Release Date of $Directory"
    return [string]$GetDate
}


function Get-Resulution {
    Show-Menu
    $GetResulution = Read-Host "Please make a selection"
    switch ($GetResulution) {
        '1' {
        $res = '720p'
        } 
        '2' {
        $res = '1080p'
        } 
        '3' {
        $res = '2160p'
        }
        'q' {
        break
        }

    }
    return [string]$res
}

#Basic Log File creation
function WriteLog
{
    Param ([string]$LogString)
    $LogFile = "$baseDirectory\MovieRenamer.log"
    $DateTime = "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
    $LogMessage = "$Datetime $LogString"
    Add-content $LogFile -value $LogMessage
}

# Get directories matching the criteria
$directories = Get-ChildItem -Path $baseDirectory -Directory | Where-Object {
    $_.BaseName -notmatch ' \(' -and $_.BaseName -notmatch $exludedDirectorys
}

# Process each directory and rename it
ForEach ($directory in $directories) {

    # Prompt the user for a date input
    $GetDate = Get-MovieDate
    $GetResulution = Get-Resulution
    # Creates new Basename
    $newBaseName = $directory.Name -replace '\s','_'

    # Creates the Folder Structure
    ForEach ($FolderName in $FolderNames){
        New-Item -ItemType Directory -Path $baseDirectory\$directory\ -Name $FolderName}

    #renameing the Movie File
    Get-ChildItem -Path $baseDirectory\$directory -File | sort Length | select -Last 1 | Rename-Item -NewName ($newBaseName + ' (' + $GetDate + ') - ' + $GetResulution + ".mkv")
    #renameing the Movie Folder
    rename-item -Path $baseDirectory\$directory –Newname ($newBaseName + ' (' + $GetDate + ')' )  
    #append Logfile
    WriteLog "$directory to $newBaseName ($GetDate) with $GetResulution"
}



