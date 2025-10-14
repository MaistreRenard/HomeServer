{ pkgs, ... }:
{
  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };

  systemd.services.prowlarr = {
    serviceConfig = {
      # Looks like prowlarr do not have an option dataDir or confDir.
      # Let's setup from the service config
      ExecStart = lib.mkForce "${lib.getExe pkgs.prowlarr} -nobrowser -data=/mnt/TrueNas-Configuration/prowlarr";
      StateDirectory = lib.mkForce "";


      # Allow writes to NFS-mounted config directory.
      # The jellyseerr service has ProtectSystem=strict by default, which makes
      # the entire filesystem read-only except for /dev, /proc, /sys.
      # This exception allows jellyseerr to write to its config directory on the
      # NFS share while maintaining security protections for the rest of the system.
      ReadWritePaths = [ "/mnt/TrueNas-Configuration/prowlarr" ];
    };

    # Force a full stop before restarting when config changes.
    # This is necessary because systemd cannot modify namespace settings
    # (like ReadWritePaths, ProtectSystem, etc.) on a running service.
    # Without this, nixos-rebuild would fail with status=226/NAMESPACE error
    # when trying to hot-reload namespace configuration changes.
    stopIfChanged = true;
  };
}
