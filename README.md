# Home Server
This repo sets up my Home Server running Proxmox with NixOS LXC containers

In a newly created LXC:
```shell
# Source: https://nixos.wiki/wiki/Proxmox_Linux_Container
source /etc/set-environment
passwd --delete root
```

Install GIT:
```shell
nix-channel --update
nix-env -f '<nixpkgs>' -iA git
rm -rf /etc/nixos
git clone https://github.com/MaistreRenard/HomeServer.git /etc/nixos
```
