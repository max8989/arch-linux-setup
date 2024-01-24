

## Guide: Installing Arch Linux with GRUB KDE Plasma Dual Booted with Windows

*This guide provides step-by-step instructions on how to install Arch Linux alongside Windows, using GRUB as the bootloader and KDE Plasma as the desktop environment.*

## Connect to wifi
```
iwctl
 ```

 Show Device:
```
device list
```

 Show network:
```
station <device> get-networks
```

 Connect:
```
station wlan0 connect <Network>
```


 Set password to use ssh:
```
passwd
```

Check ip address:
```
ip -c a
```  


 Update time date: 

```
timedatectl set-timezone America/New_York
```

```
timedatectl status
```

## Partitions:
Check all drive:
 ```
lsblk
```
Check more information: 
```
fdisk -l
```

Create partition:
```
cfdisk /dev/nvme0n1
```

### Create 3 partitions

| Partition | Size  | Type              |
|-----------|-------|-------------------|
| Boot      | 10G-30G | Linux filesystem |
| Root      | Remaining Space | Linux filesystem |
| Swap      | 10G     | Linux swap        |


![Image Description](images/partitions.png)

 Format Boot and Root partitions:
```
mkfs.ext4 /dev/nvme0n1p6
mkfs.ext4 /dev/nvme0n1p7
```

 Format Swap partition: 
```
mkswap /dev/nvme0n1p8
```

 Enable Swap partition:
```
swapon  /dev/nvme0n1p8 
```
