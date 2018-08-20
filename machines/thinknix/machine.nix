{pkgs, config, ...}: with pkgs;

let
  # ls /dev/disk/by-id/
  diskID = "ata-INTEL_SSDSA2BW160G3L_BTPR152201YW160DGN";
in
{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    # ./remote_i3.nix
    ];

  nixpkgs.system = "x86_64-linux";

  hardware = {
    opengl.extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau ];
    trackpoint = {
      enable = true;
      sensitivity = 200;
      speed = 100;
      emulateWheel = true;
    };
  };

  sound.extraConfig = ''
    pcm.!default {
    type rate
    slave {
      pcm "hw:0"
      rate 44100
      }
    }
  '';

  boot =
  { # dependant on amount of ram:
    # tmpOnTmpfs = true;
    # loader.grub.device = "/dev/disk/by-id/${diskID}";
    #loader.grub.extraEntries = import ./extraGrub.nix;
    # workaround for kernel bug https://bbs.archlinux.org/viewtopic.php?id=218581&p=3
    # kernelPackages = pkgs.linuxPackages_4_4;
    #copy from /etc/nixos/hardware-configuration.nix
    initrd.availableKernelModules = [ "ehci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "sdhci_pci" ];
    # kernelModules = [ "kvm-intel" ]; # for virtualisation
    kernelModules = [ "acpi_call" "tp_smapi" ];
    extraModprobeConfig = ''
      options iwlwifi power_save=1 d0i3_disable=0 uapsd_disable=0
    '';
    extraModulePackages = [ config.boot.kernelPackages.acpi_call config.boot.kernelPackages.tp_smapi ];
    kernelParams = [
      "fastboot=true"
      # # Kernel GPU Savings Options (NOTE i915 chipset only)
      # "i915.enable_rc6=7"
      # "enable_dc=2"
      # "i915.enable_fbc=1"
      # # "i915.lvds_downclock=1"
      # "i915.semaphores=1"
      # # "enable_dpcd_backlight=true"
      # "i915.enable_rc6=1" "i915.enable_fbc=1"
			"i915.lvds_use_ssc=0"
      "drm.debug=0" "drm.vblankoffdelay=1"
      "nmi_watchdog=0"
      # handle screen brightness manually, so we can go lower:
      "video.brightness_switch_enabled=0"
      "quiet"
    ];
    blacklistedKernelModules = [
      # Kernel GPU Savings Options (NOTE i915 chipset only)
      "sierra_net" "cdc_mbim" "cdc_ncm" "btusb"
      # disable beep
      "snd_pcsp" "pcspkr"
      #disable webcam
      "uvcvideo"
    ];
  };

 # powerManagement.cpuFreqGovernor = "powersave";

  fileSystems =
  {
    "/" =
    {
      device = "/dev/mapper/VolGroup-nixos";
      fsType = "ext4";
      options = [ "relatime" "errors=remount-ro" "discard" ];
    };
    #"/boot" =
    #{ device = "/dev/disk/by-uuid/${bootUUID}";
    #  fsType = "ext4";
    #  options = [ "relatime" "errors=remount-ro" ];
    #};
    "/home" =
    { device = "/dev/mapper/VolGroup-home";
      fsType = "ext4";
      options = [ "relatime" "errors=remount-ro" "discard" ];
    };
  };

  swapDevices = [{
    device = "/dev/mapper/VolGroup-swap";
  }];

   nix = {
    requireSignedBinaryCaches = true;
    maxJobs = 4; # force remote building
    # distributedBuilds = true;
    buildMachines = [ { hostName = "2.2.2.2"; maxJobs = 4; sshKey = "/root/.ssh/id_rsa"; sshUser = "root"; system = "x86_64-linux"; } ];
    # binaryCaches = [ "https://cache.nixos.org" "https://2.2.2.2:5000/" ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "mixos:4IOWERw6Xcjocz9vQU5+qK7blTaeOB8QpDjLs0xcUFo="
    ];
   };

  networking = {
    networkmanager.enable = true;
    networkmanager.packages = [ pkgs.networkmanagerapplet ];
    # connman.enable = true;
    # wireless.enable = true;
  };

  services = {
    xserver = {
      videoDrivers = [ "intel" ];
      # windowManager.remote_i3.enable = true;
      windowManager.i3.enable = true;
      windowManager.default = "i3" ;
      displayManager = {
        sessionCommands = ''
          xinput set-button-map 10 1 0 3
        '';
      };

    };

    ntp.enable = false;
    chrony.enable = true;

    compton = {
      enable = true;
      # time compton --config /dev/null --backend glx --benchmark 100
      # time compton --config /dev/null --backend xrender --benchmark 100
      # the above gives xrender as the quickest option, but it tears, whereas glx does not
      # backend = "glx";
      # vSync = "opengl-swc";
      # vSync = "opengl-oml";
      # extraOptions = "paint-on-overlay = true";
      extraOptions = "unredir-if-possible = true";
    };
    psd = {
      enable = true;
      users = [ "bart" ];      # At least one is required
      # browsers = [ "firefox" ];    # Leave blank to enable all
      # only available from kernel 3.18
      # useOverlayFS = true; # set to true to enable overlayfs or set to false to use the default sync mode
    };
    tlp = {
      # enable = true;
      extraConfig = ''
        CPU_SCALING_GOVERNOR_ON_AC=performance
        CPU_SCALING_GOVERNOR_ON_BAT=powersave
        CPU_BOOST_ON_AC=1
        CPU_BOOST_ON_BAT=0
        CPU_MIN_PERF_ON_BAT=0
        CPU_MAX_PERF_ON_BAT=0
        SCHED_POWERSAVE_ON_AC=0
        SCHED_POWERSAVE_ON_BAT=1
        NMI_WATCHDOG=0
        DISK_DEVICES="$diskID"
        DISK_IOSCHED="deadline"
        ENERGY_PERF_POLICY_ON_AC=performance
        ENERGY_PERF_POLICY_ON_BAT=powersave
        PCIE_ASPM_ON_AC=performance
        PCIE_ASPM_ON_BAT=powersave
        SATA_LINKPWR_ON_AC=max_performance
        SATA_LINKPWR_ON_BAT=min_power
        WIFI_PWR_ON_AC=off
        WIFI_PWR_ON_BAT=on
        WOL_DISABLE=Y
        SOUND_POWER_SAVE_ON_AC=0
        SOUND_POWER_SAVE_ON_BAT=1
        SOUND_POWER_SAVE_CONTROLLER=Y
        BAY_POWEROFF_ON_BAT=1
        BAY_DEVICE=sr0
        RUNTIME_PM_ON_AC=on
        RUNTIME_PM_ON_BAT=auto
        USB_AUTOSUSPEND=1
        USB_BLACKLIST_WWAN=0
        # not implemented yet in current release:
        USB_BLACKLIST_PHONE=1
        # workaround:
        # USB_BLACKLIST="05ac:12a0"
        DEVICES_TO_DISABLE_ON_STARTUP="bluetooth wwan"
        # Radio devices to disable on connect.
        DEVICES_TO_DISABLE_ON_LAN_CONNECT="wifi wwan"
        DEVICES_TO_DISABLE_ON_WIFI_CONNECT="wwan"
        DEVICES_TO_DISABLE_ON_WWAN_CONNECT="wifi"
        # Radio devices to enable on disconnect.
        DEVICES_TO_ENABLE_ON_LAN_DISCONNECT="wifi"
        DEVICES_TO_ENABLE_ON_WIFI_DISCONNECT=""
        DEVICES_TO_ENABLE_ON_WWAN_DISCONNECT=""
        START_CHARGE_THRESH_BAT0=35
        STOP_CHARGE_THRESH_BAT0=85
      '';
    };
    thinkfan.enable = true;
    # run strace tlp-stat -t
    # thinkfan.sensor = "/sys/devices/platform/coretemp.0/hwmon/hwmon2/temp1_input";
    thinkfan.sensors = "hwmon /sys/devices/virtual/hwmon/hwmon0/temp1_input (0,0,10)";

      # Suspend the system when battery level drops to 5% or lower
    udev.extraRules = ''
      SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="[0-5]", RUN+="${pkgs.systemd}/bin/systemctl hibernate"
      SUBSYSTEM=="power_supply", ACTION=="change", \
      OPTIONS+="last_rule", \
      RUN+=" ${pkgs.light}/bin/light -I"
    '';
  };
  # something like this should enable lower backlight, making ~/.local/bin/brightness.sh and the light save and restore unneeded
      # ENV{ID_BACKLIGHT_CLAMP}="0"
  # environment.systemPackages = [ tpacpi-bat ];

}
