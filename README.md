

# Guide: Installing Arch Linux

![Image Description](images/arch-config.png)

*This guide provides step-by-step instructions on how to install Arch Linux alongside Windows, using GRUB as the bootloader and KDE Plasma as the desktop environment.*

## Connect to wifi
If there is no Ethernet connection available, use the Wi-Fi instead.
```sh
# to manage wireless connections in Linux, use `iwctl` to enter the iwctl mode.
iwctl

# show device:
device list

# show network: (wlan0 is my device)
station wlan0 get-networks

# connect:
station wlan0 connect MyWifiNetwork
```
 
## Configuration to use ssh
```sh
# set password to use ssh:
passwd

# check ip address:
ip -c a
```  


 Update time date: 

```sh
timedatectl set-timezone America/New_York

timedatectl status
```

## Partitions:

 ```sh
 # Check all drive:
lsblk

# Check more information: 
fdisk -l

# Create partition: (nvme0n1 is my drive)
cfdisk /dev/nvme0n1
```

### Create 3 partitions

| Partition | Size  | Type              |
|-----------|-------|-------------------|
| Boot      | 10G-30G | Linux filesystem |
| Root      | Remaining Space | Linux filesystem |
| Swap      | 10G     | Linux swap        |


![Image Description](images/partitions.png)

## Format 3 new partitions:

```sh
# Format Boot and Root partitions:
mkfs.ext4 /dev/nvme0n1p6
mkfs.ext4 /dev/nvme0n1p7

# Format Swap partition: 
mkswap /dev/nvme0n1p8

# Enable Swap partition:
swapon  /dev/nvme0n1p8 
```
