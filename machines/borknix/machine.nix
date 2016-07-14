{pkgs, config, ...}: with pkgs;

let
  # blkid
  rootUUID = "43fa23cf-00a6-4672-9a38-4e231eebdc79";
  homeUUID = "661bf9a9-6fbe-4c57-9138-a6cb0e042d0e";
  swapUUID = "bf91febd-08a1-4601-9c04-fbdd4351a8a8";
  # ls /dev/disk/by-id/
  diskID = "ata-Hitachi_HTS541616J9SA00_SB2404GJG5MWEE";
in
{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot =
  { # dependant on amount of ram:
    # mount -o remount,size=4G /tmp and your /tmp/ is now bigger
    tmpOnTmpfs =  false;
    #loader.grub.device = "/dev/sda";
    loader.grub.device = "/dev/disk/by-id/${diskID}";
    #loader.grub.extraEntries = ''
    #  menuentry 'Tails'
    #  { set root=(hd0,2)
    #    set isofile="/bart/Downloads/tails-i386-1.5.iso"
    #    loopback loop (hd0,2)$isofile
    #    linux (loop)/live/vmlinuz findiso=$isofile boot=live config apparmor=1 security=apparmor nopersistent noprompt timezone=Etc/UTC
    #block.events_dfl_poll_msecs=1000 splash noautologin module=Tails quiet i2p
    #    initrd (loop)/live/initrd.img
    #  }'';
    #copy from /etc/nixos/hardware-configuration.nix
    initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ata_piix" "ahci" "usb_storage" ];
    kernelModules = [ ];
    extraModulePackages = [ ];
  };

  fileSystems =
  {
    "/" =
    {
     #device = "/dev/disk/by-label/nixos";
     device = "/dev/disk/by-uuid/${rootUUID}";
      fsType = "ext4";
      options = [ "relatime" "errors=remount-ro" ];
    };
    "/home" =
    {
      #device = "/dev/disk/by-label/home";
      device = "/dev/disk/by-uuid/${homeUUID}";
      fsType = "ext4";
      options = [ "relatime" "errors=remount-ro" ];
    };
    /*"/tmp" =*/
    /*{ device = "/dev/disk/by-uuid/43fa23cf-00a6-4672-9a38-4e231eebdc79";*/
      /*fsType = "ext4";*/
      # options = [ "relatime" "errors=remount-ro" ];
    /*};*/
  };

  swapDevices = [{
    device = "/dev/disk/by-uuid/${swapUUID}";
    #device = "/dev/disk/by-label/swap";
  }];

  nix.maxJobs = 2;

  networking = {
    interfaces.enp1s7 = {
      useDHCP = false;
      #ip4 = [ { address = "2.2.2.1"; prefixLength = 24; } ];
    };
    #networkmanager.enable = true;
    connman.enable = true;
    # fix connman static IP:
    localCommands = "${inetutils}/bin/ifconfig enp1s7 2.2.2.1 netmask 255.255.255.0 up";
    #nameservers =  [ "192.168.0.1" ];
    #defaultGateway = "192.168.0.1";
    wireless.enable = true;
    };
    services.xserver.vaapiDrivers = [ pkgs.vaapiIntel  ];
  /*services.dnsmasq.enable = true;*/
  #services.dnsmasq.resolveLocalQueries = false;
  /*services.dnsmasq.extraConfig = ''*/
    /*port=0*/
    /*interface=enp1s7*/
    /*dhcp-range=2.2.2.1,2.2.2.1,infinite*/
  /*'';*/
}

    /*dhcp-host=00:19:bb:e1:07:7c,2.2.2.3,infinite*/

    /*dhcp-host=nixpire,2.2.2.1*/
    /*dhcp-range=2.2.2.1,2.2.2.3,12h*/
