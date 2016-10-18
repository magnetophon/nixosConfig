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
    ];

  boot =
  { # dependant on amount of ram:
    tmpOnTmpfs = false;
    loader.grub.device = "/dev/disk/by-id/${diskID}";
    #loader.grub.extraEntries = import ./extraGrub.nix;
    #copy from /etc/nixos/hardware-configuration.nix
    initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ata_piix" "usb_storage" ];
    kernelModules = [ ];
    extraModulePackages = [ ];
  };

  fileSystems =
  {
    "/" =
    {
      #device = "/dev/sda1";
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

  nix.maxJobs = 2;

  networking = {
    interfaces.enp63s0 = {
      ip4 = [ { address = "2.2.2.1"; prefixLength = 24; } ];
    };
    # interfaces.enp0s26f7u3  = {
    #   useDHCP = true;
    # };
    #networkmanager.enable = true;
    #connman.enable = true;
    # fix connman static IP:
    # localCommands = "ifconfig enp0s26f7u3 2.2.2.2 netmask 255.255.255.0 up";
    #wireless.enable = true;
};
  #services.dnsmasq.enable = true;
  #services.dnsmasq.resolveLocalQueries = false;
  #services.dnsmasq.extraConfig = ''
    #port=0
    #interface=enp1s7
    #dhcp-range=::,static
    #dhcp-host=nixpire,2.2.2.1
  #'';


# services.xserver.monitorSection = ''
#   Identifier "VGA1"
#   Modeline "1920x1080_60.00" 173.00 1920 2048 2248 2576 1080 1083 1088 1120 -hsync +vsync
#   Option "PreferredMode" "1920x1080_60.00"
# '';
# services.xserver.screenSection = ''
#   Identifier "Screen0"
#   Monitor "VGA1"
#   DefaultDepth 24
#   SubSection "Display"
#     Modes "1920x1080_60.00"
#   EndSubSection
# '';
}
