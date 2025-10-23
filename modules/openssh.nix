{ pkgs, ... }:
{
	services.openssh = {
		enable = true;
		openFirewall = true;
		ports = [ 22 ];
		settings = {
			PasswordAuthentication = true;
			PermitRootLogin = "yes";
			PermitEmptyPasswords = "no";
		};
	};
}
