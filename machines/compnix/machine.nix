{pkgs, config, ...}: with pkgs;

let
  # blkid
  rootUUID = "c29cd66c-6348-4024-b7c2-82cb92602007";
  homeUUID = "cf984a4b-d356-40ee-bdf5-d236cd8d54fc";
  swapUUID = "2cff3fe8-09d5-464e-b17c-fc6c24d72073";
  # ls /dev/disk/by-id/
  diskID = "ata-WDC_WD800JD-60LSA5_WD-WMAM9KK45956";
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
    maxJobs = 0; # force remote building
    distributedBuilds = true;
    buildMachines = [ { hostName = "mixos"; maxJobs = 4; sshKey = "/home/bart/.ssh/id_rsa"; sshUser = "bart"; system = "x86_64-linux"; } ];
  };

  networking = {
    interfaces.enp63s0 = {
      ipAddress = "2.2.2.1";
      prefixLength = 24;
    };
    wireless.enable = false;
  };
}
