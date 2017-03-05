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

  networking.hostName = "compnix";

  musnix = {
    alsaSeq.enable = false;
    kernel.optimize = true;
    kernel.realtime = true;
    # kernel.packages = pkgs.linuxPackages_4_1_rt;
    kernel.packages = pkgs.linuxPackages_latest_rt;
    /*kernel.latencytop = true;*/
    # soundcardPciId = "04:01";

    # rtirq.nameList = "rtc0 snd_rme9652";
    rtirq.nameList = "rtc0 usb";
    # rtirq.nameList = "rtc0 snd";

    # rtirq.nonThreaded = "rtc0 snd_rme9652";
    /*rtirq.nameList = "rtc0 usb";*/
    /*rtirq.nameList = "rtc0 hpet usb";*/
    /*rtirq.nameList = "rtc0 hpet snd snd_hda_intel";*/
  };
}
