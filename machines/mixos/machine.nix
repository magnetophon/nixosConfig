{pkgs, config, ...}: with pkgs;

let
  # blkid
  rootUUID = "51a39d20-38ef-4cd0-a0fb-afe721ae3adc";
  homeUUID = "052156b0-5203-47e0-a622-a9058215308c";
  swapUUID = "786fef46-79af-4247-940b-68872ef2e2a3";
  # ls /dev/disk/by-id/
  diskID = "ata-Samsung_SSD_850_EVO_120GB_S21UNSAG134647X";
in
{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot =
  { # dependant on amount of ram:
    #tmpOnTmpfs = true;
    #loader.grub.device = "/dev/sdd";
    loader.grub.device = "/dev/disk/by-id/${diskID}";
    #loader.grub.extraEntries = import ./extraGrub.nix;
    #copy from /etc/nixos/hardware-configuration.nix
    /*kernelPackages.kernel.system = "x86_64-linux";*/
    initrd.availableKernelModules = [ "ehci_pci" "ahci" "usbhid" "usb_storage" ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems =
  {
    "/" =
    { 
      /*device = "/dev/sde1";*/
      device = "/dev/disk/by-uuid/${rootUUID}";
      fsType = "ext4";
      options = "relatime,errors=remount-ro";
    };
    "/home" =
    { device = "/dev/disk/by-uuid/${homeUUID}";
      fsType = "ext4";
      options = "relatime,errors=remount-ro";
    };
  };

  swapDevices = [{
    device = "/dev/disk/by-uuid/${swapUUID}";
  }];

  nix.maxJobs = 4;

  nixpkgs.system = "x86_64-linux";

  networking = {
    interfaces.enp3s0 = {
      useDHCP = false;
      ip4 = [ { address = "2.2.2.2"; prefixLength = 24; } ];
    };
    #networkmanager.enable = true;
    connman.enable = false;
    # fix connman static IP:
    #localCommands = "${inetutils}/bin/ifconfig enp3s0 2.2.2.2 netmask 255.255.255.0 up";
    wireless.enable = false;
};
  #services.dnsmasq.enable = true;
  ##services.dnsmasq.resolveLocalQueries = false;
  #services.dnsmasq.extraConfig = ''
    #port=0
    #interface=enp3s0
    #dhcp-range=2.2.2.1,2.2.2.1,infinite
  #'';
}
