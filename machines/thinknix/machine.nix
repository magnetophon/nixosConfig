{pkgs, config, ...}: with pkgs;

let
  # boot.initrd.availableKernelModules = [ "ata_generic" "uhci_hcd" "ehci_pci" "ata_piix" "usb_storage" "usbhid" "sd_mod" ];
  # boot.kernelModules = [ "kvm-intel" ];
  # boot.extraModulePackages = [ ];
  # ls /dev/disk/by-id/
  diskID = "ata-INTEL_SSDSA2BW160G3L_BTPR152201YW160DGN";
in
{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    # ./remote_i3.nix
    ];

  nixpkgs.system = "x86_64-linux";

  # hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];


  boot =
  { # dependant on amount of ram:
    tmpOnTmpfs = true;
    loader.grub.device = "/dev/disk/by-id/${diskID}";
    #loader.grub.extraEntries = import ./extraGrub.nix;
    #copy from /etc/nixos/hardware-configuration.nix
    # initrd.availableKernelModules = [  "uhci_hcd" "ehci_pci" "ata_piix" "usb_storage"  ];
    initrd.availableKernelModules = [ "ehci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "sdhci_pci" ];
    # kernelModules = [ "kvm-intel" ]; # for virtualisation
    kernelModules = [ "acpi_call" "tp_smapi" ];
    # kernelModules = [ "tp_smapi" ];
    # extraModulePackages = [ ];
    # extraModulePackages = [ config.boot.kernelPackages.tp_smapi ];
    extraModulePackages = [ config.boot.kernelPackages.acpi_call config.boot.kernelPackages.tp_smapi ];
    # blacklistedKernelModules = [ "snd_hda_intel" ];
  };

 # powerManagement.cpuFreqGovernor = "powersave";

  fileSystems =
  {
    "/" =
    {
      device = "/dev/mapper/thinkVG-nixos";
      fsType = "ext4";
      options = [ "relatime" "errors=remount-ro" ];
    };
    #"/boot" =
    #{ device = "/dev/disk/by-uuid/${bootUUID}";
    #  fsType = "ext4";
    #  options = [ "relatime" "errors=remount-ro" ];
    #};
    "/home" =
    { device = "/dev/mapper/thinkVG-home";
      fsType = "ext4";
      options = [ "relatime" "errors=remount-ro" ];
    };
  };

  swapDevices = [{
    device = "/dev/mapper/thinkVG-swap";
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
      # videoDrivers = [ intel ];
      # windowManager.remote_i3.enable = true;
      windowManager.i3.enable = true;
      windowManager.default = "i3" ;
    };
    compton = {
      enable = true;
      # time compton --config /dev/null --backend glx --benchmark 100
      # time compton --config /dev/null --backend xrender --benchmark 100
      backend = "xrender";
    };
    psd = {
      enable = true;
      users = [ "bart" ];      # At least one is required
      browsers = [ "firefox" ];    # Leave blank to enable all
      # only available from kernel 3.18
      # useOverlayFS = true; # set to true to enable overlayfs or set to false to use the default sync mode
    };
    tlp = {
      enable = true;
      extraConfig = ''
        CPU_SCALING_GOVERNOR_ON_AC=performance
        CPU_SCALING_GOVERNOR_ON_BAT=powersave
        CPU_BOOST_ON_AC=1
        CPU_BOOST_ON_BAT=0
        SCHED_POWERSAVE_ON_AC=0
        SCHED_POWERSAVE_ON_BAT=1
        ENERGY_PERF_POLICY_ON_AC=performance
        ENERGY_PERF_POLICY_ON_BAT=powersave
        PCIE_ASPM_ON_AC=performance
        PCIE_ASPM_ON_BAT=powersave
        WIFI_PWR_ON_AC=off
        WIFI_PWR_ON_BAT=on
        BAY_POWEROFF_ON_BAT=0
        BAY_DEVICE=sr0
        RUNTIME_PM_ON_AC=on
        RUNTIME_PM_ON_BAT=auto
        USB_AUTOSUSPEND=1
        DEVICES_TO_DISABLE_ON_STARTUP="bluetooth wwan"
        START_CHARGE_THRESH_BAT0=35
        STOP_CHARGE_THRESH_BAT0=85
      '';
    };
    thinkfan.enable = true;
    thinkfan.sensor = "/sys/devices/virtual/hwmon/hwmon1/temp1_input";
  };

  # environment.systemPackages = [ tpacpi-bat ];

}
