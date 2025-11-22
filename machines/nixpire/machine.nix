{ pkgs, config, ... }: with pkgs;

let
  # blkid
  rootUUID = "9b4bc91f-c9d2-413a-811f-34eb21232388";
  swapUUID = "5a88c244-4690-4524-bcb2-76b700475378";
  # ls /dev/disk/by-id/
  diskID = "ata-ST9160310AS_5SV8AVRQ-0:0";
in
{
  imports =
    [
      <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot =
    {
      # dependant on amount of ram:
      tmpOnTmpfs = false;
      loader.grub.device = "/dev/disk/by-id/${diskID}";
      loader.grub.extraEntries = import ./extraGrub.nix;
      #copy from /etc/nixos/hardware-configuration.nix
      initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ata_piix" "ahci" "usb_storage" ];
      kernelModules = [ ];
      extraModulePackages = [ ];
    };

  fileSystems =
    {
      "/" =
        {
          device = "/dev/disk/by-uuid/${rootUUID}";
          fsType = "ext3";
          options = "noatime,errors=remount-ro";
        };
      /*"/home" =*/
      /*{ device = "/dev/disk/by-uuid/${homeUUID}";*/
      /*fsType = "ext3";*/
      /*options = "noatime,errors=remount-ro";*/
      /*};*/
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
  services = {
    smartd = {
      enable = true;
      devices = [
        { device = "/dev/sda"; }
        # { device = "/dev/nvme0n1"; }
        # { device = "/dev/sdb"; }
      ];
      notifications.test = true;
      notifications.x11.enable = true;
    };

  }

    }
