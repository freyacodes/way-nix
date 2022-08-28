{ lib, pkgs, config, systemName, ... }:

lib.mkIf (systemName == "nextcloud") {
    networking.interfaces.ens18.ipv4.addresses = [ {
        address = "192.168.114.70";
        prefixLength = 24;
    } ];
}
