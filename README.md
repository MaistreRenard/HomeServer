# Home Server
This repo sets up my Home Server running Proxmox with NixOS LXC containers

Install GIT:
```shell
nix-channel --update
nix-env -f '<nixpkgs>' -iA git
rm -rf /etc/nixos
git clone https://github.com/MaistreRenard/HomeServer.git /etc/nixos
```
