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

  musnix = {
    enable = true;
    # kernel.optimize = true;
    # kernel.realtime = true;
    rtirq.nameList = "rtc0 23";
    rtirq.nonThreaded = "rtc0 23";
  };
}
