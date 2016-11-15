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

  services = {
    xserver = {
    autorun =  false;
    windowManager.default = "i3" ;
    windowManager.i3.enable = true;
  };
    nix-serve = {
      enable = true;
      secretKeyFile = "/etc/nix/nix-serve.sec";
    };

  };

  boot.blacklistedKernelModules = [ "mgag200" ];

#for running alsa trough jack
# boot.kernelModules = [ "snd-aloop" ];
#sound.enableMediaKeys = true;

  musnix = {
    alsaSeq.enable = false;
    kernel.optimize = true;
    kernel.realtime = true;
    # kernel.packages = pkgs.linuxPackages_4_1_rt;
    kernel.packages = pkgs.linuxPackages_latest_rt;
    /*kernel.latencytop = true;*/
    # soundcardPciId = "04:01";

    # rtirq.nameList = "rtc0 snd_rme9652";
    rtirq.nameList = "rtc0 snd";
    # rtirq.nameList = "rtc0 snd";

    # rtirq.nonThreaded = "rtc0 snd_rme9652";
    /*rtirq.nameList = "rtc0 usb";*/
    /*rtirq.nameList = "rtc0 hpet usb";*/
    /*rtirq.nameList = "rtc0 hpet snd snd_hda_intel";*/
  };
}
