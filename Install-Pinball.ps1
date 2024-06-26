
# Install-Pinball.ps1
# This script installs Windows XP's Pinball on Windows 10 or 11 by extracting the files from the Windows XP CD or ISO.
# 
# Minimal Instructions: Insert a Windows XP CD or right-click and mount the ISO.
# Note the path to the /i386 folder.
# Run this script as an administrator with that source path as the parameter.
# Install-Pinball.ps1 -SourcePath D:\i386
# This installs the Space Cadet Pinball game to C:\Program Files (x86)\Space Cadet Pinball
# and creates Start menu shortcut.
# 
# Optional instructions. 
# To install without administrator rights, specify a user writable destination folder 
# with the -DestinationFolder parameter
# Install-Destination.ps1 -SourcePath D:\i386 -DestinationFolder "C:\users\egreene\pinball"
# 
# Elizabeth Greene 2024 <elizabeth.a.greene@gmail.com>
# v1.0
# https://github.com/ElizabethGreene/Install-Pinball
#
# License details:
# Microsoft's Pinball is not free software.  To install and run it you should have a license from Microsoft.
# This installer program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 2 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
##############################################################################
param (
    [Parameter(Mandatory = $true)]
    [string]$SourcePath = "D:\i386",
    [string]$DestinationFolder = "C:\Program Files (x86)\Space Cadet Pinball"
)

$isadmin = $false
# Check if the script is running elevated/as an administratorand warn about the destination folder.
if (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $isadmin = $true
} else {
    if ($DestinationFolder -eq "C:\Program Files (x86)\Space Cadet Pinball") {
        Write-Host "This script must be run as an administrator to install to $DestinationFolder" -ForegroundColor Red
        Write-Host "To install without administrator rights, specify a user writable destination folder with the -DestinationFolder parameter." -ForegroundColor Yellow
        Write-Host "e.g. Install-Pinball.ps1 -SourcePath $SourcePath -DestinationFolder C:\users\egreene\pinball" -ForegroundColor Yellow
        exit
    }
}


# Check if the source path exists
if (-not (Test-Path $SourcePath)) {
    Write-Host "Source path not found: $SourcePath" -ForegroundColor Red
    exit
}

# Define the list of files
$FileList = @(
    "FONT.DAT",
    "PINBALL.DAT",
    "PINBALL.exe",
    "PINBALL.MID",
    "PINBALL2.MID",
    "SOUND1.WAV",
    "SOUND3.WAV",
    "SOUND4.WAV",
    "SOUND5.WAV",
    "SOUND6.WAV",
    "SOUND7.WAV",
    "SOUND8.WAV",
    "SOUND9.WAV",
    "SOUND12.WAV",
    "SOUND13.WAV",
    "SOUND14.WAV",
    "SOUND16.WAV",
    "SOUND17.WAV",
    "SOUND18.WAV",
    "SOUND19.WAV",
    "SOUND20.WAV",
    "SOUND21.WAV",
    "SOUND22.WAV",
    "SOUND24.WAV",
    "SOUND25.WAV",
    "SOUND26.WAV",
    "SOUND27.WAV",
    "SOUND28.WAV",
    "SOUND29.WAV",
    "SOUND30.WAV",
    "SOUND34.WAV",
    "SOUND35.WAV",
    "SOUND36.WAV",
    "SOUND38.WAV",
    "SOUND39.WAV",
    "SOUND42.WAV",
    "SOUND43.WAV",
    "SOUND45.WAV",
    "SOUND49.WAV",
    "SOUND49D.WAV",
    "SOUND50.WAV",
    "SOUND53.WAV",
    "SOUND54.WAV",
    "SOUND55.WAV",
    "SOUND57.WAV",
    "SOUND58.WAV",
    "SOUND65.WAV",
    "SOUND68.WAV",
    "SOUND104.WAV",
    "SOUND105.WAV",
    "SOUND108.WAV",
    "SOUND111.WAV",
    "SOUND112.WAV",
    "SOUND131.WAV",
    "SOUND136.WAV",
    "SOUND181.WAV",
    "SOUND240.WAV",
    "SOUND243.WAV",
    "SOUND528.WAV",
    "SOUND560.WAV",
    "SOUND563.WAV",
    "SOUND713.WAV",
    "SOUND735.WAV",
    "SOUND827.WAV",
    "SOUND999.WAV",
    "table.bmp",
    "wavemix.inf"
)

# Use the file list to create a hash table to store the compressed and uncompressed file names.
$RequiredFiles = @{}
# Example: Font.dat is Wfont.da_ in the source path.
$FileList | ForEach-Object {
    #Replace the last character with an underscore and add a W to the beginning.
    $RequiredFiles[$_] = "W" + $_.Substring(0, $_.Length - 1) + "_"
}

# Check if the required files are present in the source path.
$MissingFiles = $RequiredFiles.Values | Where-Object { -not (Test-Path "$SourcePath\$_") }

if ($MissingFiles.Count -gt 0) {
    Write-Host "The following required files were not found in the source path:" -ForegroundColor Red
    $MissingFiles | ForEach-Object { Write-Host $_ -ForegroundColor Red }
    exit
}

# Make the Destination folder exists, and create it if it does not already exist.
if (-not (Test-Path $DestinationFolder)) {
    New-Item -Path $DestinationFolder -ItemType Directory | Out-Null
}

# Use the built-in Windows expand command to extract the files and then rename them to the correct filename
# Example: expand g:\i386\Wfont.da_ -F:font.dat "C:\Program Files (x86)\Space Cadet Pinball"
# creates wfont.da_ in the destination and then we rename it to font.dat

foreach ($DestinationFile in $RequiredFiles.Keys) {
    $SourceFile = "$SourcePath\$($RequiredFiles[$DestinationFile])"
    Write-Host "Expanding $SourceFile to $DestinationFolder"
    expand $SourceFile -F:$DestinationFile "$DestinationFolder"
    # Rename the file to the correct name.
    Rename-Item "$DestinationFolder\$($RequiredFiles[$DestinationFile])" "$DestinationFolder\$DestinationFile"
}

# Create a start menu shortcut
if (-not $SkipStartMenuShortcut) {

    # The default destination folder is the All Users start menu folder.
    $ShortcutFolder = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs"

    #... but if the script is not running as an administrator, use the user's start menu folder.
    if (-not $isadmin) {
        $ShortcutFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs"
    }
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$ShortcutFolder\Pinball.lnk")
    $Shortcut.TargetPath = "$DestinationFolder\PINBALL.exe"
    $Shortcut.Save()
}
