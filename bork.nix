{pkgs, config, ...}: with pkgs;

let
  # blkid
  rootUUID = "701d97ac-d84b-4d9c-aa8d-d1d719455961";
  homeUUID = "2fb96ddd-422f-48db-ad89-0f4008c7b82c";
  swapUUID = "d7654216-4d7a-4e00-b61a-edbc2bcbb4e3";
  # ls /dev/disk/by-id/
  diskID = "usb-USB2.0_CardReader_SD_606569746801";
in
{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot =
  { # dependant on amount of ram:
    tmpOnTmpfs = true;
    loader.grub.device = "/dev/disk/by-id/${diskID}";
    #loader.grub.extraEntries = import ./extraGrub.nix;
    #copy from /etc/nixos/hardware-configuration.nix
    initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ata_piix" "ahci" "usb_storage" ];
    kernelModules = [ ];
    extraModulePackages = [ ];
  };

  fileSystems =
  {
    "/" =
    { device = "/dev/disk/by-uuid/${rootUUID}";
      fsType = "ext3";
      options = "noatime,errors=remount-ro";
    };
    "/home" =
    { device = "/dev/disk/by-uuid/${homeUUID}";
      fsType = "ext3";
      options = "noatime,errors=remount-ro";
    };
  };

  swapDevices = [{
    device = "/dev/disk/by-uuid/${swapUUID}";
  }];

  nix.maxJobs = 2;

 networking = {
  # interfaces = { enp1s0 = { ipAddress = "2.2.2.1"; subnetMask = "255.255.255.255"; } ; };
  connman.enable = true;
  wireless.enable = true;
};
}
