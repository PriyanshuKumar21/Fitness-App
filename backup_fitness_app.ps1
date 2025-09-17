# Fitness App Backup & Cleanup Script
# This script creates a backup of important project files and cleans up old/unnecessary files

# Set timestamp for backup folder
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$backupDir = "C:\Users\mohit\Documents\Projects\fitness_app_backup_$timestamp"

# Create backup directory
Write-Host "Creating backup directory at $backupDir" -ForegroundColor Green
New-Item -ItemType Directory -Path $backupDir | Out-Null

# Define important directories to backup
$importantDirs = @(
    "lib",
    "assets",
    "android\app\src",
    "ios\Runner",
    "windows\runner"
)

# Define important files to backup
$importantFiles = @(
    "pubspec.yaml",
    "pubspec.lock",
    "README.md",
    "analysis_options.yaml",
    "fitness_app.db"
)

# Create directories in backup location
foreach ($dir in $importantDirs) {
    $targetDir = Join-Path -Path $backupDir -ChildPath $dir
    Write-Host "Creating directory structure: $targetDir" -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    
    # Copy files from source to backup
    $sourceDir = Join-Path -Path $PSScriptRoot -ChildPath $dir
    if (Test-Path -Path $sourceDir) {
        Write-Host "Copying files from $sourceDir to $targetDir" -ForegroundColor Cyan
        Copy-Item -Path "$sourceDir\*" -Destination $targetDir -Recurse -Force
    }
}

# Copy important individual files
foreach ($file in $importantFiles) {
    $sourceFile = Join-Path -Path $PSScriptRoot -ChildPath $file
    if (Test-Path -Path $sourceFile) {
        Write-Host "Backing up file: $file" -ForegroundColor Cyan
        Copy-Item -Path $sourceFile -Destination $backupDir -Force
    }
}

# Clean up old files (logs, temporary files, etc.)
Write-Host "Cleaning up old files..." -ForegroundColor Yellow

# Files to delete (using wildcards)
$filesToDelete = @(
    "*.log",
    "flutter_*.txt",
    "error_log.txt",
    "path_output.txt",
    ".dart_tool\flutter_build\*"
)

# Delete files
foreach ($filePattern in $filesToDelete) {
    $files = Get-ChildItem -Path $PSScriptRoot -Filter $filePattern -Recurse -ErrorAction SilentlyContinue
    foreach ($file in $files) {
        Write-Host "Deleting: $($file.FullName)" -ForegroundColor Yellow
        Remove-Item -Path $file.FullName -Force -ErrorAction SilentlyContinue
    }
}

# Clean build directory (optional)
$cleanBuild = Read-Host "Do you want to clean the build directory? (y/n)"
if ($cleanBuild -eq "y") {
    Write-Host "Cleaning build directory..." -ForegroundColor Yellow
    if (Test-Path -Path "build") {
        Remove-Item -Path "build" -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Create a metadata file in the backup
$metadataContent = @"
Fitness App Backup
Created: $(Get-Date)
Source: $PSScriptRoot
Contents:
- Project source code (lib directory)
- Assets (images, fonts, icons)
- Platform-specific code
- Configuration files
"@

Set-Content -Path (Join-Path -Path $backupDir -ChildPath "backup_info.txt") -Value $metadataContent

Write-Host "Backup completed successfully at: $backupDir" -ForegroundColor Green
Write-Host "Old files have been cleaned up." -ForegroundColor Green 