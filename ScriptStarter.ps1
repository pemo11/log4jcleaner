<#
 .Synopsis
 Run the Log4J fixing function
 .Description
 Uses either the supplied values or the values from the Script.config file
#>

# Load the psm1 file first
$Psm1Path = Join-Path -Path $PSScriptRoot -ChildPath "Log4ShellFixV1.psm1"

# use the force because otherwise the module would have to be removed first every time
Import-Module -Name $Psm1Path -Force

# Load app.config - if exists
$ConfigPath = Join-Path -Path $PSScriptRoot -ChildPath "Script.config"
if (Test-Path -Path $ConfigPath)
{
    $Config = Import-PowerShellDataFile -Path $ConfigPath
    $JarDirPath = $Config.JarDir
}
else 
{
    $JarDirPath = Join-Path -Path $PSScriptRoot -ChildPath demo
}

Remove-Log4JClass -SearchPath $JarDirPath -Verbose # -Whatif

