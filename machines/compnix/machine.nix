{pkgs, config, ...}: with pkgs;

let
  boot.initrd.availableKernelModules = [ "ata_generic" "uhci_hcd" "ehci_pci" "ata_piix" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  # blkid
  rootUUID = "120bac53-cd75-46b2-835f-7b8014b543cb";
  bootUUID = "50d3b357-2c01-4e1c-8fd1-0e982f1783fb";
  homeUUID = "ff1eedc7-0f6c-42a7-9ab5-2a613c49b744";
  swapUUID = "b29d358d-3d93-4a78-94be-6b0da1638d33";
  # ls /dev/disk/by-id/
  diskID = "ata-Hitachi_HDS721616PLA380_PVFC04ZFTHE8YE";
in
{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ./remote_i3.nix
    ];

  nixpkgs.system = "x86_64-linux";

  environment.systemPackages = [
    qmidinet
    qjackctl
    jack2Full
  ];

  systemd.services.qmidinet = {
    description = "Qmidinet";
    enable = true;
    environment = { DISPLAY = "2.2.2.1:0"; };
    # environment = { DISPLAY = ":${toString config.services.xserver.display}"; };
    serviceConfig = {
      # Type = "simple";
      ExecStart = "${pkgs.qmidinet}/bin/qmidinet -i enp3s0";
      KillSignal = "SIGUSR2";
      Restart = "always";
    };
    wantedBy = [ "graphical.target" ];
    after = [ "display-manager.service" ];
    # after = [ "network-online.target" ];
  };

  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

  services.xserver = {
    # autorun = false;
    # videoDrivers = [ intel ];
    displayManager = {
      sessionCommands = ''
        xrandr --newmode "1920x1080_60.00" 173.00 1920 2048 2248 2576 1080 1083 1088 1120 -hsync +vsync
        xrandr --addmode VGA1 1920x1080_60.00
        xrandr --output VGA1 --mode 1920x1080_60.00
      '';
    };
    windowManager.remote_i3.enable = true;
    windowManager.i3.enable = true;
    windowManager.default = "remote_i3" ;
  };

  boot =
  { # dependant on amount of ram:
    tmpOnTmpfs = false;
    loader.grub.device = "/dev/disk/by-id/${diskID}";
    #loader.grub.extraEntries = import ./extraGrub.nix;
    #copy from /etc/nixos/hardware-configuration.nix
    initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ata_piix" "usb_storage" ];
    kernelModules = [ ];
    extraModulePackages = [ ];
    blacklistedKernelModules = [ "snd_hda_intel" ];
  };

  fileSystems =
  {
    "/" =
    {
      device = "/dev/disk/by-uuid/${rootUUID}";
      fsType = "ext4";
      options = [ "relatime" "errors=remount-ro" ];
    };
    "/boot" =
    { device = "/dev/disk/by-uuid/${bootUUID}";
      fsType = "ext4";
      options = [ "relatime" "errors=remount-ro" ];
    };
    "/home" =
    { device = "/dev/disk/by-uuid/${homeUUID}";
      fsType = "ext4";
      options = [ "relatime" "errors=remount-ro" ];
    };
  };

  swapDevices = [{
    device = "/dev/disk/by-uuid/${swapUUID}";
  }];

   nix = {
    requireSignedBinaryCaches = true;
    maxJobs = 0; # force remote building
    distributedBuilds = true;
    buildMachines = [ { hostName = "2.2.2.2"; maxJobs = 4; sshKey = "/root/.ssh/id_rsa"; sshUser = "root"; system = "x86_64-linux"; } ];

    
    binaryCaches = [ "2.2.2.2:5000/" "https://cache.nixos.org/" ];
    #binaryCaches = ["2.2.2.2:5000"];
    #binaryCaches = [""];
  #  extraOptions = ''
  #    binary-caches = 2.2.2.2:5000/ 
  #  '';
    binaryCachePublicKeys = [ "mixos:hpj9Ic8KDQp4CH33+KgKRhTeLOi+ixuUEdWtfojfnZY=#" ];
   };

  networking = {
    interfaces.enp0s25 = {
      ipAddress = "2.2.2.1";
      prefixLength = 24;
    };
    wireless.enable = false;
  };
}
