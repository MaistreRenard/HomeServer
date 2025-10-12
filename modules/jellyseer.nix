{ pkgs, ... }:
{
  services.jellyseerr = {
    enable = true;
    openFirewall = true;
    configDir = "/mnt/TrueNas-Configuration/jellyseerr";
  };
}
