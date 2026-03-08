{ pkgs, ... }:
{
    services.actual = {
        enable = true;
        user = "root";
        openFirewall = true;
        settings = {
            userFiles = "/mnt/TrueNas-Configuration/actual/nicoco";
            serverFiles = "/mnt/TrueNas-Configuration/actual/server";
            dataDir = "/mnt/TrueNas-Configuration/actual/data";
        };
    };

    systemd.services.actual = {
    # Forces prowlarr to wait for the nfs share
    after = [ "mnt-TrueNas\\x2dConfiguration.mount" ];
    requires = [ "mnt-TrueNas\\x2dConfiguration.mount" ];

    serviceConfig = {
      # Allow writes to NFS-mounted config directory.
      # The jellyseerr service has ProtectSystem=strict by default, which makes
      # the entire filesystem read-only except for /dev, /proc, /sys.
      # This exception allows jellyseerr to write to its config directory on the
      # NFS share while maintaining security protections for the rest of the system.
      ReadWritePaths = [ "/mnt/TrueNas-Configuration/actual" ];
    };

    # Force a full stop before restarting when config changes.
    # This is necessary because systemd cannot modify namespace settings
    # (like ReadWritePaths, ProtectSystem, etc.) on a running service.
    # Without this, nixos-rebuild would fail with status=226/NAMESPACE error
    # when trying to hot-reload namespace configuration changes.
    stopIfChanged = true;
  };
}
