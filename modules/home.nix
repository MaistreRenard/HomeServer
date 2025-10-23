{ pkgs, ... }:
let
  devConf = pkgs.fetchgit {
    url = "https://github.com/MaistreRenard/devconf-base.git";
    rev = "main";
    sha256 = "sha256-WYw3ehz/ewuyi4LkF8gxgK+U5qTceN/Nx8biSQXr9LQ=";
  };
in
  {
  programs.home-manager.enable = true;

  home.stateVersion = "25.05";

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    withNodeJs = true;
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "fzf" "sudo" "z" ];
      theme = "powerlevel10k/powerlevel10k";
    };

    history.size = 10000;
  };

  home.packages = with pkgs; [ fd gcc git gnumake lazygit
    ranger ripgrep tig unzip zsh-powerlevel10k ];

  home.file.".config/nvim".source = "${devConf}/src/.config/nvim" ;
  home.file.".gitconfig".source = "${devConf}/src/.gitconfig" ;
  home.file.".zshrc".source = "${devConf}/src/.zshrc" ;
  home.file.".oh-my-zsh".source = "${pkgs.oh-my-zsh}/share/oh-my-zsh" ;
  home.file."powerlevel10k".source = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k" ;
}
