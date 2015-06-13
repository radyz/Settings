# Defining custom prompt message
function prompt {
    # Get command issue time
    $time = (Get-Date).ToString("HH:mm:ss")

    # Get current path
    $folderPath = Get-Location
    
    # Write time, name, current path to output 
    Write-Host("[$time] ") -nonewline -ForegroundColor 	Yellow
    Write-Host("{$env:COMPUTERNAME} ") -nonewline -ForegroundColor Green
    Write-Host("$folderPath") -nonewline
    
    return "> "  
}
