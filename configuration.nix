{ config, modulesPath, pkgs, lib, ... }:
let
	home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
	# DO NOT COMMIT
	secrets = import ./private/secrets.nix;
in
{
	imports = [
		(import "${home-manager}/nixos")
		./modules/immich.nix
		./modules/openssh.nix
		./modules/proxmox-lxc.nix
		./modules/tailscale.nix
	];

	home-manager.useUserPackages = true;
	home-manager.useGlobalPkgs = true;
	home-manager.backupFileExtension = "backup";
	home-manager.users.root = import ./modules/home.nix;
	programs.zsh.enable = true;
	users.defaultUserShell = pkgs.zsh;

	# Media Server
	environment.systemPackages = [ pkgs.cifs-utils ];
	fileSystems."/mnt/TrueNas-Photo/share" =
	{
		device = "//${secrets.nasHost}/share";
		fsType = "cifs";
		options = ["credentials=/etc/nixos/private/cifs-share"];
	};
	fileSystems."/mnt/TrueNas-Photo/nicoco" =
	{
		device = "//${secrets.nasHost}/nicoco";
		fsType = "cifs";
		options = ["credentials=/etc/nixos/private/cifs-nicoco"];
	};



	fonts.packages = with pkgs; [
		jetbrains-mono
	];

	system.stateVersion = "25.05";
}
