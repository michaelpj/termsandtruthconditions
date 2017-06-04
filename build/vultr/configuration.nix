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

  users.extraUsers.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDDHhvNnhz1VtgXvFpZ9L5HRIvqr+JaOnTvCHEWVlR1XG29Ee67AN/ZqB44fdpFVUOplMoK+QsS+4nCLKpCEcoHdKgTDtxiKdAHHmjZCtcADuo3rMw5icyg0xPH6HWKROWAwqzUb0pjTD6dwuYWVuOav37zlKyubFNGsP52Uu5hh41XTZAFud3G1k+QmzHC3kPsW7PURi8WmvXOv39yymldXpCsNW7Ym0My9wccL+sID5WYYn3o0XAH52uTNPTzlvW2+/EQugbpXY0VR2z47Qdu4EDpB1qmzciwgeW3YZAjc+WfrOSajsAwRO4PbwP8ZxnMVnCTIk3wVnVKxGOrqnpS/VXExJrJ6+xfqDwKY9Emm7OPE2t1QwJaiOssztEnxz6x7TSoWgAashRcy2hY30Glb0zy47pOODZgcvGxmHvsGfT5GCNHmYm80wjSCB0FEWIhS5pA2spzYXywt257N41PlrcxICV4g4ZOZngSGzwn1sV9eALSIzprMOc5nqFiNI8nzK/h/3gjRRKt1tnIB7IWNYi7sgl974CiJsZwNOWa+mOb/azB+vlGKtjk7yztuPxOGLi7qsFgHb4bzXWMWM0p0UG2XsvVvjmDxBVndgrtVbbpCr3Da1UyNmV+TKUqu/IVFSgnXP9hkshiG6LSra8spQgYfqtBEbzoaqb1wy+hCw=="
  ];
  users.extraUsers.michael = {
     isNormalUser = true;
     extraGroups = ["wheel"];
     uid = 1000;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";
}
