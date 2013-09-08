function New-IISWebsite
{
 [CmdletBinding()]
 Param(    
    [Parameter(Mandatory=$True)]
    [string]$SiteName,

    [Parameter(Mandatory=$True)]
    [string]$HostHeaders,

    [string]$RootFolder = "c:\Webs"

    

    )

    #Folder structure variables
    $fullPath = [string]::Format("{0}\{1}", $RootFolder, $SiteName)
    $logFolder = [string]::Format("{0}\logs", $fullPath)
    $logReqLogFiles = [string]::Format("{0}\failedReqLogfiles", $logFolder)
    $logFiles = [string]::Format("{0}\logfiles", $logFolder)
    $w3Root = [string]::Format("{0}\wwwroot", $fullPath)
    $folderList = $fullPath, $logFolder, $logReqLogFiles, $logFiles, $w3Root

    #Website variables
    $appPoolName = $SiteName
    $websiteName = $SiteName    
    $appPoolIdentity = [string]::Format("IIS AppPool\{0}", $appPoolName)


    Write-Debug "Creating folder structure"
    Foreach ($folder in $folderList)
    {
        if (!(Test-Path $folder))
        {
            Write-Debug "Folder $folder does not exist, creating..."
            New-Item -ItemType Directory -Path $folder            
        }
    }

    Write-Debug "Creating application pool"
    New-WebAppPool -Name $appPoolName

    Write-Debug "Creating website"
    New-Website -Name $websiteName -ApplicationPool $appPoolName -HostHeader $HostHeaders -PhysicalPath $w3Root

    Write-Debug "Setting Log folder"
    Set-ItemProperty "IIS:\Sites\$siteName" -Name LogFile -Value @{ directory = $logFiles }

    Write-Debug "Setting Trace Failed Requests Logging folder"
    Set-ItemProperty "IIS:\Sites\$siteName" -Name TraceFailedRequestsLogging -Value @{ directory = $logReqLogFiles }

    Write-Debug "Set permissions on root folder"
    Set-IISPermission -AclPath $fullPath -Permissions $appPoolIdentity,"Read","Allow"
    Set-IISPermission -AclPath $fullPath -Permissions "Administrators","FullControl","Allow"
    
}

function Set-IISPermission
{
    [CmdletBinding()]
    Param(
    [Parameter(Mandatory=$True)]
    [string]$AclPath,

    [Parameter(Mandatory=$True)]
    $Permissions
    )

    $acl = Get-Acl -Path $AclPath

    Write-Debug "Create permissions"
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($Permissions)

    Write-Debug "Set permissions"
    $acl.AddAccessRule($rule)
    Set-Acl -Path $AclPath -AclObject $acl

    Get-Acl $AclPath | Format-List
}