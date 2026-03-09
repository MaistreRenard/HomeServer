{ pkgs, ... }:
let
  secrets = import ../private/secrets.nix;
in
{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };

  systemd.services.tailscale-up = {
    description = "Tailscale up";
    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.tailscale}/bin/tailscale up \
          --advertise-routes=${secrets.tailscaleHome} \
          --accept-routes \
          --snat-subnet-routes=false \
          --ssh \
          --reset
      '';
    };
  };

  # boot.kernel.sysctl = {
  #   "net.ipv4.ip_forward" = 1;
  #   "net.ipv6.conf.all.forwarding" = 1;
  # };
}
