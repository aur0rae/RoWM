## About
This project is a customized fork of Suckless's `dwm` meant for running on Raspberry Pi computers and other cases where a lighter graphical solution is preferred.

## Installation
To install and configure everything, just run `install.sh`. It will request user input for passwords as needed for `sudo` permissions, as you cannot (and should not attempt to) run the program as root.
```bash
chmod +x install.sh
. ./install.sh
```

## Patches
This version of dwm currently is patched with the following:
- **autostart** - runs the `autostart.sh` script located under dwm's folder. This will set the wallpaper and launch the compositor and polkit at startup.
- **cursorwarp** - "warps" the cursor to the center of the window upon spawning or switching windows, etc.
- **fullgaps** - adds gaps around windows to make them float.
- **fullscreen** - allows hiding of the bar in the "Monocle" layout.
- **status2d-barpadding-systray** - a system tray and status bar that makes the top bar float.
- **viewontag** - shifts the current desktop when moving windows to different workspaces.

## Credits
The default wallpaper used in this project is Debian 12's "Emerald theme," by Juliette Taka.

Repos used and pulled in by the script include:
- **dwm** and **dmenu** by [Suckless Software](https://suckless.org/).
- **Nordic Theme** by [EliverLara](https://github.com/EliverLara/Nordic).
- **MyBash** by me, [aur0rae](https://github.com/aur0rae/MyBash).

## Screenshots
*Running DWM on my Laptop with Arch Linux (btw)*
<img alt="DWM on Arch Linux" src="https://github.com/aurorae-nb/RoWM/blob/main/res/arch-dwm.png">

*DWM running on my RPi 4 for a pretty but lightweight desktop*
<img alt="DWM on Debian Linux" src="https://github.com/aurorae-nb/RoWM/blob/main/res/debian-dwm.png">
