{ pkgs, config, ... }:
with pkgs;
{
  boot.loader.systemd-boot.memtest86.enable = true;

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
