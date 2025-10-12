{ pkgs, ... }:
{
  services.jellyfin = {
  enable = true;
	openFirewall = true;
	dataDir = "/mnt/TrueNas-Configuration/jellyfin";
	configDir = "/mnt/TrueNas-Configuration/jellyfin/config";
  };
}
