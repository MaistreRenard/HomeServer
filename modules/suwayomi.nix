{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      suwayomi-server = prev.suwayomi-server.overrideAttrs (oldAttrs: rec {
        version = "2.3.2243";
        src = prev.fetchurl {
          url = "https://github.com/Suwayomi/Suwayomi-Server/releases/download/v${version}/Suwayomi-Server-v${version}.jar";
          hash = "sha256-ghFBsy4XDUoC08vf7Vd+2PB70iOD/19BMuu1rkDpjdU=";
        };
      });
    })
  ];

  services.suwayomi-server = {
    enable = true;
    package = pkgs.suwayomi-server;
    openFirewall = true;
    dataDir = "/mnt/TrueNas-Configuration/suwayomi/config";
    settings = {
            server = {
                downloadAsCbz = true;
                extensionRepo = [
                    "https://github.com/keiyoushi/extensions/raw/repo/index.pb"
                    "https://github.com/yuzono/manga-repo/raw/repo/index.pb"
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
