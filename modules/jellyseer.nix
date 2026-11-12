{ pkgs, ... }:
{
  services.seerr = {
    enable = true;
    openFirewall = true;
}
