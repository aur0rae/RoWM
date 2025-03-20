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
	sudo apt install -y xorg x11-xserver-utils build-essential libx11-dev libxft-dev libxinerama-dev libx11-xcb-dev libxcb-res0-dev libimlib2-dev wget git
	sudo apt install -y fonts-font-awesome feh policykit-1-gnome nala alacritty flameshot thunar lxappearance pavucontrol neovim flatpak 
	# Configure nala to use best available mirrors
	sudo nala fetch
}

arch_install() {
	sudo pacman -Syu --noconfirm
	sudo pacman -S --noconfirm base-devel xorg-server xorg-xinit libx11 libxcb cmake libxft libxinerama wget git
	sudo pacman -S --noconfirm awesome-terminal-fonts feh alacritty picom flameshot thunar polkit-gnome lxappearance pavucontrol neovim flatpak
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
			optional_install=$(apt install)
			;;
		
		arch|endeavour|manjaro)
			echo "Using pacman to update, install dependancies, base apps, Flatpak, and Paru..."
			arch_install
			optional_install=$(pacman -S)
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

for suckless in dwm dmenu; do
	mv $TEMP_DIR/src/${suckless} $HOME/.${suckless}
	cd $HOME/.${suckless}
 	sudo make
	sudo make clean install
done

# Return to expected working directory
cd $TEMP_DIR

# Edit files to make DWM launch on startup and set background properly
echo "Configuring DWM to launch on login..."

if [[ ! -f "~/.xinitrc" ]]; then
	echo "exec dwm" >> ~/.xinitrc
else
	echo "Error: ~/.xinitrc already exists. Exiting..."
	exit
fi

echo -e 'if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then\n\tstartx\nfi' > ~/.bash_profile

# Make directories
echo "Populating home directory..."
for dir in Desktop Documents Downloads Music Pictures Projects Videos; do
	mkdir $HOME/${dir}
done

# Configure bash prompt
echo "Setting custom bash prompt..."

echo -e "source /usr/share/git/git-prompt.sh" >> ~/.bashrc
echo -e 'PS1="\\[\\e[1;36m\\]╭ \\u@\\h \\[\\e[0;37m\\]in \\[\\e[1;35m\\]\\w\\$(__git_ps1)\\[\\e[0;37m\\] at \\[\\e[1;36m\\]\\@\\n╰─ \\[\\e[0;36m\\]𝝺 \\[\\e[0;37m\\]' >> ~/.bashrc

sudo mkdir /usr/share/git
cd /usr/share/git
sudo wget https://github.com/git/git/raw/refs/heads/master/contrib/completion/git-prompt.sh

# Install Nordic theme by EliverLara 
echo "Installing themes..."
sudo mkdir -p /usr/share/themes
cd /usr/share/themes
sudo git clone https://github.com/EliverLara/Nordic
cd $TEMP_DIR
mv src/gtk-3.0 $HOME/.config/

# Configure kitty to use correct theming and transparency
mkdir -p $HOME/.config/alacritty
mv $TEMP_DIR/src/alacritty.yml $HOME/.config/alacritty/alacritty.yml

# Set Background
mv $TEMP_DIR/res/bg.png $HOME/Pictures/bg.png 
cd $HOME

# Notify user that process terminated successfully
echo -n "Installation completed successfully. No errors reported."
rm -rf $TEMP_DIR

# Optionally install additional packages
optional_install() {
	case "$ID" in
		debian|ubuntu)
			flatpak install flathub dev.vencord.Vesktop
			flatpak install flathub com.valvesoftware.Steam
			flatpak install flathub org.prismlauncher.PrismLauncher
			flatpak install flathub one.ablaze.floorp
			flatpak install flathub org.gimp.GIMP
			flatpak install flathub org.libreoffice.LibreOffice
			flatpak install flathub org.mozilla.Thunderbird
			flatpak install flathub com.obsproject.Studio
			;;
		
		arch|endeavour|manjaro)
			paru -S deluge deluge-gtk floorp gimp libreoffice-fresh thunderbird obs-studio vencord steam prismlauncher jre17-openjdk jre21-openjdk jre8-openjdk yt-dlp 
			;;
	esac
}

while true; do
	read -p "Install additional software? (does not work on ARM) (y/N): " confirm
	if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
		echo "Installing..."
		optional_install
		echo "Finished installing additional software. No errors reported"
		break

	elif [[ $confirm == [nN] || $confirm == [nN][oO] || $confirm ==[\n]]; then
		break
	else
		echo "Error: Improper input. Please try again."
	fi
done

# Finish up final bit of setup
echo "Starting Xorg server..."
startx

sleep 10s
feh --bg-scale $HOME/Pictures/bg.png
