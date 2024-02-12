#!/bin/bash

# Define a list of packages to install
pacman_packages=(
    "vim"
    "neofetch"
    "htop"
    "curl"
    "wget"
    "tar"
    "git"
    "jdk-openjdk"
    "libreoffice-fresh"
    "vlc"

    # Blutooth
    "bluez"
    "blueman"
    "bluez-utils"

    # Gnome extensions
    "gnome-shell"
    "gnome-tweaks"
)

aur_packages=(
    "pamac-aur"
    "brave-bin"
    "visual-studio-code-bin"
    "timeshift"
)

# Update system package database
echo "Updating system package database..."
sudo pacman -Sy

echo "Installing Pacman packages..."
# Loop through the list of packages and install if not already installed
for package in "${pacman_packages[@]}"; do
    if ! pacman -Qi "$package" &> /dev/null; then
        echo "Installing package: $package"
        sudo pacman -S "$package" --noconfirm
    else
        echo "Package $package is already installed."
    fi
done

# Install Yay
if ! yay --version &> /dev/null; then
    echo "yay is not installed, proceeding with installation..."
    # Install base-devel and git if they are not already installed
    sudo pacman -S --needed base-devel git

    # Temporarily change to a temporary directory for yay installation
    pushd "$(mktemp -d)" || exit 1

    # Clone yay from AUR
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit 1

    # Build and install yay
    makepkg -si

    # Return to the original directory
    popd
fi

echo "Installing AUR packages..."
# Loop through the list and install each package if it is not already installed
for package in "${aur_packages[@]}"; do
    # Check if the package is already installed
    if yay -Q $package &> /dev/null; then
        echo "Package $package is already installed."
    else
        echo "Installing $package..."
        yay -S "$package" --noconfirm
    fi
done

echo "Installation process complete."