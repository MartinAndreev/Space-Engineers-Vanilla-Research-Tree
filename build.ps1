param(
    [int]$IntervalMinutes = 0  # Set to 0 for one-time build, >0 for periodic builds
)

function Get-Emoji([string]$Hex) {
    return [System.Char]::ConvertFromUtf32([System.Convert]::ToInt32($Hex, 16))
}

function Test-XmlFiles([string]$Source, [string[]]$Files) {
    $xmlExtensions = @('.xml', '.sbc', '.sbl', '.resx', '.mod', '.sbmi')
    $settings = [System.Xml.XmlReaderSettings]::new()
    $settings.DtdProcessing = [System.Xml.DtdProcessing]::Prohibit
    $settings.XmlResolver = $null

    foreach ($file in $Files) {
        if ([System.IO.Path]::GetExtension($file) -notin $xmlExtensions) {
            continue
        }

        $reader = $null
        try {
            $reader = [System.Xml.XmlReader]::Create((Join-Path $Source $file), $settings)
            while ($reader.Read()) { }
        }
        catch {
            throw "XML validation failed in '$file': $($_.Exception.GetBaseException().Message)"
        }
        finally {
            if ($null -ne $reader) {
                $reader.Dispose()
            }
        }
    }
}

function Run-Build {
    $Check = Get-Emoji "2714"   # ✅
    $Clock = Get-Emoji "23F0"   # ⏰
    $Hammer = Get-Emoji "1F528" # 🔨

    Write-Host "$Hammer Running build at $(Get-Date -Format 'T')..."

    $Source = Get-Location
    $Destination = Join-Path $Source ".build"

    # Get a list of all tracked and untracked-but-not-ignored files
    $files = git ls-files --cached --others --exclude-standard

    # Exclude build.ps1 and anything inside .git
    $files = $files | Where-Object {
        ($_ -ne "build.ps1") -and ($_ -notlike ".git/*") -and ($_ -notlike ".github/*")
    }

    # Validate before changing the previous build or its symlink.
    Test-XmlFiles -Source $Source -Files $files
    Write-Host "$Check XML validation passed"

    # Ensure .build folder exists and is empty
    if (Test-Path $Destination) {
        Remove-Item $Destination -Recurse -Force
    }
    New-Item -ItemType Directory -Path $Destination | Out-Null

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

    Write-Host "$Check Build folder created at $Destination"

    # Create symlink to Space Engineers Mods folder
    $modsFolder = Join-Path $env:APPDATA "SpaceEngineers\Mods"
    $linkPath = Join-Path $modsFolder "Vanilla Research Tree - Reworked"

    if (Test-Path $linkPath) {
        Remove-Item $linkPath -Recurse -Force
    }

    New-Item -ItemType SymbolicLink -Path $linkPath -Target $Destination | Out-Null
    Write-Host "$Check Symlink created at $linkPath"
}

# --- Main Execution Loop ---
do {
    $Clock = Get-Emoji "23F0"   # ⏰
    try {
        Run-Build
    }
    catch {
        if ($IntervalMinutes -le 0) {
            throw
        }
        Write-Warning "Build failed: $($_.Exception.Message)"
    }
    if ($IntervalMinutes -gt 0) {
        Write-Host "$Clock Waiting $IntervalMinutes minutes before next build..."
        Start-Sleep -Seconds ($IntervalMinutes * 60)
    }
} while ($IntervalMinutes -gt 0)
