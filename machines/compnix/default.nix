{pkgs, config, ...}: with pkgs;
{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
      # machine specific:
      ./machine.nix
      # on every machine:
      ../../common.nix
      # music tweaks and progs:
      # ../../music.nix
      /home/bart/source/musnix/default.nix
    ];

  networking.hostName = "compnix";

  musnix = {
    enable = true;
    kernel.packages = pkgs.linuxPackages_latest_rt;
    #kernel.latencytop = true;
    rtirq.enable = true;
    # machine specific:
    /*soundcardPciId = "00:1b.0";*/
    /*rtirq.nameList = "rtc0 hpet snd snd_hda_intel";*/
    # rtirq.highList = "snd_hrtimer";
    /*rtirq.nonThreaded = "rtc0 snd";*/
    rtirq.resetAll = 1;

    alsaSeq.enable = false;
    kernel.optimize = true;
    kernel.realtime = true;
    # soundcardPciId = "04:01";

    # rtirq.nameList = "rtc0 snd_rme9652";
    # rtirq.nonThreaded = "rtc0 snd_rme9652";
  };

}
