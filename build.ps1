# Copy files to .build folder while respecting .gitignore
# Run this script from the root of your repository

$Source = Get-Location
$Destination = Join-Path $Source ".build"

# Ensure .build folder exists and is empty
if (Test-Path $Destination) {
    Remove-Item $Destination -Recurse -Force
}
New-Item -ItemType Directory -Path $Destination | Out-Null

# Get a list of all tracked and untracked-but-not-ignored files
$files = git ls-files --cached --others --exclude-standard

# Exclude build.ps1 and anything inside .git
$files = $files | Where-Object {
    ($_ -ne "build.ps1") -and ($_ -notlike ".git/*")
}

foreach ($file in $files) {
    $sourcePath = Join-Path $Source $file
    $destPath = Join-Path $Destination $file

    # Create destination directory if needed
    $destDir = Split-Path $destPath -Parent
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir | Out-Null
    }

    # Copy file
    Copy-Item $sourcePath $destPath -Force
}

$EmojiIcon = [System.Char]::ConvertFromUtf32([System.Convert]::toInt32("2714",16))

Write-Host "$EmojiIcon Build folder created at $Destination"

# Create symlink to Space Engineers Mods folder
$modsFolder = Join-Path $env:APPDATA "SpaceEngineers\Mods"
$linkPath = Join-Path $modsFolder "Vanilla Research Tree - Reworked"

# Remove existing symlink/folder if exists
if (Test-Path $linkPath) {
    Remove-Item $linkPath -Recurse -Force
}

# Create the symlink
New-Item -ItemType SymbolicLink -Path $linkPath -Target $Destination | Out-Null

Write-Host "$EmojiIcon Symlink created at $linkPath"