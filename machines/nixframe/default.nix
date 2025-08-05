{ pkgs, config, ... }:
with pkgs; {
  imports = [
    ./hardware-configuration.nix
    #<nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    # machine specific:
    ./machine.nix
    # on every machine:
    ../../common.nix
    # non realtime:
    ../../commonNonRT.nix
    # music tweaks and progs:
    ../../music.nix
  ];

  networking = { hostName = "nixframe"; };

  services = {
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = "70";
        STOP_CHARGE_THRESH_BAT0 = "90";
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        # CPU_BOOST_ON_AC = "1";
        CPU_BOOST_ON_BAT = "0";
        # CPU_HWP_DYN_BOOST_ON_AC = "1";
        CPU_HWP_DYN_BOOST_ON_BAT = "0";
        # CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        # CIE_ASPM_ON_AC = "performance";
        CIE_ASPM_ON_BAT = "powersupersave";
        # INTEL_GPU_MIN_FREQ_ON_AC = "300";
        INTEL_GPU_MIN_FREQ_ON_BAT = "100";
        # INTEL_GPU_MAX_FREQ_ON_AC = "1300";
        INTEL_GPU_MAX_FREQ_ON_BAT = "300";
        # INTEL_GPU_BOOST_FREQ_ON_AC = "1300";
        INTEL_GPU_BOOST_FREQ_ON_BAT = "300";

        PCIE_ASPM_ON_BAT = "powersupersave";

        ENERGY_PERF_POLICY_ON_BAT = "powersave";
        # DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = "wifi";
        DEVICES_TO_DISABLE_ON_LAN_CONNECT = "wifi";
        DEVICES_TO_ENABLE_ON_LAN_DISCONNECT = "wifi";

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
        # USB_EXCLUDE_PHONE = "1";
        # not needed because of https://github.com/NixOS/nixos-hardware/commit/bf212c4ef57b100c97735a210a3895d3dcc69aa9
        # USB_DENYLIST="0bda:8156";
      };
    };
    thermald = {
      enable = true;
      # configFile = builtins.toFile "thermal-conf.xml" ''
      # <?xml version="1.0"?>
      # <!-- BEGIN -->
      # <ThermalConfiguration>
      # <Platform>
      # <Name> Auto generated </Name>
      # <ProductName>Laptop (12th Gen Intel Core)</ProductName>
      # <Preference>QUIET</Preference>
      # <PPCC>
      # <PowerLimitIndex>0</PowerLimitIndex>
      # <PowerLimitMinimum>5000</PowerLimitMinimum>
      # <PowerLimitMaximum>30000</PowerLimitMaximum>
      # <TimeWindowMinimum>30000</TimeWindowMinimum>
      # <TimeWindowMaximum>30000</TimeWindowMaximum>
      # <StepSize>100</StepSize>
      # </PPCC>
      # <ThermalZones>
      # <ThermalZone>
      # <Type>auto_zone_0</Type>
      # <TripPoints>
      # <TripPoint>
      # <SensorType>SEN3</SensorType>
      # <Temperature>45000</Temperature>
      # <Type>Passive</Type>
      # <CoolingDevice>
      # <Type>B0D4</Type>
      # <SamplingPeriod>3</SamplingPeriod>
      # <TargetState>15000000</TargetState>
      # </CoolingDevice>
      # </TripPoint>
      # <TripPoint>
      # <SensorType>SEN3</SensorType>
      # <Temperature>75000</Temperature>
      # <Type>Passive</Type>
      # <CoolingDevice>
      # <Type>B0D4</Type>
      # <SamplingPeriod>3</SamplingPeriod>
      # <TargetState>15000000</TargetState>
      # </CoolingDevice>
      # </TripPoint>
      # <TripPoint>
      # <SensorType>SEN3</SensorType>
      # <Temperature>78000</Temperature>
      # <Type>Passive</Type>
      # <CoolingDevice>
      # <Type>B0D4</Type>
      # <SamplingPeriod>3</SamplingPeriod>
      # <TargetState>12000000</TargetState>
      # </CoolingDevice>
      # </TripPoint>
      # <TripPoint>
      # <SensorType>SEN3</SensorType>
      # <Temperature>80000</Temperature>
      # <Type>Passive</Type>
      # <CoolingDevice>
      # <Type>B0D4</Type>
      # <SamplingPeriod>3</SamplingPeriod>
      # <TargetState>10000000</TargetState>
      # </CoolingDevice>
      # </TripPoint>
      # <TripPoint>
      # <SensorType>SEN3</SensorType>
      # <Temperature>85000</Temperature>
      # <Type>Passive</Type>
      # <CoolingDevice>
      # <Type>B0D4</Type>
      # <SamplingPeriod>3</SamplingPeriod>
      # </CoolingDevice>
      # </TripPoint>
      # </TripPoints>
      # </ThermalZone>
      # <ThermalZone>
      # <Type>auto_zone_1</Type>
      # <TripPoints>
      # <TripPoint>
      # <SensorType>SEN5</SensorType>
      # <Temperature>90000</Temperature>
      # <Type>Passive</Type>
      # <CoolingDevice>
      # <Type>B0D4</Type>
      # <SamplingPeriod>3</SamplingPeriod>
      # </CoolingDevice>
      # </TripPoint>
      # </TripPoints>
      # </ThermalZone>
      # </ThermalZones>
      # </Platform>
      # </ThermalConfiguration>
      # <!-- END --> '';
    };
  };
  # hardware.pulseaudio.enable = true;

  # boot.kernelPackages = pkgs.linuxPackages_4_19;
  # boot.kernelPackages = pkgs.linuxPackages_5_4;
  # boot.kernelPackages = pkgs.linuxPackages_5_10;
  # boot.kernelPackages = pkgs.linuxPackages_5_11;
  # boot.kernelPackages = pkgs.linuxPackages_5_15;
  #
  # 6_16 doesn't build (yet) with zfs:
  boot.kernelPackages = pkgs.linuxPackages_6_15;

  # boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
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
    DSSI_PATH =
      "$HOME/.dssi:$HOME/.nix-profile/lib/dssi:/run/current-system/sw/lib/dssi";
    LADSPA_PATH =
      "$HOME/.ladspa:$HOME/.nix-profile/lib/ladspa:/run/current-system/sw/lib/ladspa";
    LV2_PATH =
      "$HOME/.lv2:$HOME/.nix-profile/lib/lv2:/run/current-system/sw/lib/lv2";
    LXVST_PATH =
      "$HOME/.lxvst:$HOME/.nix-profile/lib/lxvst:/run/current-system/sw/lib/lxvst";
    VST_PATH =
      "$HOME/.vst:$HOME/.nix-profile/lib/vst:/run/current-system/sw/lib/vst";
  };


  # environment.sessionVariables = {
  # NIXOS_CONFIG = "/home/bart/nixosConfig/machines/nix14/default.nix";
  # };
}
