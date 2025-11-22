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

  hostName = "nixpire-rt";


  musnix = {
    enable = true;
    kernel.packages = pkgs.linuxPackages_latest_rt;
    kernel.optimize = true;
    kernel.realtime = true;
    soundcardPciId = "00:1b.0";
    rtirq.nameList = "rtc0 hpet snd snd_hda_intel";
  };
}
