# My config of DWM!
<img src="https://github.com/aurorae-nb/dwm/blob/main/banner.png">
## About
I started this project basing it off of Chris Titus's "dwm-titus" and "debian-titus," with some other minor tweaks because I felt like it. These include mostly extra patches for things like gaps around the windows, some better keybinds, and the suckless status bar. Generally just trying to make it a little bit prettier and add some functionality for laptops.

## Installation

Install all the Xorg deps alongside some utilities:

Debian:
```bash
apt install nala feh kitty rofi picom thunar lxpolkit x11-xserver-utils pavucontrol build-essential libx11-dev libxft-dev libxinerama-dev libx11-xcb-dev libxcb-res0-dev xdg-utils
```

Arch:
```bash
sudo pacman -S base-devel libx11 libxcb cmake libxft libxinerama libxcb-res xorg-xev xorg-xbacklight alsa-utils feh kitty rofi picom thunar lxpolkit pavucontrol
```

 
 Move the DWM related folders into the main folder (optionally hide) and compile everything in their relevant folders:

```bash
mv ~/dwm/dwm/ ~/.dwm
cd ~/.dwm && sudo make clean install
mv ~/dwm/dmenu/ ~/.dmenu
cd ~/.dmenu && sudo make clean install
mv ~/dwm/slstatus/ ~/.slstatus
cd ~/.slstatus && sudo make clean install
```

Copy the kitty config file to `~/.config/kitty/`, and install Starship with `curl -Ss https://starship.rs/install.sh|sh`. Add `. .fehbg & slstatus & exec dwm` to your .xinitrc file. Next pick a background and run `feh --bg-fill [PATH-TO-FILE]` to set it and allow your computer to set the background on startup.

Optionally, add to .bash_profile to launch X server on login:

```bash
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
startx
fi
```

## Setup and Theming
Add custom .bashrc (optionally move starship config to .config if installed):
```bash
git clone https://github.com/aurorae-nb/mybash
cd mybash
mv [FILE] ~/.bashrc
```

Install the Nordic GTK theme:

```bash
cd /usr/share/theme && sudo git clone https://github.com/EliverLara/Nordic
```

Install the cursors:

```bash
git clone https://github.com/alvatip/Nordzy-cursors
cd Nordzy-cursors
./install.sh
cd .. && rm -rf Nordzy-cursors
```

Configure Nala, a much nicer apt frontend (Debian):

```bash
sudo nala fetch
```

Open lxappearance and set the theme and cursors.

## Screenshots
*Running DWM on my Laptop with Arch Linux (btw)*

<img alt="DWM on Arch Linux" src="https://github.com/aurorae-nb/dwm/blob/main/arch-dwm.png">

*DWM running on my RPi 4 for a light but elegant desktop*

<img alt="DWM on Debian Linux" src="https://github.com/aurorae-nb/dwm/blob/main/debian-dwm.png">
