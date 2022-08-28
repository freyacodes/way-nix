# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  systemName = builtins.head (builtins.match "([[:alnum:]]+).*" (builtins.readFile ./name));
in {
  _module.args.systemName = systemName;
  networking.hostName = systemName;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./hosts/nextcloud.nix
    ];

  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.systemd-boot.enable = true;

  networking.networkmanager.enable = true;
  networking.defaultGateway = "192.168.114.1";
  networking.nameservers = [ "1.1.1.1" ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "dk";
  };

  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     thunderbird
  #   ];
  # };

  environment.systemPackages = with pkgs; [
    nano
    wget
    htop
    glances
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDhT4P2Nd0e0VG4aFcX82GnHYnPlsUndpqBPAeeaVcxjLX1G8bG16dN3vJNfHKBz6oj3vmZUqZqUZgFeMgSgTaOTtTi5WUTK+RKd4/RrJFwGT12WXyr8/97GBp3ZiTgtELOxY2ThkRpqtuj+gHU935uYAIhkxATCanx14Pec5JLVeLrIItwata2A5p5IrSkiIufPNI+G27IsdMqw6U8OY3Kx03m9QI8QYXaPq9pDtw0DAzr0paPh3qFp+TGe0fyLeApnpefwiHGW2rJZ/DlM5fZ3ITS3j4ljtw+y0bVxsQB8MumESqy84VG8olT87TDLKvtkpXO0IWh+CwMRZuNtGEx" ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

