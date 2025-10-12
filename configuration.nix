{ config, modulesPath, pkgs, lib, ... }:
let
	home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
	# DO NOT COMMIT
	secrets = import ./private/secrets.nix;
in
{
	imports = [
		(import "${home-manager}/nixos")
		./modules/proxmox-lxc.nix
		./modules/openssh.nix
		./modules/utils.nix
		./modules/neovim.nix
		./modules/tailscale.nix
		./modules/jellyfin.nix
	];
	
	home-manager.useUserPackages = true;
	home-manager.useGlobalPkgs = true;
	home-manager.backupFileExtension = "backup";
	home-manager.users.root = import ./modules/home.nix;
	programs.zsh.enable = true;
	users.defaultUserShell = pkgs.zsh;

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

  system.stateVersion = "25.05";
}
