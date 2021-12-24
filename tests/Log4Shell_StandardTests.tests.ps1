<#
 .Synopsis
 Simple Tests for the basic functionality
#>

#requires -modules @{ModuleName="pester";RequiredVersion="5.3.1"}

$Psm1Path = Join-Path -Path $PSScriptRoot -ChildPath "../Log4ShellFixV1.psm1"
Import-Module -Name $Psm1Path -Force

describe "Simple tests" {

    # Initialize once for all tests
    BeforeEach {
        $JarDirPath = Join-Path -Path $PSScriptRoot -ChildPath "test-jar"
        # $JarPath = Join-Path -Path $PSScriptRoot -ChildPath "app.class"
        mkdir $JarDirPath -ErrorAction Ignore
        # compress-archive -path $JarPath -Destinationpath $JarDirPath/App.jar -Force
        $JarPath = Join-Path -Path $PSScriptRoot -ChildPath "../demo/log4j-core-2.3.jar"
        copy-item -Path $JarPath -Destination $JarDirPath
    }

    it "returns something" {
        $TestPath = $PSScriptRoot
        $Result = Remove-Log4JClass -SearchPath $TestPath -WhatIf
        $Result | Should -be "OK"
    }
}
