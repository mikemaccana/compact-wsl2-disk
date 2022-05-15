$ErrorActionPreference = "Stop"

# The array containing the files to compress
$files = @()
# The folders where to look for files
$wsl_folders = @(
    # WSL OSes from the Windows Store
    "$env:LOCALAPPDATA\Packages",
    # The Docker WSL files
    "$env:LOCALAPPDATA\Docker"
)
# Allow user definitions via an environment variable, WSL_FOLDERS
if (Test-Path env:WSL_FOLDERS) {
    # Assume folders are formatted as PATH
    $env:WSL_FOLDERS.Split(";") | ForEach-Object {
        Write-Output " - Additional user path: $PSItem"
        $wsl_folders += $PSItem
    }
}

# Find the files in all the authorized folders
foreach ($wsl_folder in $wsl_folders) {
    Get-ChildItem -Recurse -Path $wsl_folder -Filter "ext4.vhdx" -ErrorAction SilentlyContinue | ForEach-Object {
        $FullPath = $PSItem.FullName
        Write-Output "- Found EXT4 disk: $FullPath"
        $files += ${PSItem}
    }
}

if ( $files.count -eq 0 ) {
  throw "We could not find a file called ext4.vhdx in $env:LOCALAPPDATA\Packages or $env:LOCALAPPDATA\Docker or '$env:WSL_FOLDERS'"
}

write-output " - Found $($files.count) VHDX file(s)"
write-output " - Shutting down WSL2"

# See https://github.com/microsoft/WSL/issues/4699#issuecomment-722547552
wsl -e sudo fstrim /
wsl --shutdown

foreach ($file in $files) {
	$disk = $file.FullName
	write-output "-----"
	write-output "Disk to compact: $($disk)"
	write-output "Length: $($file.Length/1MB) MB"
	write-output "Compacting disk (starting diskpart)"

@"
select vdisk file='$disk'
attach vdisk readonly
compact vdisk
detach vdisk
exit
"@ | diskpart

	write-output ""
	write-output "Success. Compacted $disk."
	write-output "New length: $((Get-Item $disk).Length/1MB) MB"

}
write-output "======="
write-output "Compacting of $($files.count) file(s) complete"
