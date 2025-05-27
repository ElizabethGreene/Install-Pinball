# Install-Pinball
A PowerShell script to install Windows XP's Pinball on Windows 10 or 11 by extracting the files from the Windows XP CD or ISO.

## Minimal Instructions:
Download Install-PowerShell.ps1 from this repository.

Insert a Windows XP CD or right-click/mount the ISO.

Note the path to the /i386 folder.

Run this script as an administrator with the i386 path as the parameter.

`Install-Pinball.ps1 -SourcePath D:\i386`

This installs the Space Cadet Pinball game to C:\Program Files (x86)\Space Cadet Pinball and creates a Start menu shortcut for all users.

## Optional instructions: 
To install without administrator rights, specify a user writable destination folder 
with the -DestinationFolder parameter

 `Install-Pinball.ps1 -SourcePath D:\i386 -DestinationFolder "C:\users\egreene\pinball"`

 This installs Pinball and creates a per-user start menu shortcut.

## Why?
There are non-Microsoft installers for Pinball available from public internet sources, but the underlying binaries are not digitally signed and there is no way to know if they've been modified.  This installer allows anyone with a trusted media source, e.g. a Physical Windows XP disc or a .iso image from Microsoft, to install directly from that trusted media.

## Help!
### Why am I getting an error about execution of scripts being blocked when trying to run this?
This occurs when Powershell's script exection policy requires digitally signed scripts or blocks remote scripts.  A workaround for this is to run the script like this.

`Powershell.exe -ExecutionPolicy Bypass -File Install-Pinball.ps1`

You may also need to unblock the script.  Check this by right-clicking the script in file explorer, opening properties, and checking the "unblock" box if it appears.

### I'm having a different issue.
Feel free to open an issue on github.

## Credits
Thanks to Dave Plummer, formerly of Microsoft and now with the [Dave's Garage YouTube channel](https://www.youtube.com/watch?v=ThxdvEajK8g) for the inspiration.

Thanks to Danilo Bilanoski for help [creating the start menu shortcuts](https://medium.com/@dbilanoski/how-to-tuesdays-shortcuts-with-powershell-how-to-make-customize-and-point-them-to-places-1ee528af2763).


