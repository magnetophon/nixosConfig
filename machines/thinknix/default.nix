{ pkgs, config, ... }:
with pkgs; {
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    # machine specific:
    ./machine.nix
    # on every machine:
    ../../common.nix
    # music tweaks and progs:
    ../../music.nix
  ];

  networking = { hostName = "thinknix"; };

  services.tlp.enable = true;

  # hardware.pulseaudio.enable = true;

  # boot.kernelPackages = pkgs.linuxPackages_latest;

  musnix = {
    # enable = true;
    # kernel.optimize = true;
    # kernel.realtime = true;
    rtirq.nameList = "rtc0 usb";
  };
}
