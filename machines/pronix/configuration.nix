# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.copyKernels = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Add ZFS support.
  boot.supportedFilesystems = [ "zfs" ];
  # head -c 8 /etc/machine-id
  networking.hostId = "392d5564";
  # boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  # Note: If you do partition the disk, make sure you set the disk’s scheduler to none. ZFS takes this step automatically if it does control the entire disk.
  # On NixOS, you an set your scheduler to none via:
  boot.kernelParams = [ "elevator=none" ];
  #/dev/disk/by-id/wwn-0x5000c5005f5cb3b3"rt- Define on which hard drive you want to install Grub.
  boot.loader.grub.devices = [ # or "nodev" for efi only
    # DISK1: swap, if none of the other disks are there, we don't have a system, so no need for a bootloader
    # TODO: replace DISK2 with DISK9 after badblocks and long test
    #"/dev/disk/by-id/wwn-0x5000c5005ea8da23" # DISK2   DEAD
    # "/dev/disk/by-id/wwn-0x5000c500629dc827" # DISK9   SPARE
    # "/dev/disk/by-id/wwn-0x5000c5005f5cb3b3" # DISK1
    #"/dev/disk/by-id/wwn-0x5000c50068875a67" # DISK3 DEAD
    #"/dev/disk/by-id/wwn-0x5000c500688c9f77" # DISK4 DEAD
    # "/dev/disk/by-id/wwn-0x5000c500681b817b" # DISK14 DEAD
    "/dev/disk/by-id/wwn-0x5000c500684c2f73" # DISK15
    # "/dev/disk/by-id/wwn-0x5000c5004be2033b" # DISK16 FAULTED
    "/dev/disk/by-id/wwn-0x5000c500681b26fb" # DISK17
    "/dev/disk/by-id/wwn-0x5000c500763332ff" # DISK18
  ];
  boot.tmp.useTmpfs = true;
  networking.hostName = "pronix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.eno2.useDHCP = true;
  networking.interfaces.eno3.useDHCP = true;
  networking.interfaces.eno4.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    groups.nixBuild = { };
    users = {
      bart = {
        isNormalUser = true;
        extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
        # shell = pkgs.zsh;
      };
      nixBuild = {
        name = "nixBuild";
        isSystemUser = true;
        useDefaultShell = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID1kJ2pCgAaixNICnm2WB6ILvE7+BTvNTaWPYBOvaXsv nixBuild"
        ];
        group = "nixBuild";
      };
    };
  };
  nix.settings = {
    allowed-users = [ "nixBuild" "@wheel" ];
    trusted-users = [ "nixBuild" ];
    auto-optimise-store = true;
    download-buffer-size = 500000000; # 500 MB
  };


  #virtualisation.virtualbox =
  #{
  #host.enable = true;
  # guest.enable = true;
  #};

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      # Commandline tools
      coreutils
      gitAndTools.gitFull
      parted
      man
      tmux
      thumbs # tmux-thumbs
      tree
      wget
      vim
      mkpasswd
      pass
      gnupg
      pinentry
      pinentry-curses
      smartmontools
      ranger
      yazi
      lf
      joshuto
      zoxide
      fclones
      rmlint
      eza
      htop
      lm_sensors
      nix-zsh-completions
      nixos-option
      nixfmt
      speedtest-cli
      fzf
      skim
      bottom
      xclip
      tealdeer
      shellcheck
      # doom emacs dependencies
      git
      # emacs # Emacs 27.2
      cmake
      gnumake
      pandoc
      haskellPackages.markdown
      mu
      isync
      editorconfig-core-c # per-project style config
      gnutls              # for TLS connectivity
      imagemagickBig         # for image-dired
      pinentry-emacs      # in-emacs gnupg prompts
      zstd                # for undo-tree compression
      aspell
      sqlite
      nodejs
      faust
      ripgrep
      coreutils # basic GNU utilities
      fd
      clang
      nix-du
      nix-tree

      cargo
      rustc

      jq


      ollama
      # dirname
    ];

    shells = [ pkgs.zsh ];
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs = {
    zsh.enable = true;
    mosh.enable = true;

    # Mail notification for ZFS Event Daemon:
    msmtp = {
      enable = true;
      setSendmail = true;
      defaults = {
        aliases = "/etc/aliases";
        port = 465;
        tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";
        tls = "on";
        auth = "login";
        tls_starttls = "off";
      };
      accounts = {
        default = {
          host = "sub5.mail.dreamhost.com";
          passwordeval = "pass mail";
          user = "bart@magnetophon.nl";
          from = "bart@magnetophon.nl";
        };
      };
    };
    gnupg.agent = {
      enable = true;
      # pinentryFlavor = "curses"; # should be automatic
      enableSSHSupport = true;
    };
  };

  # List services that you want to enable:

  services = {

    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      ports = [ 511 ];
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
      extraConfig = ''
        Match User nixBuild
        AllowAgentForwarding no
        AllowTcpForwarding no
        PermitTTY no
        PermitTunnel no
        X11Forwarding no
        Match All
      '';
    };

    fail2ban = {
      enable = true;
      jails.sshd = lib.mkForce ''
      enabled = true
      filter = sshd
      ignoreip = 127.0.0.1/8,192.168.178.1/24
    '';
    };

    smartd = {
      enable = true;
    };

    # ZFS services
    zfs= {
      autoSnapshot.enable = true;
      autoScrub = {
        enable = true;
        interval = "weekly";
      };
      trim.enable = true;
      # zed = {
      # settings = {
      # ZED_DEBUG_LOG = "/tmp/zed.debug.log";
      # ZED_EMAIL_ADDR = [ "root" ];
      # ZED_EMAIL_PROG = "${pkgs.msmtp}/bin/msmtp";
      # ZED_EMAIL_OPTS = "@ADDRESS@";

      # ZED_NOTIFY_INTERVAL_SECS = 3600;
      # ZED_NOTIFY_VERBOSE = true;

      # ZED_USE_ENCLOSURE_LEDS = true;
      # ZED_SCRUB_AFTER_RESILVER = true;
      # };
      # this option does not work; will return error
      # enableMail = false;
        # };
    };

    # Enable the X11 windowing system.
    # services.xserver.enable = true;

    # Configure keymap in X11
    # services.xserver.layout = "us";
    # services.xserver.xkbOptions = "eurosign:e";

    # Enable CUPS to print documents.
    # services.printing.enable = true;

    # Enable sound.
    # sound.enable = true;
    # hardware.pulseaudio.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;
    emacs = {
      enable = true;
      defaultEditor = true;
      package = pkgs.emacs.override {
        withNativeCompilation = true;
      };
      # package =
      # ((emacsPackagesFor emacsNativeComp).emacsWithPackages (epkgs: [
      # epkgs.vterm
      # ]));

      # extraPackages = epkgs: with epkgs; [
      # vterm
      # ];
    };
    # pcscd.enable = true;
  };

  # Enable Wake on LAN
  # this service runs before my NW card is ready
  # but is still needed for when I wake up from sleep
  # see: https://github.com/NixOS/nixpkgs/pull/97362?notification_referrer_id=MDE4Ok5vdGlmaWNhdGlvblRocmVhZDExMzcyNTU1MDI6NzY0NTcxMQ%3D%3D&notifications_query=is%3Aunread#issuecomment-823307947
  # services.wakeonlan.interfaces = [
  # { interface = "eno1"; method = "magicpacket"; }
  # ];
  networking.interfaces.eno1.wakeOnLan = {
    enable = true;
    # method = "magicpacket";
  };
  # this covers the rest of the cases
  systemd.services.wol-eth0 = {
    description = "Wake-on-LAN for eno1";
    requires = [ "network.target" ];
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.ethtool}/bin/ethtool -s eno1 wol g"; # magicpacket
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}
