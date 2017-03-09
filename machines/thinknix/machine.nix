{pkgs, config, ...}: with pkgs;

let
  boot.initrd.availableKernelModules = [ "ata_generic" "uhci_hcd" "ehci_pci" "ata_piix" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
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

  services = {
    xserver = {
      # videoDrivers = [ intel ];
      # windowManager.remote_i3.enable = true;
      windowManager.i3.enable = true;
      windowManager.default = "i3" ;
    };
    compton = {
      enable = true;
      # backend = "xrender";
    };
  };

    # ThinkPad ACPI
  # services.acpid = {
  #   enable = true;
  #   powerEventCommands = ''
  #     echo 2 > /proc/acpi/ibm/beep
  #   '';
  #   lidEventCommands = ''
  #     echo 3 > /proc/acpi/ibm/beep
  #   '';
  #   acEventCommands = ''
  #     echo 4 > /proc/acpi/ibm/beep
  #   '';
  # };

  boot =
  { # dependant on amount of ram:
    tmpOnTmpfs = true;
    loader.grub.device = "/dev/disk/by-id/${diskID}";
    #loader.grub.extraEntries = import ./extraGrub.nix;
    #copy from /etc/nixos/hardware-configuration.nix
    initrd.availableKernelModules = [  "uhci_hcd" "ehci_pci" "ata_piix" "usb_storage"  ];
    kernelModules = [ "kvm-intel" ];
    # kernelModules = [ "kvm-intel" "tp_smapi" ];
    extraModulePackages = [ ];
    # extraModulePackages = [ config.boot.kernelPackages.tp_smapi ];
    blacklistedKernelModules = [ "snd_hda_intel" ];
  };

  powerManagement.cpuFreqGovernor = "powersave";

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
    distributedBuilds = true;
    buildMachines = [ { hostName = "2.2.2.2"; maxJobs = 4; sshKey = "/root/.ssh/id_rsa"; sshUser = "root"; system = "x86_64-linux"; } ];
    binaryCaches = [ "http://2.2.2.2:5000/" "https://cache.nixos.org" ];
    binaryCachePublicKeys = [ "mixos:4IOWERw6Xcjocz9vQU5+qK7blTaeOB8QpDjLs0xcUFo="];
   };

  networking = {
    connman.enable = true;
    wireless.enable = true;
  };
}
