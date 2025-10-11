{ modulesPath,... }:
{
  # https://nixos.wiki/wiki/Proxmox_Linux_Container
  imports = [ (modulesPath + "/virtualisation/proxmox-lxc.nix") ];

  proxmoxLXC = {
    manageNetwork = false;
    privileged = true;
  };

  # LXC builds usually need sandbox off
  nix.settings.sandbox = false;

  # Let Proxmox host handle fstrim
  services.fstrim.enable = false;

  # Cache DNS lookups to improve performance
  services.resolved = {
    extraConfig = ''
      Cache=true
      CacheFromLocalhost=true
    '';
  };
}
