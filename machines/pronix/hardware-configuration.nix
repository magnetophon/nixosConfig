# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "uhci_hcd" "mpt3sas" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "sys_pool/root/nixos";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "sys_pool/home";
      fsType = "zfs";
    };

  #fileSystems."/boot" =
    #{ device = "/dev/disk/by-uuid/1AFD-DA91";
      #fsType = "vfat";
    #};

  swapDevices =
    [ { device = "/dev/disk/by-id/wwn-0x5000c5005f5cb3b3-part1"; }
    ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
