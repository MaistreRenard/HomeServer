{ config, pkgs, ... }:
let
	secrets = import ../private/secrets.nix;
in
{
    # DO NOT COMMIT UN-COMMENTED
    #environment.etc."nextcloud-admin-pass".text = "";

    services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud31;

        hostName = "${secrets.nextcloudHost}";
        datadir = "/mnt/TrueNas-Configuration/nextcloud";

        configureRedis = true;
        enableImagemagick = true;
        https = false;
        maxUploadSize = "16G";

        autoUpdateApps.enable = true;
        appstoreEnable = true;
        extraAppsEnable = true;
        extraApps = with config.services.nextcloud.package.packages.apps; {
            inherit calendar tasks;
        };

        database.createLocally = true;
        config = {
            adminuser = "admin";
            adminpassFile = "/etc/nextcloud-admin-pass";
            dbtype = "pgsql";
        };

        settings = {
            loglevel = 1;
            log_type = "file";
            trusted_domains = secrets.nextcloudDomain;
        };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];

    systemd.services.nextcloud-setup = {
        # Forces prowlarr to wait for the nfs share
        after = [ "mnt-TrueNas\\x2dConfiguration.mount" ];
        requires = [ "mnt-TrueNas\\x2dConfiguration.mount" ];

        serviceConfig = {
            # Allow writes to NFS-mounted config directory.
            # The jellyseerr service has ProtectSystem=strict by default, which makes
            # the entire filesystem read-only except for /dev, /proc, /sys.
            # This exception allows jellyseerr to write to its config directory on the
            # NFS share while maintaining security protections for the rest of the system.
            ReadWritePaths = [ "/mnt/TrueNas-Configuration/nextcloud" ];
        };

        # Force a full stop before restarting when config changes.
        # This is necessary because systemd cannot modify namespace settings
        # (like ReadWritePaths, ProtectSystem, etc.) on a running service.
        # Without this, nixos-rebuild would fail with status=226/NAMESPACE error
        # when trying to hot-reload namespace configuration changes.
        stopIfChanged = true;
    };

    environment.systemPackages = [ pkgs.smbclient ];
}
