{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;   # makes `editor` and many tools use nvim
    vimAlias = true;        # `vim` -> nvim
    viAlias = true;         # `vi` -> nvim
    withNodeJs = true;      # useful for LSPs/formatters inside nvim
  };
}
