$ErrorActionPreference = "Stop"

# File is normally under something like C:\Users\onoma\AppData\Local\Packages\CanonicalGroupLimited...
$files = @()
cd $env:LOCALAPPDATA\Packages
get-childitem -recurse -filter "ext4.vhdx" -ErrorAction SilentlyContinue | foreach-object {
  $files += ${PSItem}
}

if ( $files.count -gt 1 ) {
  throw "We found too many files in $env:LOCALAPPDATA\Packages"
}

if ( $files.count -eq 0 ) {
  throw "We could not find a file called ext4.vhdx in $env:LOCALAPPDATA\Packages"
}

$disk = $files[0].FullName


write-output " - Successfully found VHDX file $disk"
write-output " - Shutting down WSL2"
wsl --shutdown
write-output " - Compacting disk (starting diskpart)"

@"
select vdisk file=$disk
attach vdisk readonly
compact vdisk
detach vdisk
exit
"@ | diskpart

write-output ""
write-output "Success. Compacted $disk."
