# WSL2 Compacter

## A small script for Windows 10 Home users to compact their WSL2 disks

Inspired by this post on [GitHub](https://github.com/microsoft/WSL/issues/4699#issuecomment-627133168).

## Warning

1. I am a strange man on the internet asking you to run a powershell script. You should probably look inside the script [`compact-wsl2-disk.ps1`](compact-wsl2-disk.ps1) and make sure you understand what it does.

2. This will stop WSL. So save your work in Linux.

## Usage

Open Powershell as Administrator and run:

`powershell.exe .\compact-wsl2-disk.ps1`

## PRs are welcome!

Please file tickets instead of just asking for things. Thanks!

## License

MIT

## Thanks

[This person on StackOverflow](https://stackoverflow.com/questions/64772243/can-diskpart-take-command-line-parameters-or-can-i-fake-them-with-powershell)
