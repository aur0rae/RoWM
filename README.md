## About
This project is a customized fork of Suckless's `dwm` for running a simple but pretty desktop on lower power computers.

## Installation
To install and configure everything, just run `install.sh`. It will request user input for passwords as needed for `sudo` permissions, as you cannot (and should not attempt to) run the program as root.
```bash
chmod +x install.sh
. ./install.sh
```

## Patches
This version of dwm currently is patched with the following:
-# Note: patches cannot be directly applied to new DWM versions due to conflicts, and the backlight and amixer patches have been tweaked to work correctly
- **amixer-integration** - allows for control over the system audio using media keys.
- **autostart** - runs the `autostart.sh` script located under dwm's folder. This sets the wallpaper and launches picom at startup.
- **backlight** - allows for convenient control over screen brightness.
- **cursorwarp** - "warps" the cursor to the center of the window upon spawning or switching focus.
- **fullgaps** - adds gaps around windows to make them float.
- **reload** - allows hotreloading of DWM while running to streamline patching and configuring.
- **status2d-barpadding-systray** - a system tray and status bar that makes the top bar float.
- **viewontag** - shifts the current desktop when moving windows to different workspaces.

## Credits
The default wallpaper used in this project is Debian 12's "Emerald theme," by Juliette Taka.

Repos used and pulled in by the script include:
- **dwm** and **dmenu** by [Suckless Software](https://suckless.org/).
- **MyBash** by me, [aur0rae](https://github.com/aur0rae/MyBash).

Thanks to Suckless Software, Chris Titus Tech, Glockenspiel, and everyone behind DWM's patches!

## Screenshots
*Running DWM on my Laptop with Arch Linux (btw)*
<img alt="DWM on Arch Linux" src="https://github.com/aurorae-nb/RoWM/blob/main/res/arch-dwm.png">

*DWM running on my RPi 4 for a pretty but lightweight desktop*
<img alt="DWM on Debian Linux" src="https://github.com/aurorae-nb/RoWM/blob/main/res/debian-dwm.png">
