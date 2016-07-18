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

  networking.hostName = "mixos";

#for running alsa trough jack
# boot.kernelModules = [ "snd-aloop" ];
#sound.enableMediaKeys = true;

  musnix = {
    enable = true;
    kernel.optimize = true;
    kernel.realtime = true;
    # kernel.packages = pkgs.linuxPackages_4_1_rt;
    /*kernel.latencytop = true;*/
    soundcardPciId = "04:01";
    rtirq.nameList = "rtc0 snd_rme9652";
    rtirq.nonThreaded = "rtc0 snd_rme9652";
    /*rtirq.nameList = "rtc0 usb";*/
    /*rtirq.nameList = "rtc0 hpet usb";*/
    /*rtirq.nameList = "rtc0 hpet snd snd_hda_intel";*/
  };
}
