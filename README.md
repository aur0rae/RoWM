# My DWM Config

<img src="https://github.com/aurorae-nb/dwm/blob/main/banner.png">

## About
I started this project inspired by Chris Titus's "dwm-titus" and "debian-titus," though it is not a fork of his project. It is a fork of Suckless's DWM, Dmenu, and SLStatus, however, with these all put together in one project for ease of install with all my tweaks. Generally just trying to make it a little bit prettier and add some functionality for laptops.

## Installation
Run the `install.sh` script included to install all dependencies for building DWM on Debian and Arch based distrobutions, alongside a few other base programs. These include feh, picom, git, wget, kitty, thunar, pavucontrol, firefox, and flatpak, aiming to provide a suitable starting environment with a few default graphical apps and multiple ways of installing software. 

Secondarily, Debian-based distros will have the edition of `nala`, a very pretty frontend for `apt`, and Arch users will have access to `paru` as an AUR helper. This should make for a nice out-of-the-box experience and just make things go a little faster.

The install script will also add Nordzy Cursors by alvatip and the Nordic theme by EliverLara. The included wallpaper is the default Debian 12 "Emerald theme," designed by Juliette Taka.

## Patches
This version of dwm currently is patched with the following:
- **autostart** - runs the `autostart.sh` script located under dwm's folder. This will set the wallpaper and launch `slstatus`, a compositor, and a polkit at startup.
- **cursorwarp** - "warps" the cursor to the center of the window upon spawning or switching windows, etc.
- **systray** - a system tray with icons for apps running in the background.
- **viewontag** - shifts the current desktop when moving windows to different workspaces.

## Screenshots
*Running DWM on my Laptop with Arch Linux (btw)*

<img alt="DWM on Arch Linux" src="https://github.com/aurorae-nb/dwm/blob/main/arch-dwm.png">

*DWM running on my RPi 4 for a light but elegant desktop*

<img alt="DWM on Debian Linux" src="https://github.com/aurorae-nb/dwm/blob/main/debian-dwm.png">
