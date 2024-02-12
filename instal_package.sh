#!/bin/bash

# Define a list of packages to install
packages=(
    "vim"
    "neofetch"
)

# Update system package database
echo "Updating system package database..."
sudo pacman -Sy

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