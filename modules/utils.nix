{ pkgs, ... }:
{
	programs.git = {
		enable = true;
		config = {
			user.name = "Nicolas Wirth";
			user.email = "116091834+MaistreRenard@users.noreply.github.com";
			credential.helper = "store";
			core.editor = "vim";
			format.signoff = "true";
			init.defaultBranch = "main";
		};
	};
}
