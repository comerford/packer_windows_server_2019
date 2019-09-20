<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>

[CmdletBinding()]

param (
    # Target to build with

    [Parameter(Mandatory)]
    [ValidateSet("HyperV","VirtualBox")]
    [string]
    $Target,

    # Uri to ISO file (Path or URL)
    [Parameter(Mandatory)]
    [string]
    $IsoUri = "",

    # Iso Checksum
    [Parameter(Mandatory)]
    [string]
    $IsoChecksum = "",

    # Iso Checksum Type
    [Parameter(Mandatory)]
    [string]
    $ChecksumType= ""
)



if($Target -eq "HyperV"){
    $BuildDirectory = "$PSScriptRoot\Builders\hyperv"    
    $packerFile = Get-ChildItem $BuildDirectory\*.json | ForEach-Object { packer validate --syntax-only $_.FullName }

    Write-Host "Starting HyperV Build" -ForegroundColor cyan

    if($packerFile -like "*check passed*"){
        Write-Host "Packer file has been Validated" -ForegroundColor Green
    } else {
        Write-Host "Packer file invalid, exiting build" -ForegroundColor Red
        break
    }

    packer build -var "iso_url=$IsoUri" -var "iso_checksum=$IsoChecksum" -var "iso_checksum_type=$ChecksumType" $(Get-ChildItem $BuildDirectory\*.json).FullName

    
} else {
    $BuildDirectory = "$PSScriptRoot\Builders\virtualbox"    
    $packerFile = Get-ChildItem $BuildDirectory\*.json | ForEach-Object { packer validate --syntax-only $_.FullName }

    Write-Host "Starting VirtualBox Build" -ForegroundColor Magenta

    Start-Sleep -Seconds 10

    if($packerFile -like "*check passed*"){
        Write-Host "Packer file has been Validated" -ForegroundColor Green
    } else {
        Write-Host "Packer file invalid, exiting build" -ForegroundColor Red
        break
    }

    packer build -var "iso_url=$IsoUri" -var "iso_checksum=$IsoChecksum" -var "iso_checksum_type=$ChecksumType" $(Get-ChildItem $BuildDirectory\*.json).FullName
}