<<<<<<< HEAD
# Home Server
This repo sets up my Home Server running Proxmox with NixOS LXC containers

In a newly created LXC:
```shell
# Source: https://nixos.wiki/wiki/Proxmox_Linux_Container
source /etc/set-environment
passwd --delete root
```

Install GIT:
=======
# CT-NixOS-Jellyseerr
This is my Jellyseerr LXC container running on NixOS. To build run:
>>>>>>> 41da472 (CT-NixOS-Jellyseerr: Initial configuration)
```shell
nixos-rebuild switch
```
