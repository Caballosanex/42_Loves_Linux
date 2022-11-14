#!/bin/sh

echo "Welcome to the installation script of the Moulinette project."
echo "This script will install the 42 most common tools and its dependencies."

# Install Repositories and Packages, Update and Upgrade the system and install the 42 most common tools
echo "Installing Francinette and its dependencies..."
echo "Adding the repository to the sources list..."
	sudo apt-add-repository universe
	sudo apt-add-repository restricted
	sudo apt-add-repository main
echo "Done."
echo "Updating the sources list..."
	sudo apt-get update -y
	sudo apt-get upgrade -y
echo "Done."
echo "Installing the dependencies..."
sudo apt-get install python3 curl wget git -y

#Francinette installation

cd "$HOME" || exit

mkdir temp_____

cd temp_____ || exit
rm -rf francinette

# download github
git clone --recursive https://github.com/xicodomingues/francinette.git

if [ "$(uname)" != "Darwin" ]; then
	echo "Admin permissions needed to install C compilers, python, and upgrade current packages"
	case $(lsb_release -is) in
		"Ubuntu")
			sudo apt update -y
			sudo apt upgrade -y
			sudo apt install gcc clang libpq-dev libbsd-dev libncurses-dev valgrind -y
			sudo apt install python3-pip -y
			sudo apt install python3-dev python3-venv python3-wheel -y
			pip3 install wheel
			;;
		"Arch")
			sudo pacman -Syu
			sudo pacman -S gcc clang postgresql libbsd ncurses valgrind --noconfirm
			sudo pacman -S python-pip --noconfirm
			pip3 install wheel
			;;
	esac
fi

cp -r francinette ..

cd "$HOME" || exit
rm -rf temp_____

cd "$HOME"/francinette || exit

# start a venv inside francinette
if ! python3 -m venv venv ; then
	echo "Please make sure than you can create a python virtual environment"
	echo 'Contact the creator of Francinette if you have no idea how to proceed (fsoares- on slack)'
	exit 1
fi

# activate venv
. venv/bin/activate

# install requirements
if ! pip3 install -r requirements.txt ; then
	echo 'Problem launching the installer. Contact the creator of Francinette (fsoares- on slack)'
	exit 1
fi

RC_FILE="$HOME/.zshrc"

if [ "$(uname)" != "Darwin" ]; then
	RC_FILE="$HOME/.bashrc"
	if [[ -f "$HOME/.zshrc" ]]; then
		RC_FILE="$HOME/.zshrc"
	fi
fi

echo "try to add alias in file: $RC_FILE"

# set up the alias
if ! grep "francinette=" "$RC_FILE" &> /dev/null; then
	echo "francinette alias not present"
	echo "\nalias francinette=~/francinette/tester.sh\n" "$HOME" >> "$RC_FILE"
fi

if ! grep "paco=" "$RC_FILE" &> /dev/null; then
	echo "Short alias not present. Adding it"
	echo "\nalias paco=~/francinette/tester.sh\n" "$HOME" >> "$RC_FILE"
fi

# print help
"$HOME"/francinette/tester.sh --help

echo "Francinette installation Complete. Proceeding to the next step."

# Moulinette installation

echo "export PATH="$HOME/.local/bin:$PATH" >> ~/.profile
python3 -m pip install --upgrade pip setuptools
python3 -m pip install norminette

echo "Moulinette installation Complete. Proceeding to the next step."

# Utils installation.
echo "Installing Utils..."
sudo apt-get install vim -y
echo "Done."
echo "Installation Complete. Close this window to make everything work."