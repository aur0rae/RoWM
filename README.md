## About
This project is a customized fork of Suckless's `dwm` for running a simple but pretty desktop on lower power 
computers.

## Installation
To install and configure everything, just run `install.sh`. It will request user input for passwords as needed for 
`sudo` permissions, as you cannot (and should not attempt to) run the program as root.
```sh
chmod +x install.sh
. ./install.sh
```

## Patches
This version of dwm currently is patched with the following:

Note: patches cannot be directly applied to new DWM versions due to conflicts, and the backlight and amixer patches 
have been tweaked to work correctly

- **amixer-integration** - allows for control over the system audio using media keys.
- **autostart** - runs the `autostart.sh` script located under dwm's folder. This sets the wallpaper and launches 
picom at startup.
- **backlight** - allows for convenient control over screen brightness.
- **cursorwarp** - "warps" the cursor to the center of the window upon spawning or switching focus.
- **fullgaps** - adds gaps around windows to make them float.
- **reload** - allows hotreloading of DWM while running to streamline patching and configuring.
- **status2d-barpadding-systray** - a system tray and status bar that makes the top bar float.
- **viewontag** - shifts the current desktop when moving windows to different workspaces.

## Credits
The default wallpaper used in this project is Debian 12's "Emerald theme," by Juliette Taka, and the 
main project is forked off of **dwm**, **dmenu**, and **slstatus** by [Suckless Software](https://suckless.org/).

Thanks to Suckless Software, Chris Titus Tech, Glockenspiel, and everyone behind DWM's patches!

## Important binds
The default modifier key for all binds is `alt`. You can edit DWM's `config.h` and recompile it to use `Mod4Mask` 
instead - that being the "Windows" or "super" key. Media and backlight keys should "just work."

General:
- **mod+Return** - spawns Alacritty, the default terminal.
- **mod+P** - launches Dmenu.
- **mod+R** - hotreloads current running config after a recompile.
- **mod+shift+Q** - kills current session.

Window management:
- **mod+Shift+C** - kills current window.
- **mod+[1-9]** - switches current workspace.
- **mod+Shift+[1-9]** - moves current window to a different workspace.
- **mod+Enter** - shifts current focused window to the "master" column.
- **mod+Enter+[I,D]** - shifts windows into/out of the "master" column.
- **mod+[L,H]** - grows or shrinks "master" and "stack" columns.
- **mod+[J,K]** - shifts focus.

## Screenshots
*Running DWM on my Laptop with Arch Linux (btw)*
<img alt="DWM on Arch Linux" src="https://github.com/aurorae-nb/RoWM/blob/main/res/arch-dwm.png">

*DWM running on my RPi 4 for a pretty but lightweight desktop*
<img alt="DWM on Debian Linux" src="https://github.com/aurorae-nb/RoWM/blob/main/res/debian-dwm.png">
