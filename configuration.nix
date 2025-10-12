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
		./modules/jellyseer.nix
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

	# Configuration
	fileSystems."/mnt/TrueNas-Configuration" =
		{
			device = "${secrets.nasHost}:${secrets.nasConf}";
			fsType = "nfs4";
		};

	system.stateVersion = "25.05";
}
