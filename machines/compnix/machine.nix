{pkgs, config, ...}: with pkgs;

let
  boot.initrd.availableKernelModules = [ "ata_generic" "uhci_hcd" "ehci_pci" "ata_piix" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  # blkid
  rootUUID = "a33cd97a-1452-4581-9036-c85f9f925f32";
  homeUUID = "d60e8a3d-0333-4f06-929c-735ad0329b2c";
  swapUUID = "58ab248a-59c2-4f25-aa56-de17021bbc1d";
  # ls /dev/disk/by-id/
  diskID = "ata-ST3250318AS_9VY4EJQV";
in
{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ./remote_i3.nix
    ];

  nixpkgs.system = "x86_64-linux";

  nixpkgs.config.packageOverrides = pkgs : rec {
    qjackctl = pkgs.stdenv.lib.overrideDerivation pkgs.qjackctl (oldAttrs: {
      configureFlags = "--enable-jack-version --disable-xunique"; # fix bug for remote running
    });
    jack2Full = libjack2Unstable;
    libjack2 = libjack2Unstable;
    # faust = faust2unstable;
  };

  environment.systemPackages = [
    qmidinet
    qjackctl
    jack2Full
    a2jmidid
  ];

  systemd.services.qmidinet = {
    description = "Qmidinet";
    enable = true;
    environment = { DISPLAY = "2.2.2.1:0"; };
    # environment = { DISPLAY = ":${toString config.services.xserver.display}"; };
    serviceConfig = {
      # Type = "simple";
      ExecStart = "${pkgs.qmidinet}/bin/qmidinet -i enp0s18f2u4";
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

  services.compton.enable = true;

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
    #"/boot" =
    #{ device = "/dev/disk/by-uuid/${bootUUID}";
    #  fsType = "ext4";
    #  options = [ "relatime" "errors=remount-ro" ];
    #};
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
    binaryCaches = [ "http://2.2.2.2:5000/" "https://cache.nixos.org" ];
    binaryCachePublicKeys = [ "mixos:4IOWERw6Xcjocz9vQU5+qK7blTaeOB8QpDjLs0xcUFo="];
   };

  networking = {
    interfaces.enp63s0 = {
      ipAddress = "2.2.2.1";
      prefixLength = 24;
    };
    wireless.enable = false;
  };
}
