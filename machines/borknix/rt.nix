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

  networking.hostName = "borknix-rt";

  musnix = {
    /*soundcardPciId = "00:1b.0";*/
    /*rtirq.nameList = "rtc0 hpet snd snd_hda_intel";*/
    soundcardPciId = "00:1b.0";
    rtirq.nameList = "rtc0 hpet snd snd_hda_intel";
  };
}
