{pkgs, config, ...}: with pkgs;
{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
      # machine specific:
      ./machine.nix
      # on every machine:
      ../../common.nix
      # music tweaks and progs:
     ../../music.nix
    ];

  networking.hostName = "thinknix-rt";

 services.tlp.enable = false;

 musnix = {
   enable = true;
   kernel.optimize = true;
   kernel.realtime = true;
   kernel.packages = pkgs.linuxPackages_latest_rt;
   rtirq.nameList = "rtc0 usb";
 };
}

# nixos-rebuild test -p rt -I nixos-config=/home/bart/nixosConfig/machines/thinknix/rt.nix -I nixpkgs=$NIXPKGS
# nixos-rebuild switch -p rt -I nixos-config=/home/bart/nixosConfig/machines/thinknix/rt.nix -I nixpkgs=$NIXPKGS
