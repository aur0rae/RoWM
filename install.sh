#!/usr/bin/env sh
#
# ============================================================= #
# Please report any issues in my attempts to make this script
# POSIX-compliant, thanks!
# -- Note: this does still rely on the GNU Coreutils. I will
#    be aiming to make this compatible with BusyBox and other
#    similar projects, but at the moment I do not have the
#    time to test this. I'm not sure whether or not DWM relies
#    on glibc or if it can be run with alternate C libraries.
#
echo "
# ============================================================= #
# Aur0rae's config of
#             ■■■■■■
#             ■    ■
#             ■    ■
#             ■    ■
#             ■    ■
#     ■■■■■■■■■    ■   ■■■■■   ■■■■■■■■■■■■■■■■■■■■■■■
#     ■            ■   ■   ■   ■                     ■
#     ■  ■■■■■■    ■■■■■   ■■■■■     ■■■■■   ■■■■■   ■
#     ■                              ■   ■   ■   ■   ■
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   ■■■■■   ■■■■■
#
# Thanks to Suckless Software, Chris Titus Tech, Glockenspiel,
# and all contributors to the DWM patches!
# ============================================================= #
"



# ============================================================= #
#
# Check if this is running with root permissions - it should
# not be
#
# ============================================================= #
if [ "$EUID" = 0 ]; then
	echo "Running this script as root may break things. Please run without superuser permissions."
	sleep 10
	exit 1
else
	# Set working directory
	TEMP_DIR=$(pwd)
fi



# ============================================================= #
#
#     Functions
#
# ============================================================= #

deb_install() {
	# Refresh mirrors and update system
	sudo apt update
	sudo apt dist-upgrade

	# Install deps
	sudo apt install -y xorg build-essential libxft-dev libxinerama-dev wget git \
			alsa-utils pipewire pipewire-pulse wireplumber network-manager \
			feh alacritty scrot thunar thunar-volman gvfs bat eza fzf \
			zoxide vlc network-manager-gnome brightnessctl picom

	# Install Flatpak
	if [ $INSTFLTPK = 'Y' ]; then
		sudo apt install -y flatpak
	fi

	# Prompt user to install Nala
	confirm "install Nala and configure mirrors" nala_config "echo Skipping."
}

nala_config() {
	# Install Nala
	sudo apt install nala

	# Select mirrors
	sudo nala fetch
}

arch_install() {
	# Update system
	sudo pacman -Syu

	# Install deps
	sudo pacman -S --noconfirm xorg libx11 libxft libxinerama base-devel wget git \
			alsa-utils pipewire pipewire-pulse wireplumber thunar \
			thunar-volman gvfs networkmanager nm-applet alacritty feh \
			bat eza fzf zoxide vlc brightnessctl picom scrot

	# Install Flatpak
	if [ $INSTFLTPK = 'Y' ]; then
		sudo pacman -S --noconfirm flatpak
	fi

	# Prompt user to install Paru
	confirm "install Paru to manage AUR packages" paru_config "echo Skipping."
}

paru_config() {
	# Install Paru
	git clone https://aur.archlinux.org/paru.git
	cd $TEMPDIR/paru
	makepkg -si

	# Clean up after
	cd $TEMPDIR
	rm -rf $TEMPDIR/paru
}

optional_install() {
	# TODO: implement packages to install
	echo "Sorry, this function is not yet complete. Skipping."
}

confirm() {
	while true; do
	        read -p "> Would you like to $1? (Y)es/(N)o: " var
	        case "$var" in
	                [yY][eE][sS]|[yY])
	                        $2
	                        break
	                ;;
			[nN][oO]|[nN])
				$3
				break
			;;
			*)
				echo "Error: unrecognized input."
			;;
		esac
	done
}

configx() {
	echo "if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then\n\tstartx\nfi" > $HOME/.bash_profile
}



# ============================================================= #
#
#     Main script
#
# ============================================================= #

# Determine distribution and ask about Flatpak
echo "Determining distribution and package manager."
confirm "install Flatpak for additional distro-agnostic package management?" "export INSTFLTPK=Y" "export INSTFLTPK=N"

if [ -f "/etc/os-release" ]; then
	. /etc/os-release
	case "$ID" in
		debian|*ubuntu*)
			echo "$ID detected. Using apt to update, install dependancies, and configure Nala...\n"
			deb_install
			;;
		arch*|endeavour|manjaro|artix|cachyos)
			echo "$ID detected. Using pacman to update and install dependancies...\n"
			arch_install
			;;
		*)
			# Catch exceptions for distros like Fedora, OpenSuSE, etc.
			echo "Sorry, package management on this distribution is not supported."
			confirm "continue" "break" "exit 1"
			;;
	esac
else
	# Catch exceptions if NO os-release is found
	echo "Error: /etc/os-release not found. Are you on Linux?\n"
	confirm "continue" "break" "exit 1"
fi

# If flatpak was installed, configure Flathub
if [ $INSTFLTPK = 'Y' ]; then
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	echo "Flatpak configured.\n"
fi



# Install DWM, Dmenu, and SLStatus
echo "Compiling DWM and other suckless software..."

for suckless in dwm dmenu slstatus; do
	if [ ! -d "$HOME/.${suckless}" ]; then
		cp -r $TEMP_DIR/src/${suckless} $HOME/.${suckless}
		cd $HOME/.${suckless}
 		make
		sudo make clean install
	else
		echo "${suckless} is already installed to ~/.${suckless}! Skipping."
	fi
done
echo "Finished Suckless Software installation!\n"



# Return to expected working directory
cd $TEMP_DIR

# Configure Xorg
echo "Configuring Xorg to launch DWM..."

if [ ! -f "$HOME/.xinitrc" ]; then
	echo '#!/bin/sh\nexec dwm' > ~/.xinitrc;
else
	echo "~/.xinitrc already exists, skipping.";
fi

# Prompt user to configure autostarting DWM
confirm "start DWM at BASH login" configx "echo Skipping."
echo "Xorg config done!\n"



# Configure shell and graphical stuffs
echo "Configuring environment..."

# Make sure background is set
cp $TEMP_DIR/res/bg.png $HOME/.bg.png
echo "#!/bin/sh\nfeh --no-fehbg --bg-fill '$HOME/.bg.png'" > .fehbg

# Configure kitty to use correct theming and transparency
mkdir -p $HOME/.config
cp $TEMP_DIR/src/alacritty.toml $HOME/.config/alacritty.toml

echo "Environment configured!\n"



# Prompt user to install additional common quality of life software
confirm "install additional software with Flatpak" optional_install "echo Skipping."



# Notify user when script is done
echo "Installation completed successfully.\n\nRun 'startx' to launch DWM."
cd $HOME
