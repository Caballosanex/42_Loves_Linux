#!/bin/sh

void show_interface() {
    echo "Welcome to the installation script of the Moulinette project.
";
    echo "This script will install the 42 most common tools and its dependencies.
";
    echo "Choose one of the following options:
";
    echo "1. Install All
";
    echo "2. Install Francinette and dependencies
";
    echo "3. Install Moulinette and dependencies
";
    echo "4. Install C language and dependencies
";
    echo "5. Exit
";
    echo "Choose one of the following options: ";
}

#***************Francinette installation function***************#
void install_francinette() {
	echo "Installing Francinette and its dependencies...
";
	echo "Adding the repository to the sources list...";
sudo add-repository multiverse
sudo add-repository universe
sudo add-repository restricted
sudo add-repository main
echo "Done.";
echo "Updating the sources list...";
sudo apt-get update
sudo apt-get upgrade
echo "Done.";
echo "Installing the dependencies...";
sudo apt-get install python3 curl wget git python3-pip python3-dev gcc clang libpq-dev libbsd-dev libncurses-dev valgrind python3-venv python3-wheel -y
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
			sudo apt update
			sudo apt upgrade
			sudo apt install gcc clang libpq-dev libbsd-dev libncurses-dev valgrind -y
			sudo apt install python-dev python3-pip -y
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
	echo "\nalias francinette=%s/francinette/tester.sh\n" "$HOME" >> "$RC_FILE"
fi

if ! grep "paco=" "$RC_FILE" &> /dev/null; then
	echo "Short alias not present. Adding it"
	echo "\nalias paco=%s/francinette/tester.sh\n" "$HOME" >> "$RC_FILE"
fi

# print help
"$HOME"/francinette/tester.sh --help

echo "Installation Complete. Please close this terminal window and open the terminal again for francinette to work"
}

#***************Moulinette installation function***************#
void install_moulinette() {
    echo "Installing Moulinette...
";
    echo "Installing Python3...
";
    sudo apt-get install python3
    echo "Installing Python3-pip...
";
    sudo apt-get install python3-pip
    echo "Installing Python3-venv...
";
    sudo apt-get install python3-venv
    echo "Installing Moulinette...
";
    sudo apt install moulinette
    echo "Moulinette installed successfully.
";
}

#***************C language installation function***************#
void install_c_language() {
    echo "Installing C language...
";
    echo "Installing GCC...
";
    sudo apt-get install gcc
    echo "Installing GDB...
";
    sudo apt-get install gdb
    echo "Installing Valgrind...
";
    sudo apt-get install valgrind
    echo "Installing C language successfully.
";
}

#***************Main function***************#
void main() {
    show_interface();
    int option;
    scanf("%d", &option);
    switch(option) {
        case 1:
            install_francinette();
            install_moulinette();
            install_c_language();
            break;
        case 2:
            install_francinette();
            break;
        case 3:
            install_moulinette();
            break;
        case 4:
            install_c_language();
            break;
        case 5:
            echo "Exiting...
";
            break;
        default:
            echo "Invalid option.
";
            break;
    }
}