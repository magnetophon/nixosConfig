{pkgs, config, ...}: with pkgs;
{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
      # machine specific:
      ./bork.nix
      # on every machine:
      ./common.nix
      # music tweaks and progs:
      ./music.nix
    ];

  networking.hostName = "borknix-rt";
}

