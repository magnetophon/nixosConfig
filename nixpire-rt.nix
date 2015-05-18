{pkgs, config, ...}: with pkgs;
{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
      # machine specific:
      ./aspire.nix
      # on every machine:
      ./common.nix
      # music tweaks and progs:
      ./music.nix
    ];

  hostName = "nixpire-rt";
}

