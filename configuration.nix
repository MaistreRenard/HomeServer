{ config, modulesPath, pkgs, lib, ... }:
let
	# DO NOT COMMIT
	secrets = import ./private/secrets.nix;
in
	{
	imports = [
		./modules/proxmox-lxc.nix
		./modules/openssh.nix
		./modules/utils.nix
		./modules/neovim.nix
		./modules/tailscale.nix
		./modules/qbittorrent.nix
	];

	# Base user
	users.users.nicoco = {
		createHome = true;
		isNormalUser  = true;
		extraGroups = [ "wheel" ];
		home = "/home/nicoco";
	};

	# To mount NFS share
	 boot.supportedFilesystems = [ "nfs" ];

	 # Media Server
	 fileSystems."/mnt/TrueNas-Media" =
	   {
	     device = "${secrets.nasHost}:${secrets.nasMedia}";
	     fsType = "nfs4";
	   };

	 # Configuration
	 fileSystems."/mnt/TrueNas-Configuration" =
	   {
	     device = "${secrets.nasHost}:${secrets.nasConf}";
	     fsType = "nfs4";
	   };

	# Tailscale route
	systemd.services.secondGateway = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Setup additional Gateway";
      path = [pkgs.bash pkgs.iproute2];
      script = ''
             ip route add ${secrets.tailscaleSubnet}/8 via ${secrets.tailscaleHost}
             '';
      serviceConfig = {
        Type= "oneshot";
        User = "root";
        Restart = "no";
      };
   };

	system.stateVersion = "25.05";
}
