# Load posh-git module from current directory
Import-Module posh-git

# Defining custom prompt message
function global:prompt {
    # Get command issue time
    $time = (Get-Date).ToString("HH:mm")

    # Get current path
    $folderPath = Get-Location
    
    # Write time, name, current path to output 
    Write-Host("$time $env:COMPUTERNAME $folderPath") -nonewline

    Write-VcsStatus      
    
    $global:LASTEXITCODE = $realLASTEXITCODE
    return "> "  
}

# Defining Project's folder path
$DevPath = "C:\Development"

# Get DTE instance
# $dte = [runtime.interopservices.marshal]::GetActiveObject("visualstudio.dte")