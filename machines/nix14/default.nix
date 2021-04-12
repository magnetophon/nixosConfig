{ pkgs, config, ... }:
with pkgs; {
  imports = [
    /etc/nixos/hardware-configuration.nix
    #<nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    # machine specific:
    ./machine.nix
    # on every machine:
    ../../common.nix
    # music tweaks and progs:
    ../../music.nix
  ];

  networking = { hostName = "nix14"; };

  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = "70";
      STOP_CHARGE_THRESH_BAT0 = "90";
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_BOOST_ON_AC = "1";
      CPU_BOOST_ON_BAT = "0";
      CPU_HWP_DYN_BOOST_ON_AC = "1";
      CPU_HWP_DYN_BOOST_ON_BAT = "0";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CIE_ASPM_ON_AC = "performance";
      CIE_ASPM_ON_BAT = "powersupersave";
      INTEL_GPU_MIN_FREQ_ON_AC = "300";
      INTEL_GPU_MIN_FREQ_ON_BAT = "300";
      INTEL_GPU_MAX_FREQ_ON_AC = "1150";
      INTEL_GPU_MAX_FREQ_ON_BAT = "300";
      INTEL_GPU_BOOST_FREQ_ON_AC = "1150";
      # INTEL_GPU_BOOST_FREQ_ON_BAT = "1150";
      ENERGY_PERF_POLICY_ON_BAT = "powersave";
      # DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = "wifi";
      DEVICES_TO_DISABLE_ON_LAN_CONNECT = "wifi";
      # DEVICES_TO_ENABLE_ON_LAN_DISCONNECT = "wifi";
      # Enable audio power saving for Intel HDA, AC97 devices (timeout in secs).
      # A value of 0 disables, >= 1 enables power saving.
      # Note: 1 is recommended for Linux desktop environments with PulseAudio,
      # systems without PulseAudio may require 10.
      # Default: 1

      SOUND_POWER_SAVE_ON_AC = "0";
      SOUND_POWER_SAVE_ON_BAT = "1";
      # Disable controller too (HDA only): Y/N.
      # Note: effective only when SOUND_POWER_SAVE_ON_AC/BAT is activated.
      # Default: Y
      # SOUND_POWER_SAVE_CONTROLLER = "N";
      USB_EXCLUDE_PHONE = "1";
    };
  };
  # hardware.pulseaudio.enable = true;

  # boot.kernelPackages = pkgs.linuxPackages_4_19;
  boot.kernelPackages = pkgs.linuxPackages_5_10;
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages_testing;

  musnix = {
    # enable = true;
    # kernel.optimize = true;
    # kernel.realtime = true;
    rtirq.nameList = "rtc0 usb";
  };

  # /nix/var/nix/profiles/system-profiles/rt/sw/lib/lv2
  environment.variables = {
    DSSI_PATH   = "$HOME/.dssi:$HOME/.nix-profile/lib/dssi:/run/current-system/sw/lib/dssi";
    LADSPA_PATH = "$HOME/.ladspa:$HOME/.nix-profile/lib/ladspa:/run/current-system/sw/lib/ladspa";
    LV2_PATH    = "$HOME/.lv2:$HOME/.nix-profile/lib/lv2:/run/current-system/sw/lib/lv2";
    LXVST_PATH  = "$HOME/.lxvst:$HOME/.nix-profile/lib/lxvst:/run/current-system/sw/lib/lxvst";
    VST_PATH    = "$HOME/.vst:$HOME/.nix-profile/lib/vst:/run/current-system/sw/lib/vst";
  };
}
