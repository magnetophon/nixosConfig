{ pkgs, config, ... }:
with pkgs;
{
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.supportedFilesystems = [ "zfs" ];

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver
    ];
  };


  hardware.enableAllFirmware = true;

  # hardware.trackpoint = {
  # enable = true;
  # emulateWheel = true;
  # speed = 250;
  # sensitivity = 140;
  # };
  networking = {
    networkmanager.enable = true;
    networkmanager.packages = [ pkgs.networkmanagerapplet ];
    # for zfs:
    # head -c 8 /etc/machine-id
    hostId = "3a7c3b31";
    # todo:
    # building '/nix/store/rhkg61pmzdgng5iyzrz9rhs46cbhj4nl-unit-systemd-fsck-.service.drv'...
    # building '/nix/store/kyivxwz1h7xfjnbv321gzb4dypidz7s4-unit-systemd-modules-load.service.drv'...
    # building '/nix/store/59r03d91m450gbd48ii8rxwyrszcnqa0-unit-systemd-udevd.service.drv'...
    # building '/nix/store/i8idaxgsdf3z6m0ksgnigpy8hmcgasxk-unit-zfs-import.target.drv'...
    # building '/nix/store/i8246qj9m41ildw2lz3fsvz0j08778y8-unit-zfs-mount.service.drv'...
    # building '/nix/store/hvaqb5i86rjwqy0qy8q76vk4jxzjrg6v-unit-zfs-share.service.drv'...
    # building '/nix/store/6a2396ymy7s46lpv68k1xjdx85ssa2a7-unit-zfs-zed.service.drv'...
    # autoreconf: running: aclocal --force -I config
    # building '/nix/store/748bfspmbp63f9kb63h43qybp6mnzj1s-unit-zfs.target.drv'...
    # building '/nix/store/1p1z8y5lxrwgls1zk8rxnig2v8qmqdv3-unit-zpool-trim.service.drv'...
    # building '/nix/store/243cynl59yvqh5g6nb72zawf0f01nilq-unit-zpool-trim.timer.drv'...

    # connman.enable = true;
    # wireless.enable = true;
  };

  services = {
    xserver = {
      # videoDrivers = [ "intel" ];
      # windowManager.remote_i3.enable = true;
      windowManager.i3 = {
        enable = true;
        # extraSessionCommands = "{pkgs.physlock}/bin/physlock -ds";
      };
      displayManager = {
        defaultSession = "none+i3";
        #   # disable middle mouse buttons
        #   sessionCommands = ''
        #     xinput set-button-map 10 1 0 3  &&
        #     xinput set-button-map 11 1 0 3  &&
        #     physlock -ds
        #   '';
      };
    };

    smartd = {
      enable = true;
      devices = [
        # { device = "/dev/sda"; }
        { device = "/dev/nvme0n1"; }
        # { device = "/dev/sdb"; }
      ];
      notifications.test = true;
      notifications.x11.enable = true;
    };

    ntp.enable = false;
    chrony.enable = true;

    thinkfan = {
      enable = true;
      smartSupport = true;
      sensors =
        [
          {
            query = "/proc/acpi/ibm/thermal";
            type = "tpacpi";
            # all sensors:
            # indices = [ 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 ];
            # the sensors we want; gives wonky readouts:
            # indices = [ 0 2 4 5 6 ];
            # working:
            indices = [ 0 1 2 3 4 5 6 ];
          }
          # {
          # query = "/sys/class/hwmon/hwmon4/";
          # type = "hwmon";
          # indices = [ 1 ];
          # optional = true; # don't exit if the sensor can't be read
          # }
        ];

      levels = [
        ["level auto" 0 55]           # normal cooling when we're cold
        [7 55 65]                     # max 5000 RPM when we're getting hot
        ["level full-speed" 65 32767] # max 6700 RPM when we're hot, above fan spec!
      ];
    };

    picom = {
      # we start it as needed, config in dotfiles
      # enable = true;
      # time compton --config /dev/null --backend glx --benchmark 100
      # time compton --config /dev/null --backend xrender --benchmark 100
      # the above gives xrender as the quickest option, but it tears, whereas glx does not
      backend = "glx";
      vSync = true;
      # vSync = "opengl-swc";
      # vSync = "opengl-oml";
      # extraOptions = "paint-on-overlay = true";
      # settings = "unredir-if-possible = true";
      # settings = "unredir-if-possible = true";
    };
  };
  # boot.kernelParams = [ "acpi_backlight=native" ];

  boot = {
    kernelModules = [ "acpi_call" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  };


}
