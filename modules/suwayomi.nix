{ config, lib, pkgs, ... }:
let
  # The version on stable is pretty old so let's use the unstable repo
  unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
in
{
  environment.systemPackages = [ unstable.suwayomi-server ];

  services.suwayomi-server = {
    enable = true;
    package = unstable.suwayomi-server;
    openFirewall = true;
    dataDir = "/mnt/TrueNas-Configuration/suwayomi/config";
    settings = {
            server = {
                downloadAsCbz = true;
                extensionRepo = [
                    "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json"
                ];
            };
    };
  };

  systemd.services.suwayomi-server = {
    # Forces suwayomi to wait for the nfs share
    after = [ "mnt-TrueNas\\x2dConfiguration.mount" ];
    requires = [ "mnt-TrueNas\\x2dConfiguration.mount" ];

    serviceConfig = {
      # Allow writes to NFS-mounted config directory.
      # The jellyseerr service has ProtectSystem=strict by default, which makes
      # the entire filesystem read-only except for /dev, /proc, /sys.
      # This exception allows jellyseerr to write to its config directory on the
      # NFS share while maintaining security protections for the rest of the system.
      ReadWritePaths = [ "/mnt/TrueNas-Configuration/suwayomi" ];
    };

    # Force a full stop before restarting when config changes.
    # This is necessary because systemd cannot modify namespace settings
    # (like ReadWritePaths, ProtectSystem, etc.) on a running service.
    # Without this, nixos-rebuild would fail with status=226/NAMESPACE error
    # when trying to hot-reload namespace configuration changes.
    stopIfChanged = true;
  };
}
