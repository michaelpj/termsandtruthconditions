# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

  services.openssh.enable = true;

  users.extraUsers.root.openssh.authorizedKeys.keyFiles = [ ../keys/github-mini.pub ];
  users.extraUsers.michael = {
     isNormalUser = true;
     extraGroups = ["wheel"];
     openssh.authorizedKeys.keyFiles = [ ../keys/github-mini.pub ];
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";
}
