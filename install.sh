#!/usr/bin/env bash

# Check if this is running with root permissions - it should not be
if [[ "$EUID" = 0 ]]; then
	echo "Running this script as root may break things. Please run without superuser permissions."
	exit
fi


# Update and install software with the selected package manager
deb_install() {
	sudo apt update
	sudo apt upgrade
	sudo apt install -y x11-xserver-utils build-essential libx11-dev libxft-dev libxinerama-dev libx11-xcb-dev libxcb-res0-dev xdg-utils git
	sudo apt install -y feh lxpolkit fzf zoxide batcat nala kitty thunar lxappearance pavucontrol neovim flatpak

	# Configure nala to use best available mirrors
	sudo nala fetch
}

arch_install() {
	sudo pacman -Syu --noconfirm
	sudo pacman -S --noconfirm base-devel libx11 libxcb cmake libxft libxinerama libxcb-res xorg-xev xorg-xbacklight git
	sudo pacman -S --noconfirm bat zoxide fzf eza feh kitty picom thunar lxpolkit lxappearance pavucontrol neovim flatpak

	# Install paru
	git clone https://aur.archlinux.org/paru.git
	cd paru
        makepkg -si
	cd .. 
	rm -rf paru
}


# Set working directory
TEMP_DIR=$(pwd)


# Determine distribution
echo "Determining distribution and package manager..."

if [[ -f "/etc/os-release" ]]; then
	source /etc/os-release
	ID=$ID
	case "$ID" in
		debian|ubuntu)
			echo "Using apt to update, install dependancies, base apps, Flatpak, and Nala..."
			deb_install
			;;
		
		arch|endeavour|manjaro)
			echo "Using pacman to update, install dependancies, base apps, Flatpak, and Paru..."
			arch_install
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

for suckless in dwm dmenu slstatus; do
	mv '$(TEMP_DIR)'/${word} ~/.${word}
	cd ~/.${word}
	sudo make clean install 
done

# Return to expected working directory
cd '$(TEMP_DIR)'

# Edit files to make DWM launch on startup and set background properly
echo "Configuring DWM to launch on login..."

if [[ ! -f "~/.xinitrc" ]]; then
	echo -e ". .fehbg &\nslstatus &\nexec dwm" >> ~/.xinitrc
else
	echo "Error: ~/.xinitrc already exists. Exiting..."
	exit
fi

echo -e 'if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then\n\tstartx\nfi' >> ~/.bash_profile


# Configure bash prompt
echo "Setting custom bash prompt..."

git clone https://github.com/aurorae-nb/mybash
mv mybash/bashrc-simple-cyan ~/.bashrc
rm -rf mybash


# Apply themes
echo "Installing themes (set with lxappearance)..."

# Install Nordic theme by EliverLara 
cd /usr/share/theme && sudo git clone https://github.com/EliverLara/Nordic
cd '$(TEMP_DIR)'

# Install Nordzy Cursors by alvatip
git clone https://github.com/alvatip/Nordzy-cursors 
cd Nordzy-cursors
./install.sh
cd .. 
rm -rf Nordzy-cursors

# Configure kitty to use correct theming and transparency
mkdir -p ~/.config/kitty
mv kitty.conf ~/.config/kitty/kitty.conf

# Set background
mv bg.png ~/Pictures/bg.png && feh --bg-fill ~/Pictures/bg.png


# Notify user that process terminated successfully
echo -n "Installation completed successfully. No errors reported."


# Optionally install additional packages
optional_install() {
	case "$ID" in
		debian|ubuntu)
			flatpak install flathub com.discordapp.Discord
			flatpak install flathub com.valvesoftware.Steam
			flatpak install flathub org.prismlauncher.PrismLauncher
			flatpak install flathub one.ablaze.floorp
			flatpak install flathub org.gimp.GIMP
			flatpak install flathub org.libreoffice.LibreOffice
			flatpak install flathub org.mozilla.Thunderbird
			flatpak install flathub com.obsproject.Studio
			;;
		
		arch|endeavour|manjaro)
			paru -S deluge deluge-gtk floorp gimp libreoffice-fresh thunderbird obs-studio discord steam prismlauncher jre17-openjdk jre21-openjdk jre8-openjdk yt-dlp 
			;;
	esac
}

while true; do
	read -p "Install additional software? (Y/N): " confirm
	if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
		echo "Installing..."
		optional_install
		echo "Finished installing additional software. No errors reported"
		break

	elif [[ $confirm == [nN] || $confirm == [nN][oO] ]]; then
		break
	else
		echo "Error: Improper input. Please try again."
	fi
done
