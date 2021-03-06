param (
)

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

$PSScriptFilePath = (Get-Item $MyInvocation.MyCommand.Path).FullName
$BuildRoot = Split-Path -Path $PSScriptFilePath -Parent
$SolutionRoot = Split-Path -Path $BuildRoot -Parent

$StandaloneCoreVersion = '1.1.0'
$StandaloneCoreFileName = "pact-$StandaloneCoreVersion-win32"
$OutputPath = Join-Path $SolutionRoot -ChildPath 'PactNet\Core\standalone'
$Client = New-Object System.Net.WebClient


$StandaloneCoreFilePath = "$OutputPath\$StandaloneCoreFileName.zip"
$StandaloneCoreDownload = "https://github.com/pact-foundation/pact-ruby-standalone/releases/download/v$StandaloneCoreVersion/$StandaloneCoreFileName.zip";

If(!(Test-Path $OutputPath))
{
	New-Item -ItemType directory -Path $OutputPath | Out-Null
}

Write-Output "Downloading the Standalone Core from '$StandaloneCoreDownload'..."
$Client.DownloadFile($StandaloneCoreDownload, $StandaloneCoreFilePath)
Write-Output "Done"

Write-Output "Unzipping the Standalone Core..."
Unzip "$StandaloneCoreFilePath" "$OutputPath"
Remove-Item $StandaloneCoreFilePath
Write-Output "Done"
