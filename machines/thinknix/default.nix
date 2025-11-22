{ pkgs, config, ... }:
with pkgs; {
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    # machine specific:
    ./machine.nix
    # on every machine:
    ../../common.nix
    # non realtime:
    ../../commonNonRT.nix
    # music tweaks and progs:
    ../../music.nix
  ];

  networking = { hostName = "thinknix"; };

  services.tlp.enable = true;

  # hardware.pulseaudio.enable = true;

  # boot.kernelPackages = pkgs.linuxPackages_4_19;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages_testing;

  musnix = {
    # enable = true;
    # kernel.optimize = true;
    # kernel.realtime = true;
    rtirq.nameList = "rtc0 usb";
  };

  # /nix/var/nix/profiles/system-profiles/rt/sw/lib/lv2
  environment.variables = {
    DSSI_PATH = "$HOME/.dssi:$HOME/.nix-profile/lib/dssi:/run/current-system/sw/lib/dssi";
    LADSPA_PATH = "$HOME/.ladspa:$HOME/.nix-profile/lib/ladspa:/run/current-system/sw/lib/ladspa";
    LV2_PATH = "$HOME/.lv2:$HOME/.nix-profile/lib/lv2:/run/current-system/sw/lib/lv2";
    LXVST_PATH = "$HOME/.lxvst:$HOME/.nix-profile/lib/lxvst:/run/current-system/sw/lib/lxvst";
    VST_PATH = "$HOME/.vst:$HOME/.nix-profile/lib/vst:/run/current-system/sw/lib/vst";
  };
}
