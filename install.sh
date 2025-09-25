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
	sudo apt update
	sudo apt install -y xorg build-essential libxft-dev libxinerama-dev wget git \
			alsa-utils pipewire pipewire-pulse wireplumber network-manager \
			feh alacritty scrot thunar thunar-volman gvfs bat eza fzf \
			zoxide vlc network-manager-gnome brightnessctl picom
	# Configure nala to use best available mirrors
	sudo nala fetch
}

arch_install() {
	# TODO: Implement Arch install
	sleep 10
	exit
}

optional_install() {
	# TODO: Implement script to install extra apps
	echo "Sorry, this feature is not yet supported. Skipping...\n"
}

confirm() {
	while true; do
	        read -p "Would you like to $1? (Y)es/(N)o: " var
	        case "$var" in
	                [yY][eE][sS]|[yY])
	                        $2
	                        break
	                ;;
			[nN][oO]|[nN])
				echo "Skipping..."
				break
			;;
			*)
				echo "Error: unrecognized input."
			;;
		esac
	done
}

configx() {
	echo "if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then\n\tstartx\nfi" > ~/.bash_profile
}

configbash() {
	rm $HOME/bashrc
	cp $TEMP_DIR/src/bashrc $HOME/bashrc
}



# ============================================================= #
#
#     Main script
#
# ============================================================= #

# Determine distribution
echo "Determining distribution and package manager..."

if [ -f "/etc/os-release" ]; then
	. /etc/os-release
	echo 'Done!\n'
	case "$ID" in
		debian|ubuntu)
			echo "$ID detected. Using apt to update, install dependancies, and configure Nala...\n"
			deb_install
			;;
		arch|endeavour|manjaro)
			echo "$ID is unsupported at this time. Sorry!"
			arch_install
			;;
		*)
			echo "Sorry, this distribution is not supported."
			sleep 10
			exit 1
			;;
	esac
else
	echo "Error: /etc/os-release not found. Are you on Linux?"
	sleep 10
	exit 1
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
		echo "${suckless} is already installed to ~/.${suckless}! Skipping..."
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
	echo "~/.xinitrc already exists. Skipping...";
fi

confirm "start DWM at BASH login" configx
echo "Xorg config done!\n"



# Make directories
echo "Populating home directory."
for dir in Desktop Documents Downloads Music Pictures Projects Videos; do
	mkdir -p $HOME/${dir}
done
echo "Done!\n"



# Configure shell and graphical stuffs
echo "Configuring environment..."

# Make sure background is set
cp $TEMP_DIR/res/bg.png $HOME/.bg.png
echo '#!/bin/sh\nfeh --no-fehbg --bg-fill '$HOME/.bg.png'' > .fehbg

# Configure bash prompt
confirm "replace your current BASH prompt" configbash

# Configure kitty to use correct theming and transparency
mkdir -p $HOME/.config
cp $TEMP_DIR/src/alacritty.toml $HOME/.config/alacritty.toml

echo "Environment configured!\n"



confirm "install additional software" optional_install



# Notify user when script is done
echo "Installation completed successfully.\n\nRun 'startx' to launch DWM."
cd $HOME
