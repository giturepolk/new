#! /bin/sh

################ Let ################
INSTALL="YES"
WINDOWS_SHARE_DIR=from_ubuntu
UBUNTU_SHARE_DIR=~/Desktop/to_windows
DOWNLOAD_DIR=~/Downloads
TOR_VERSION=11.5a8
TOR_SRC=https://www.torproject.org/dist/torbrowser/"$TOR_VERSION"
TOR_FILE=tor-browser-linux64-"$TOR_VERSION"_en-US.tar.xz
TOR_EXTRACT_DIR="$DOWNLOAD_DIR"/tor-browser_en-US
TOR_SHORTCUT=~/Desktop/Tor.sh
ELECTRUM_VERSION=4.1.2
ELECTRUM_SRC=https://download.electrum.org/"$ELECTRUM_VERSION"
ELECTRUM_FILE=Electrum-"$ELECTRUM_VERSION".tar.gz
ELECTRUM_SHORTCUT=~/Desktop/Electrum

################# update ##################
if [ "$INSTALL" = "YES" ]; then
	sudo apt update
	sudo apt upgrade
fi

################# packages ################
if [ "$INSTALL" = "YES" ]; then
	sudo apt-get install python3-pyqt5 --assume-yes
	sudo apt-get install libsecp256k1-0 --assume-yes
	sudo apt-get install python3-cryptography --assume-yes
	sudo apt-get install python3-setuptools --assume-yes
	sudo apt-get install python3-pip --assume-yes
fi

################# Folders #################
if [ ! -d "$UBUNTU_SHARE_DIR" ]; then
	mkdir "$UBUNTU_SHARE_DIR"
fi
if [ ! -d "$DOWNLOAD_DIR" ]; then
	mkdir "$DOWNLOAD_DIR"
fi

########### Mount share folder ############
sudo mount -t vboxsf "$WINDOWS_SHARE_DIR" "$UBUNTU_SHARE_DIR"

################### Tor ###################
cd "$DOWNLOAD_DIR"
if [ ! -d "$TOR_EXTRACT_DIR" ]; then
	echo "Download -> Tor"
	wget "$TOR_SRC"/"$TOR_FILE"
	echo "Extract -> Tor"
	tar -xvJf "$TOR_FILE"
else
	echo "Tor already installed"
fi
cd "$TOR_EXTRACT_DIR"
./start-tor-browser.desktop &

################# electrum #################
cd "$DOWNLOAD_DIR"
if [ ! -f "$ELECTRUM_FILE" ]; then
	echo "Download -> Electrum"
	wget "$ELECTRUM_SRC"/"$ELECTRUM_FILE"
	sudo pip3 install "$DOWNLOAD_DIR"/"$ELECTRUM_FILE"
else
	echo "Electrum already installed"
fi
electrum &

################ shortcuts #################
if [ -f "$ELECTRUM_SHORTCUT" ]; then
	sudo rm -rf "$ELECTRUM_SHORTCUT"
fi
ln -s /usr/local/bin/electrum "$ELECTRUM_SHORTCUT"

if [ -f "$TOR_SHORTCUT" ]; then
	sudo rm -rf "$TOR_SHORTCUT"
fi

echo "#! /bin/sh" >> "$TOR_SHORTCUT"
echo cd "$TOR_EXTRACT_DIR" >> "$TOR_SHORTCUT"
echo "./start-tor-browser.desktop" >> "$TOR_SHORTCUT"
sudo chmod 777 "$TOR_SHORTCUT"

