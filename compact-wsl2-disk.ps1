$ErrorActionPreference = "Stop"

# File is normally under something like C:\Users\onoma\AppData\Local\Packages\CanonicalGroupLimited...
$files = @()
pushd $env:LOCALAPPDATA\Packages
get-childitem -recurse -filter "ext4.vhdx" -ErrorAction SilentlyContinue | foreach-object {
  $files += ${PSItem}
}

# Docker wsl2 vhdx files
pushd $env:LOCALAPPDATA\Docker
get-childitem -recurse -filter "ext4.vhdx" -ErrorAction SilentlyContinue | foreach-object {
  $files += ${PSItem}
}

if ( $files.count -eq 0 ) {
  throw "We could not find a file called ext4.vhdx in $env:LOCALAPPDATA\Packages or $env:LOCALAPPDATA\Docker"
}

write-output " - Found $($files.count) VHDX file(s)"
write-output " - Shutting down WSL2"

# See https://github.com/microsoft/WSL/issues/4699#issuecomment-722547552
wsl -e sudo fstrim /
wsl --shutdown

foreach ($file in $files) {
	$disk = $file.FullName
	
	write-output " - Compacting disk (starting diskpart)"

	@"
select vdisk file="$disk"
attach vdisk readonly
compact vdisk
detach vdisk
exit
"@ | diskpart

	write-output ""
	write-output "Success. Compacted $disk."
}

popd
popd
