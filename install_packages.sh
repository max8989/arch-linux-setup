#!/bin/bash
function check_root() {
  # Checking for root access and proceed if it is present
  ROOT_UID=0
  if [[ "${UID}" -eq "${ROOT_UID}" ]]; then
    # Error message
    echo 'Do not run me as root.'
    echo 'Try ./install_packages.sh'
    exit 1
  fi
}

check_root

# Run this command if both Gnome and Hyprland are installed together (fix video rendering issue and firefox crash
# systemctl --user mask xdg-desktop-portal-gnome.service
# systemctl --user restart xdg-desktop-portal.service

# Define a list of packages to install
pacman_packages=(
  "vim"
  "htop"
  "curl"
  "wget"
  "tar"
  "git"
  "libreoffice-fresh"
  "vlc"
  "discord"
  "thunderbird"
  "firefox"
  "torbrowser-launcher"
  "thunderbird"
  "grub-customizer"
  "flatpak"
  "bitwarden"
  "solaar"
  "networkmanager-openvpn",
  "zip",
  "gimp"
  "qbittorrent"
  "zed"
  "lazygit"
  "adobe-source-han-sans-otc-fonts"
  "adobe-source-han-serif-otc-fonts noto-fonts-cjk"
  "obsidian"
  "yazi"
  "neovim"
  "fd"
  "ripgrep"
  "pavucontrol"
)

aur_packages=(
  "neofetch"
  "pamac-aur"
  "timeshift"
  "slack-desktop-wayland"
  "spotify"
  "google-chrome"
  "valent"
  "nwg-look"
  "zen-browser-bin"
)

flatpak_packages=()

read -p "Do you want to enable bluetooth? default(n) (y/n): " enable_bluetooth

if [[ $enable_bluetooth == "y" || $enable_bluetooth == "Y" ]]; then
  pacman_packages+=(
    "bluez"
    "blueman"
    "bluez-utils"
  )
fi

# Prompt to install GNOME packages
read -p "Do you want to install GNOME packages? default(n) (y/n) :" install_gnome

if [[ $install_gnome == "y" || $install_gnome == "Y" ]]; then
  pacman_packages+=(
    "gnome-browser-connector"
    "power-profiles-daemon"
  )

  flatpak_packages+=(
    "flathub"
    "com.mattjakeman.ExtensionManager"
  )
fi

# Prompt to install Wayland packages
read -p "Do you want to install Dev packages? default(n) (y/n): " install_dev

if [[ $install_dev == "y" || $install_dev == "Y" ]]; then
  pacman_packages+=(
    "docker"
    "docker-compose"
    "dotnet-sdk"
    "aspnet-runtime"
    "jdk-openjdk"
  )
  aur_packages+=(
    "aws-cli-v2-bin"
    "rider"
    "postman-bin"
    "datagrip"
    "supabase-bin"
    "prettier"
    "cursor-bin"
    "visual-studio-code-bin"
  )
fi

read -p "Do you want to setup security? default(n) (y/n): " setup_security

if [[ $setup_security == "y" || $setup_security == "Y" ]]; then
  pacman_packages+=(
    "ufw"
  )
fi

read -p "Do you want to install Hyprland? default(n) (y/n): " install_hyprland

if [[ $install_hyprland == "y" || $install_hyprland == "Y" ]]; then
  pacman_packages+=(
    "hyprland"
    "kitty"
    "wofi"
    "waybar"
    "ttf-font-awesome"
    "polkit-gnome" # used to authenticate to use gnome apps
    "brightnessctl"
    "cliphist"
    "wf-recorder"
    "rofi"
    # used to fix screen sharing BEGIN
    "wireplumber"
    "xdg-desktop-portal-hyprland"
    "grim"
    "slurp"
    "pipewire"
    # used to fix screen sharing END
  )

  aur_packages+=(
    "hyprshot"
    "swaync"
    "hyprlock"
    "hypridle"
    "stow"
    "hyprpaper"
    "starship"
    "ttf-cascadia-code-nerd"
    "nwg-look"
    "wlogout"
    "hyprswitch"
    "catppuccin-cursors-frappe"
    "ant-dracula-theme-git"
  )
fi

read -p "Do you want to install Chinese keyboard input support? default(n) (y/n): " enable_chinese_input
if [[ $enable_chinese_input == "y" || $enable_chinese_input == "Y" ]]; then
  pacman_packages+=(
    "fcitx5"
    "fcitx5-rime"
    "fcitx5-configtool"
    "fcitx5-gtk"
    "fcitx5-qt"
    "rime-luna-pinyin"
    "rime-terra-pinyin"
  )
fi

# Update system package database
echo "Updating system package database..."
sudo pacman -Sy

echo "Installing Pacman packages..."
# Loop through the list of packages and install if not already installed
for package in "${pacman_packages[@]}"; do
  if ! pacman -Qi "$package" &>/dev/null; then
    echo "Installing package: $package"
    sudo pacman -S "$package" --noconfirm
  else
    echo "Package $package is already installed."
  fi
done

# Install Yay
if ! yay --version &>/dev/null; then
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
  if yay -Q $package &>/dev/null; then
    echo "Package $package is already installed."
  else
    echo "Installing $package..."
    yay -S "$package" --noconfirm
  fi
done

for package in "${flatpak_packages[@]}"; do
  # Check if the package is already installed
  if flatpak list | grep $package &>/dev/null; then
    echo "Package $package is already installed."
  else
    echo "Installing $package..."
    flatpak install $package
  fi
done

if [[ $enable_bluetooth == "y" ]]; then
  sudo systemctl enable bluetooth
  sudo systemctl start bluetooth
fi

if [[ $install_gnome == "y" ]]; then
  systemctl enable --now power-profiles-daemon.service
  sudo systemctl start power-profiles-daemon.service
fi

if [[ $install_hyprland == "y" ]]; then
  # Fix screen sharing
  exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
  echo 'eval "$(starship init bash)"' >>~/.bashrc
fi

# Add clear alias
echo 'alias c="clear"' >>~/.bashrc

if [[ $setup_security == "y" ]]; then
  # Setup firewall rules
  sudo ufw limit 22/tcp
  sudo ufw allow 80/tcp
  sudo ufw allow 443/tcp
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw enable
fi

if [[ $enable_chinese_input == "y" || $enable_chinese_input == "Y" ]]; then
  # Add Chinese input environment variables
  echo "export GTK_IM_MODULE=fcitx" >>~/.bashrc
  echo "export XMODIFIERS=@im=fcitx" >>~/.bashrc
  echo "export QT_IM_MODULE=fcitx" >>~/.bashrc
fi

source ~/.bashrc

echo "Installation process complete."
