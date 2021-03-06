<#
  .Synopsis
  Removes the critical JndiLookup.class from a jar file 
  .Notes
  This script is only for experimental purpose and a kind of case study
  The recommended action is either setting Dlog4j2.formatMsgNoLookups=True or update to version > 2.1.15
  Last Update: 12/27/21
#>

<#
  .Synopsis
  Writes a formatted line of text to a log file
#>
function Write-Log
{
  [CmdletBinding()]
  param([String]$Message)
  $LogPath = Join-Path -Path $PSScriptRoot -ChildPath ("Log4JCleanerV1_{0:dd_MM_yy}.log" -f (Get-Date))
  $Message = "*** [{1}][{0:HH:mm - dd/MM/yy}] $Message ***" -f (Get-Date), (hostname)
  Add-Content -Path $LogPath -Value $Message -Encoding UTF8 -WhatIf:$false
  Write-Verbose -Message $Message
}

<#
  .Synopsis
  Removes the JndiLookup.class from a jar file that meets the version criteria
#>
function Remove-Log4JClass
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    param([Parameter(Mandatory=$true, ValueFromPipeline=$true)][String[]]$SearchPath)
    begin
    {
      Import-LocalizedData -BindingVariable MsgBinding -FileName messages.psd1
      $Result = "OK"
      Write-Log $MsgBinding.msg1
      $FixCounter = 0
    }
    process
    {
      try {
        # Iterate to all path'es provided by the SearchPath parameter
        foreach($Path in $SearchPath)
        {
          $msg2 = $MsgBinding.msg2 -f $Path
          Write-Verbose -Message $msg2
          # Check for Jar-Files in the directories provided by path
          $JarFiles = Get-ChildItem -Path $Path/log4j-core-*.jar -File -Recurse -ErrorAction Ignore
          # Any jar files found?
          $JarFiles.forEach{
            $msg3 = $MsgBinding.msg3 -f $_.Name
            Write-Log -Message $msg3
            # Check the jar name and get the version number
            $Pattern = "log4j-core-([\d.]+)\.jar"
            if ([RegEx]::Match($_.Name, $Pattern)) {
              $Version = [Regex]::Match($_.Name, $Pattern).Groups[1].Value
              # threat $Major/$Minor as numbers for comparison as [Int]
              [Int]$Major = ($Version -split "\.")[0]
              [Int]$Minor = ($Version -split "\.")[1]
              $msg6 = $MsgBinding.msg6 -f $Version
              Write-Log -Message  $msg6
              # bad version number?
              if ($Major -eq 2 -and $Minor -lt 15) {
                # create a new temp directory
                $tmpDir = [Environment]::GetEnvironmentVariable("TMPDIR")
                $tmpDir = Join-Path -Path $tmpDir -ChildPath "jartest"
                # got error with mkdir on MacOS
                New-Item -path $tmpDir -ItemType Directory -ErrorAction Ignore
                $msg4 = $MsgBinding.msg4 -f $tmpDir
                Write-Log -Message  $msg4
                # clean it first if it already had existed
                remove-item -Path $tmpDir/* -Force -Recurse
                $msg5 = $MsgBinding.msg5 -f $_.FullName
                Write-Log -Message $msg5
                # expand the jar file into the temp directory
                # Force-Parameter necessary - ignore the "Failed to create file"-errors
                expand-archive -Path $_.FullName -DestinationPath $tmpDir -ErrorAction Ignore -Force
                # Delete critical class file if no whatif or confirm:$false set
                if ($PSCmdlet.ShouldProcess("Log4j-core.jar", "Remove"))
                {
                  # Remove class file from temp-dictionary
                  $RemoveFileName = "org/apache/logging/log4j/core/lookup/JndiLookup.class"
                  Remove-Item -Path $tmpDir/$RemoveFileName
                  $msg7 = $MsgBinding.msg7 -f $RemoveFileName
                  Write-Log -Message $msg7
                  # Put the jar file together at its original place without the forbidden file
                  # This can take a while - important: don't use -Update but -Force
                  $JarPath = $_.FullName
                  Compress-Archive -Path $tmpDir -DestinationPath $JarPath -Force
                  $msg8 = $MsgBinding.msg8 -f $JarPath
                  Write-Log -Message $msg8
                  # Count number of fixed jars
                  $FixCounter++
                }
              }
            }
          }
        }
      }
      catch {
        $msg10 = $MsgBinding.msg10 -f $_
        Write-Log -Message $msg0
        Write-Warning $msg10
        $Result = "Error"
      }
    }
    end
    {
        # correct output;)
        switch($FixCounter)
        {
          0 { $msg9 = $MsgBinding.msg9A }
          1 { $msg9 = $MsgBinding.msg9B }
          default { $msg9 = $MsgBinding.msg9 -f $FixCounter }
        }
        Write-Log -Message $msg9
        # Only needed for pester tests - its either OK or Error
        $Result
    }
}
