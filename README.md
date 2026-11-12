Setup LXC container
```shell
# Source: https://nixos.wiki/wiki/Proxmox_Linux_Container
source /etc/set-environment
passwd --delete root
passwd root
```

Update NixOS channel to unstable
```
nix-channel --add https://nixos.org/channels/nixos-unstable nixos
nix-channel --update
nixos-rebuild switch --upgrade
```

Install GIT:
```shell
nix-channel --update
nix-env -f '<nixpkgs>' -iA git
rm -rf /etc/nixos
git clone https://github.com/MaistreRenard/HomeServer.git /etc/nixos
nixos-rebuild switch
```
