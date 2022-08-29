{ lib, pkgs, config, systemName, ... }:

lib.mkIf (systemName == "nextcloud") {
  networking.interfaces.ens18.ipv4.addresses = [ {
    address = "192.168.114.70";
    prefixLength = 24;
  } ];

  fileSystems."/mnt/storage" = {
    device = "/dev/sdb1";
    fsType = "ext4";
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud24; # Must run maintenance manually on updates! 
    hostName = "192.168.114.70";
    home = "/mnt/storage";
    config = {
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql"; # nextcloud will add /.s.PGSQL.5432 by itself
      dbname = "nextcloud";
      adminpassFile = "/etc/nixos/secrets/nextcloud-admin-pass";
      adminuser = "root";
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
     { name = "nextcloud";
       ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
     }
    ];
  };

  # ensure that postgres is running *before* running the setup
  systemd.services."nextcloud-setup" = {
    requires = ["postgresql.service"];
    after = ["postgresql.service"];
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
