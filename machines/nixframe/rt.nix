{ pkgs, config, ... }:
with pkgs; {
  imports = [
    ./hardware-configuration.nix
    # <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    # machine specific:
    ./machine.nix
    # on every machine:
    ../../common.nix
    # on every RT machine:
    ../../commonRT.nix
    # music tweaks and progs:
    ../../music.nix
  ];


  networking.hostName = "nixframe-rt";
  musnix =
    {
      rtirq.nameList = "rtc0 usb";
    };

  # nixos-rebuild test -p rt -I nixos-config=/home/bart/nixosConfig/machines/thinknix/rt.nix -I nixpkgs=$NIXPKGS
  # nixos-rebuild switch -p rt -I nixos-config=/home/bart/nixosConfig/machines/thinknix/rt.nix -I nixpkgs=$NIXPKGS


  # per device:
  services.jack.jackd.extraOptions = [
    # "-v" "-P71" "-p1024" "-dalsa" "-dhw:PCH" "-r48000" "-p2048" "-n2" "-P"
    "-P71" "-p2048" "-dalsa" "-dhw:USB" "-r48000" "-p4096" "-n3"
  ];

  # use throttled to not throttle CPU early (thanks Lenovo)
  # services.throttled.enable = true;

  # environment.sessionVariables = {
  # NIXOS_CONFIG = "/home/bart/nixosConfig/machines/nix14/rt.nix";
  # };
}
