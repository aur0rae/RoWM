<img src="https://github.com/aurorae-nb/dwm/blob/main/banner.png">

## About
This is my custom fork of Suckless's dwm, loosely based on Chris Titus's "dwm-titus." My goal is to make a more up-to-date and user-friendly version of his vision but with a bit more visual flare and personal touch.

## Installation
`install.sh` is an automated script I wrote to install and configure everything needed. It is designed for use with Debian and Arch based systems, though the system can be run on most common distros if you do it manually by simply moving the Suckless folders to corresponding hidden ones under your user's home directory.

The script preinstalls all the dependencies needed to build and run dwm, plus a compositor (picom), software to set a wallpaper (feh), flatpak, the GNOME polkit agent, a file manager (thunar), and a terminal (kitty). There is also an optional post-install part to the script that will pull in a bunch of other stuff; read the script for more details.

## Patches
This version of dwm currently is patched with the following:
- **autostart** - runs the `autostart.sh` script located under dwm's folder. This will set the wallpaper and launch the compositor and polkit at startup.
- **cursorwarp** - "warps" the cursor to the center of the window upon spawning or switching windows, etc.
- **systray** - a system tray with icons for apps running in the background.
- **viewontag** - shifts the current desktop when moving windows to different workspaces.

## Credits
The default wallpaper used in this project is Debian 12's "Emerald theme," by Juliette Taka.

Repos used and pulled in by the script include:
- **dwm, dmenu, and slstatus** by Suckless Software
- **Nordzy Cursors** by alvatip.
- **Nordic Theme** by EliverLara.
- **MyBash** by me, aurorae-nb.

## Screenshots
*Running DWM on my Laptop with Arch Linux (btw) several months ago*
<img alt="DWM on Arch Linux" src="https://github.com/aurorae-nb/dwm/blob/main/arch-dwm.png">

*DWM running on my RPi 4 for a pretty but lightweight desktop*
<img alt="DWM on Debian Linux" src="https://github.com/aurorae-nb/dwm/blob/main/debian-dwm.png">
