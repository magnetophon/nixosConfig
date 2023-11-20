{ pkgs, config, ... }:
with pkgs; {
  imports = [ <nixos-hardware/framework/12th-gen-intel> ];

  networking.hostId = "f2119c72";

  boot.loader.systemd-boot.memtest86.enable = true;

  system.stateVersion = "23.05"; # Did you read the comment?

  environment = {
    systemPackages = [
      # (import /home/bart/source/fw-ectool/default.nix)
      fw-ectool
      intel-gpu-tools # for verifying HW acceleration with intel_gpu_top
    ];
  };
  security.sudo.extraConfig = ''
    bart  ALL=(root) NOPASSWD: /root/.local/bin/key_brightness.sh
    bart  ALL=(root) NOPASSWD: /root/.local/bin/get_fan_rpm.sh
    bart  ALL=(root) NOPASSWD: /root/.local/bin/toggle_fan_max.sh
  '';

  #
  services = {
    xserver = {
      # videoDrivers = [ "modesetting" ];
      # Fix font sizes in X
      dpi = 120;
      # videoDrivers = [ "intel" ];
      # windowManager.remote_i3.enable = true;
      windowManager.i3 = {
        enable = true;
        # extraSessionCommands = "{pkgs.physlock}/bin/physlock -ds";
      };
      windowManager.leftwm = {
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
      displayManager.autoLogin = {
        enable = true;
        user = "bart";
      };
    };

    smartd = {
      enable = true;
      devices = [
        # { device = "/dev/sda"; }
        {
          device = "/dev/nvme0n1";
        }
        # { device = "/dev/sdb"; }
      ];
      notifications.test = true;
      notifications.x11.enable = true;
    };

    ntp.enable = false;
    chrony.enable = true;

    picom = {
      # we start it as needed, config in dotfiles
      # enable = true;
      # time compton --config /dev/null --backend glx --benchmark 100
      # time compton --config /dev/null --backend xrender --benchmark 100
      # the above gives xrender as the quickest option, but it tears, whereas glx does not
      # backend = "glx";
      # vSync = true;
      # vSync = "opengl-swc";
      # vSync = "opengl-oml";
      # extraOptions = "paint-on-overlay = true";
      # settings = "unredir-if-possible = true";
      # settings = "unredir-if-possible = true";
    };
    fwupd.enable = true;
    # Framework laptop doesn't require battery polling.
    # upower.noPollBatteries = true;

  };
  services.fwupd.extraRemotes = [ "lvfs-testing" ];
  environment.etc."fwupd/fwupd.conf" = lib.mkForce {
    source =
      pkgs.runCommand "fwupd-with-uefi-capsule-update-on-disk-disable.conf"
        { } ''
        cat ${pkgs.fwupd}/etc/fwupd/fwupd.conf > $out
        cat >> $out <<EOF

        [uefi_capsule]
        DisableCapsuleUpdateOnDisk=true
        EOF
      '';
  };
  # needed for saving in Cardinal:
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  # boot.kernelParams = [ "acpi_backlight=native" ];

  # fix graphical glitches in 5.10 kernel?
  # https://bugzilla.redhat.com/show_bug.cgi?id=1925346
  # boot.kernelParams = [ "i915.mitigations=off" ];
  #
  nix = {
    settings = {
      max-jobs = 0;
      trusted-users = [ "root" "nixBuild" "bart" ];
      # optional, useful when the builder has a faster internet connection than yours
      builders-use-substitutes = true;
    };
    distributedBuilds = true;
    # hostName = "62.251.18.196";
    buildMachines = [{
      hostName = "builder";
      maxJobs = 24;
      # buildCores = 6;
      sshKey = "/root/.ssh/id_nixBuild";
      sshUser = "nixBuild";
      system = "x86_64-linux";
      speedFactor = 10;
      supportedFeatures = [ "benchmark" "big-parallel" "kvm" "nixos-test" ];
      mandatoryFeatures = [ ];
    }];
  };

  # boot = {
  #   kernelModules = [ "acpi_call" ];
  #   extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  # };

  networking.networkmanager.enable = true;

  # imports =
  #[ (modulesPath + "/installer/scan/not-detected.nix")
  #];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  # boot.kernelParams = [ "zfs.zfs_arc_max=12884901888" ]; # 12GB max ARC cache
  boot.kernelParams = [
    # "zfs.zfs_arc_max=4294967296" # 4GB max ARC cache
    # "zfs.zfs_arc_max=8589934592" # 8GB max ARC cache
    "zfs.zfs_arc_max=12884901888" # 12GB max ARC cache
    # sensor hub module conflicts with manual brightness adjustment
    # "module_blacklist=hid_sensor_hub"
    # disabling psr (panel self-refresh rate) as workaround for iGPU hangs
    # https://discourse.nixos.org/t/intel-12th-gen-igpu-freezes/21768/4
    # NOTE: Instead of setting the option to 1 as in the linked forum topic,
    # setting it to 0 in combination with the 'modesetting' driver seems to fix the problem for me.
    # "i915.enable_psr=0"

  ];

  fileSystems."/" = {
    device = "rpool/nixos/root";
    fsType = "zfs";
    options = [ "zfsutil" "X-mount.mkdir" ];
  };

  fileSystems."/home" = {
    device = "rpool/nixos/home";
    fsType = "zfs";
    options = [ "zfsutil" "X-mount.mkdir" ];
  };

  fileSystems."/var/lib" = {
    device = "rpool/nixos/var/lib";
    fsType = "zfs";
    options = [ "zfsutil" "X-mount.mkdir" ];
  };

  fileSystems."/var/log" = {
    device = "rpool/nixos/var/log";
    fsType = "zfs";
    options = [ "zfsutil" "X-mount.mkdir" ];
  };

  fileSystems."/boot" = {
    device = "bpool/nixos/root";
    fsType = "zfs";
    options = [ "zfsutil" "X-mount.mkdir" ];
  };

  fileSystems."/boot/efis/nvme-WD_BLACK_SN850X_1000GB_223761800744-part1" = {
    device = "/dev/disk/by-uuid/A366-D51A";
    fsType = "vfat";
  };

  fileSystems."/boot/efi" = {
    device = "/boot/efis/nvme-WD_BLACK_SN850X_1000GB_223761800744-part1";
    fsType = "none";
    options = [ "bind" ];
  };

  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];
  boot.zfs.allowHibernation = true; # safe because swap is not on zfs
  # Importing a suspended pool can corrupt it
  boot.zfs.forceImportRoot = false;
  boot.zfs.forceImportAll = false;
  boot.zfs.enableUnstable = true;

  # Configure hibernation
  boot.resumeDevice = lib.mkIf (config.swapDevices != [ ])
    (lib.mkDefault (builtins.head config.swapDevices).device);
  # Snapshot daily
  services.zfs.autoSnapshot = {
    enable = true;
    # Default:
    # "-k -p"
    # -k              Keep zero-sized snapshots.
    # -p              Create snapshots in parallel.
    flags = "-p";
    # by default
    # ZFS will keep a snapshot for the latest 4 15-minute, 24 hourly, 7 daily, 4 weekly and 12 monthly snapshots.
    # monthly = 1;
    # weekly = 2;
    # daily = 6;
    # hourly = 4;
    # frequent = 0;
  };

  # znapzend = {
  #   enable = true;
  #   features.sendRaw = true;
  #   zetup =
  #     {
  #       "tank/home" = {
  #         # Make snapshots of tank/home every hour, keep those for 1 day,
  #         # keep every days snapshot for 1 month, etc.
  #         plan = "1d=>1h,1m=>1d,1y=>1m";
  #         recursive = true;
  #         # Send all those snapshots to john@example.com:rtank/john as well
  #         destinations.remote = {
  #           # host = "john@example.com";
  #           dataset = "rtank/john";
  #         };
  #       };
  #     };
  # };

  # Scrub to find errors
  services.zfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };
  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction

  boot.supportedFilesystems = [ "zfs" ];
  # networking.hostId = "f2119c72";
  # boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.generationsDir.copyKernels = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.copyKernels = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.zfsSupport = true;
  # boot.loader.grub.extraPrepareConfig = ''
  # mkdir -p /boot/efis
  # for i in  /boot/efis/*; do mount $i ; done

  # mkdir -p /boot/efi
  # mount /boot/efi
  # '';
  boot.loader.grub.extraInstallCommands = ''
    ESP_MIRROR=$(${pkgs.coreutils}/bin/mktemp -d)
    ${pkgs.coreutils}/bin/cp -r /boot/efi/EFI $ESP_MIRROR
    for i in /boot/efis/*; do
     ${pkgs.coreutils}/bin/cp -r $ESP_MIRROR/EFI $i
    done
    ${pkgs.coreutils}/bin/rm -rf $ESP_MIRROR
  '';
  boot.loader.grub.devices =
    [ "/dev/disk/by-id/nvme-WD_BLACK_SN850X_1000GB_223761800744" ];
}
