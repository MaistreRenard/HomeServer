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
  ];

  # Base user
  users.users.nicoco = {
	createHome = true;
	isNormalUser  = true;
	extraGroups = [ "wheel" ];
  home = "/home/nicoco";
  };

  # TODO: Uncomment the following if access to the media server is needed
  # To mount NFS share
  # boot.supportedFilesystems = [ "nfs" ];
  # Media Server
  # fileSystems."/mnt/TrueNas-Media" =
  #   {
  #     device = "${secrets.nasHost}:${secrets.nasExport}";
  #     fsType = "nfs4";
  #   };
  #
  system.stateVersion = "25.05";
}
