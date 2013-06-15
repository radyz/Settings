$dte = [runtime.interopservices.marshal]::GetActiveObject("VisualStudio.DTE.11.0")

function New-VSFile 
{
    Param(
        [Parameter(Mandatory=$true, Position=1)]
        [string]$fileName,
        [Parameter(Position=2)]
        [string]$filePath
    )

    #let's add file templates on a per use basis
    $commonTemplates = @{
        ".cs" = "Class,CSharp";
        ".html" = "Html, Html";
    }
    
    $extension = [System.IO.Path]::GetExtension($fileName)
    $fileType, $fileLang = $commonTemplates[$extension] -split ","
    $vsTemplate = $dte.Solution.GetProjectItemTemplate($fileType, $fileLang)              
    
    #Default path if one is not specified
    # 1. Path
    if ($filePath)
    {
        $vsCurrentProject = $dte.ActiveDocument.ProjectItem.ContainingProject.ProjectItems.AddFromDirectory($filePath)
    }
    # 2. Same as the current opened file
    if ($dte.ActiveDocument)
    {
        $vsCurrentProject = $dte.ActiveDocument.ProjectItem.ContainingProject        
    }
    # 3. Startup project
    else 
    {
        $vsCurrentProject = Get-Project        
    }

    $vsCurrentProject.ProjectItems.AddFromTemplate($vsTemplate, $fileName)    
}