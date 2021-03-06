# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.copyKernels = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Add ZFS support.
  boot.supportedFilesystems = ["zfs"];
  # head -c 8 /etc/machine-id
  networking.hostId = "392d5564";
  # Note: If you do partition the disk, make sure you set the disk’s scheduler to none. ZFS takes this step automatically if it does control the entire disk.
  # On NixOS, you an set your scheduler to none via:
  boot.kernelParams = [ "elevator=none" ];
  #/dev/disk/by-id/wwn-0x5000c5005f5cb3b3"rt- Define on which hard drive you want to install Grub.
  boot.loader.grub.devices = [ # or "nodev" for efi only
    # DISK1: swap, if none of the other disks are there, we don't have a system, so no need for a bootloader
    # replaced DISK2 with DISK9
    #"/dev/disk/by-id/wwn-0x5000c5005ea8da23" # DISK2 DEAD
    "/dev/disk/by-id/wwn-0x5000c500629dc827" # DISK9
    "/dev/disk/by-id/wwn-0x5000c50068875a67" # DISK3
    "/dev/disk/by-id/wwn-0x5000c500688c9f77" # DISK4
  ];
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

  # ZFS services
  services.zfs.autoSnapshot.enable = true;
  services.zfs.autoScrub = {
    enable = true;
    interval = "daily";
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bart = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  users.extraUsers.nixBuild = {
    name = "nixBuild";
    isSystemUser = true;
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID1kJ2pCgAaixNICnm2WB6ILvE7+BTvNTaWPYBOvaXsv nixBuild" ];
  };

  nix = {
    allowedUsers = [ "nixBuild" ];
    trustedUsers  = [ "nixBuild" ];
  };



  services.openssh.extraConfig = ''
      Match User nixBuild
        AllowAgentForwarding no
        AllowTcpForwarding no
        PermitTTY no
        PermitTunnel no
        X11Forwarding no
      Match All
    '';

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Commandline tools
    coreutils
    gitAndTools.gitFull
    man
    tmux
    tree
    wget
    vim
    mkpasswd
    ranger
    htop
    lm_sensors
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.mosh.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 27511 ];
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  services.fail2ban = {
    enable = true;
    jails.sshd =
      ''
        enabled = true
        filter = sshd
        ignoreip = 127.0.0.1/8,192.168.178.1/24
       '';
  };

  # Enable Wake on LAN
  # this service runs before my NW card is ready
  # but is still needed for when I wake up from sleep
  # see: https://github.com/NixOS/nixpkgs/pull/97362?notification_referrer_id=MDE4Ok5vdGlmaWNhdGlvblRocmVhZDExMzcyNTU1MDI6NzY0NTcxMQ%3D%3D&notifications_query=is%3Aunread#issuecomment-823307947
  services.wakeonlan.interfaces = [
	  { interface = "eno1"; method = "magicpacket"; }
  ];
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

