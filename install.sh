#! /bin/sh

################ Let ################
INSTALL="YES"
WINDOWS_SHARE_DIR=from_ubuntu
UBUNTU_SHARE_DIR=~/Desktop/to_windows
DOWNLOAD_DIR=~/Downloads
GIT_SRC=https://raw.githubusercontent.com/giturepolk/new/main/
TOR_FILE=tor-browser-linux64-11.0.14_en-US.tar.xz
TOR_EXTRACT_DIR="$DOWNLOAD_DIR"/tor-browser_en-US
TOR_SHORTCUT=~/Desktop/Tor.sh
ELECTRUM_FILE=Electrum-4.2.2.tar.gz
ELECTRUM_SHORTCUT=~/Desktop/Electrum

################# update ##################
if [ "$INSTALL" = "YES" ]; then
	sudo apt update
	sudo apt upgrade
fi

################# packages ################
if [ "$INSTALL" = "YES" ]; then
	sudo apt-get isntall tor --assume-yes
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
	wget "$GIT_SRC"/tor_browser.partaa
	wget "$GIT_SRC"/tor_browser.partab
	wget "$GIT_SRC"/tor_browser.partac
	wget "$GIT_SRC"/tor_browser.partad
	echo "Extract -> Tor"
	cat tor_browser.part* > "$TOR_FILE"
	tar -xvJf "$TOR_FILE"
else
	echo "Tor already installed, if not, delete the folder"
fi
cd "$TOR_EXTRACT_DIR"
./start-tor-browser.desktop &

################# electrum #################
cd "$DOWNLOAD_DIR"
if [ ! -f "$ELECTRUM_FILE" ]; then
	echo "Download -> Electrum"
	wget "$GIT_SRC"/"$ELECTRUM_FILE"
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

