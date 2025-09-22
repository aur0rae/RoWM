#!/usr/bin/env bash
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
#
# Check if this is running with root permissions - it should not be
if [[ "$EUID" = 0 ]]; then
	echo "Running this script as root may break things. Please run without superuser permissions."
	sleep 10
        exit
else
        # Set working directory
        TEMP_DIR=$(pwd)
fi

# Refresh mirrors and install dependencies
deb_install() {
	sudo apt update
	sudo apt install -y xorg build-essential libxft-dev libxinerama-dev wget git \
                            amixer pipewire pipewire-pulse wireplumber network-manager \
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

# Determine distribution
echo "Determining distribution and package manager."

if [[ -f "/etc/os-release" ]]; then
	source /etc/os-release
	case "$ID" in
		debian|ubuntu)
			echo "$ID detected. Using apt to update, install dependancies, and configure Nala..."
			deb_install
			;;
		arch|endeavour|manjaro)
			echo "Unsupported. TODO: Implement Arch Install"
			arch_install
			;;
		*)
			echo "Error: Unsupported distribution. Exiting..."
			sleep 10
                        exit
			;;
	esac
else
	echo "Error: /etc/os-release not found. Exiting."
        sleep 10
	exit
fi

# Install DWM, Dmenu, and SLStatus
echo "Compiling DWM and other suckless software."

for suckless in dwm dmenu slstatus; do
        if [[ ! -d "$HOME/.${suckless}" ]]; then
	        cp -r $TEMP_DIR/src/${suckless} $HOME/.${suckless}
	        cd $HOME/.${suckless}
 	        make
	        sudo make clean install
        else
                echo "Error: ${suckless} is already installed to ~/.${suckless}! Skipping..."
        fi
done

# Return to expected working directory
cd $TEMP_DIR

# Configure Xorg
echo "Configuring Xorg to launch DWM"

if [[ ! -f "$HOME/.xinitrc" ]]; then
	echo -e '#!/bin/sh\nexec dwm' > ~/.xinitrc;
else
	echo "Error: ~/.xinitrc already exists. Skipping...";
fi

while true; do
        read -p "Would you like to start DWM on login? (Y)es/(N)o: " launchdwm
        case "$launchdwm" in
                [yY][eE][sS]|[yY] )
                        echo -e 'if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then\n\tstartx\nfi' > ~/.bash_profile
                        echo "Done!"
                        break
                ;;
                [nN][oO]|[nN]|[\n] )
                        echo "Skipping..."
                        break
                ;;
                * )
                        echo "Error: unrecognized input."
                ;;
        esac
done

# Make directories
echo "Populating home directory."
for dir in Desktop Documents Downloads Music Pictures Projects Videos; do
	mkdir -p $HOME/${dir}
done

# Configure shell and graphical stuffs
echo "Configuring environment."

# Make sure background is set
cp $TEMP_DIR/res/bg.png $HOME/.bg.png
echo -e '#!/bin/sh\nfeh --no-fehbg --bg-fill '$HOME/.bg.png'' > .fehbg

# Configure bash prompt
rm $HOME/.bashrc
cp $TEMP_DIR/src/bashrc $HOME/.bashrc

# Configure kitty to use correct theming and transparency
mkdir -p $HOME/.config
cp $TEMP_DIR/src/alacritty.toml $HOME/.config/alacritty.toml

# Optionally install additional packages
optional_install() {
        # TODO: Implement script to install extra apps
}

while true; do
	read -p "Install additional software? (Y)es/(N)o: " extra
	case "$extra" in
                [yY][eE][sS]|[yY])
                        echo "Sorry, feature not yet implemented!"
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

# Notify user when script is done
echo -e 'Installation completed successfully.\n\nRun "startx" to launch DWM.'
cd $HOME
