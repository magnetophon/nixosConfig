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
    ];

  networking.hostName = "borknix";

#for running alsa trough jack
boot.kernelModules = [ "snd-aloop" ];
#sound.enableMediaKeys = true;

# save battery when not RT:
services.tlp.enable = true;

  musnix = {
    enable = false;
    kernel.optimize = true;
    kernel.realtime = true;
    /*kernel.packages = pkgs.linuxPackages_4_1_rt;*/
    /*kernel.latencytop = true;*/
    #soundcardPciId = "00:1d.7";
    rtirq.nameList = "rtc0 23";
    rtirq.nonThreaded = "rtc0 23";
    /*rtirq.nameList = "rtc0 usb";*/
    /*rtirq.nameList = "rtc0 hpet usb";*/
    /*rtirq.nameList = "rtc0 hpet snd snd_hda_intel";*/
  };
}
