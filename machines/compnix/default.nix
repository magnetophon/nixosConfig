{ pkgs, config, ... }: with pkgs;
{
  imports =
    [
      <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
      # machine specific:
      ./machine.nix
      # on every machine:
      ../../common.nix
      # music tweaks and progs:
      ../../music.nix
    ];

  networking.hostName = "compnix";

  musnix = {
    enable = true;
    kernel.packages = pkgs.linuxPackages_latest_rt;
    kernel.optimize = true;
    kernel.realtime = true;
    rtirq.nameList = "rtc0 usb";
  };
}
