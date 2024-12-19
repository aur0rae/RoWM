#!/bin/bash

# Update and install software with the selected package manager
deb_install() {
	sudo apt update
	sudo apt install -y fzf zoxide batcat nala feh kitty rofi picom thunar lxpolkit x11-xserver-utils pavucontrol build-essential libx11-dev libxft-dev libxinerama-dev libx11-xcb-dev libxcb-res0-dev xdg-utils git firefox-esr flatpak
        # Configure nala to use best available mirrors
	sudo nala fetch
}

arch_install() {
	sudo pacman -Syu --noconfirm
	sudo pacman -S --noconfirm bat zoxide fzf eza base-devel libx11 libxcb cmake libxft libxinerama libxcb-res xorg-xev xorg-xbacklight alsa-utils feh kitty rofi picom thunar lxpolkit pavucontrol git firefox flatpak
	# Install paru
	git clone https://aur.archlinux.org/paru.git && cd paru
        makepkg -si
	cd .. && rm -rf paru
}

opensuse_install() {
	sudo zypper refresh
	sudo zypper dist-upgrade
	sudo zypper install -t devel_basis
	sudo zypper install -y libX11-devel libxcb-devel libXft-devel libXinerama-devel xorg-x11-server thunar feh kitty rofi picom lxpolkit pavucontrol git firefox flatpak
}


# Determine distribution
echo "Determining distribution and package manager..."

if [ -f "/etc/os-release" ]; then
	source /etc/os-release
	ID=$ID
	case "$ID" in
		debian|ubuntu)
			echo "Using apt to install dependancies, base apps, Flatpak, and Nala..."
			deb_install
			;;
		arch)
			echo "Using pacman to install dependancies, base apps, Flatpak, and Paru..."
			arch_install
			;;
		opensuse-leap|opensuse-tumbleweed)
			echo "Using zypper to install dependancies, base apps, and Flatpak..."
			opensuse_install
			;;
		*)
			echo "Error: Unsupported distribution. Exiting..."
			exit
			;;
	esac
else
	echo "Error: /etc/os-release not found. Exiting..."
	exit
fi


# Configure Flatpak to use Flathub
echo "Configuring Flatpak..."

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo


# Move dwm, dmenu, and slstatus into appropriate hidden folders under user's home directory and compile
echo "Compiling DWM and suckless software..."

TEMP_DIR=$(pwd)

for word in "dwm dmenu slstatus"; do
	mv "$(TEMP_DIR)"/${word} ~/.${word} && cd ~/.${word} && sudo make clean install; 
done


# Edit files to make DWM launch on startup and set background properly
echo "Configuring DWM to launch on login..."

if [ !-f "~/.xinitrc" ]; then
	touch ~/.xinitrc
	echo -e ". .fehbg &\nslstatus &\nexec dwm" >> ~/.xinitrc
else
	echo "Error: ~/.xinitrc already exists. Exiting..."
	exit
fi

if [ !-f "~/.bash_profile" ]; then
	touch .bash_profile
fi
echo -e "if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then\n  startx\nfi" >> ~/.bash_profile


# Configure bash prompt
echo "Setting custom bash prompt..."

git clone https://github.com/aurorae-nb/mybash
mv mybash/bashrc-simple-cyan ~/.bashrc
rm -rf mybash


# Apply themes
echo "Installing themes (set with lxappearance)..."

# Install Nordic theme by EliverLara 
cd /usr/share/theme && sudo git clone https://github.com/EliverLara/Nordic
cd "$(TEMP_DIR)"
# Install Nordzy Cursors by alvatip
git clone https://github.com/alvatip/Nordzy-cursors && cd Nordzy-cursors
./install.sh
cd .. && rm -rf Nordzy-cursors
# Configure kitty to use correct theming and transparency
mkdir -P ~/.config/kitty
mv kitty.conf ~/.config/kitty/kitty.conf
# Set background
mv bg.png ~/Pictures/bg.png && feh --bg-fill ~/Pictures/bg.png

# Notify user that process terminated successfully
echo "Installation completed successfully. No errors reported."
exit
