$ProgressPreference = 'SilentlyContinue'
$PodmanVersion="4.0.2"
$PodmanDownloadUri="https://github.com/containers/podman/releases/download/v4.0.2/podman-remote-release-windows_amd64.zip"

$OriginalLocation=$(Get-Location)

function Add-Path {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $PathToAdd
    )

    [System.Environment]::SetEnvironmentVariable(
        "Path",
        "$([System.Environment]::GetEnvironmentVariable("Path",[System.EnvironmentVariableTarget]::User));${PathToAdd}",
        [System.EnvironmentVariableTarget]::User)
}

function Install-OnWindows {
    # Name the zip
    $PodmanZip = "podman-win64.zip"
    # Download from github.com
    Write-Host "Downloading .zip"
    Invoke-WebRequest -Uri $PodmanDownloadUri -OutFile $PodmanZip
    # Unzip
    Write-Host "Extracting .zip"
    Expand-Archive -Path $PodmanZip -DestinationPath "."
    # Cleanup
    Write-Host "Deleting .zip as it's no longer needed"
    Remove-Item $PodmanZip
    Set-Location ".\podman-${PodmanVersion}\usr\bin"
    # Add to user's path (not system's)
    Write-Host "Adding to user's Path"
    Add-Path -PathToAdd $(Get-Location)
    Set-Location $OriginalLocation
}

if (($true -eq $IsLinux) -or ($true -eq $IsMacOS)) {
    Write-Host "Script is not supported on Linux and MacOS."
    exit
}
else {
    Write-Host "Installing Podman ${PodmanVersion}"
    Install-OnWindows
}