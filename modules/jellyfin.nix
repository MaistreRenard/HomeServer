{ pkgs, ... }:
let
  # DO NOT COMMIT
  secrets = import ../private/secrets.nix;
in
{
  services.jellyfin = {
  enable = true;
	openFirewall = true;
	dataDir = "/mnt/TrueNas-Media/jellyfin";
	configDir = "/mnt/TrueNas-Media/jellyfin/config";
  };
}
