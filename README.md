

## Connect to wifi adapter
```iwctl ```

### Show Device:
```device list```

### Show network:
```station <device> get-networks```

### Connect:
```station wlan0 connect <Network>```


### Set password to use ssh:
```passwd```

Check ip address:
```ip -c a```  


### Update time date: 

```timedatectl set-timezone America/New_York```

```timedatectl status```

# Create partition:
Check all drive: ```lsblk```
Check more information: ```fdisk -l```

Create partition:
```cfdisk /dev/nvme0n1```

## Create 3 partitions

| Partition | Size  | Type              |
|-----------|-------|-------------------|
| Boot      | 10G-30G | Linux filesystem |
| Root      | 10G-30G | Linux filesystem |
| Swap      | 10G     | Linux swap        |

