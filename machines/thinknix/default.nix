{pkgs, config, ...}: with pkgs;
{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
      # machine specific:
      ./machine.nix
      # on every machine:
      ../../common.nix
      # music tweaks and progs:
      ../../music.nix
      #/home/bart/source/musnix/default.nix
    ];

  networking.hostName = "thinknix";

  musnix = {
    alsaSeq.enable = false;
    kernel.optimize = true;
    kernel.realtime = true;
    kernel.packages = pkgs.linuxPackages_latest_rt;
    rtirq.nameList = "rtc0 usb";
  };
}
