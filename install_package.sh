#!/bin/bash

# Define a list of packages to install
packages=(
    "vim"
    "neofetch"
)

# Update system package database
echo "Updating system package database..."
sudo pacman -Sy

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

# Loop through the list of packages and install if not already installed
for package in "${packages[@]}"; do
    if ! pacman -Qi "$package" &> /dev/null; then
        echo "Installing package: $package"
        sudo pacman -S "$package" --noconfirm
    else
        echo "Package $package is already installed."
    fi
done

echo "Installation process complete."