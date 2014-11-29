{pkgs, ...}: with pkgs;
{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  boot = {
    loader.grub.enable = true;
    loader.grub.version = 2;
    loader.grub.device = "/dev/sda";
    kernelModules = [ "snd-seq" "snd-rawmidi" ];
  };

  services = {
    dbus.packages = [ pkgs.gnome.GConf ];
    acpid.enable = true;
    avahi.enable = true;
    locate.enable = true;
    openssh = {enable = true; ports = [ 22 ];};
    xserver = {
      enable = true;
      displayManager.enable = false;
      synaptics = {
        enable = true;
        twoFingerScroll = true;
      };
      #startGnuPGAgent = true;

      # Enable the i3 window manager
      windowManager.default = "i3" ;
      windowManager.i3.enable = true;
      #windowManager.i3.configFile = $HOME/.config/i3/config;
    };
    udev = {
      #packages = [ pkgs.ffado ]; # If you have a FireWire audio interface
      extraRules = ''
        KERNEL=="rtc0", GROUP="audio"
        KERNEL=="hpet", GROUP="audio"
      '';
    };
  /*transmission.enable = true;*/
  };
  config = {
    allowUnfree = true;
    firefox.enableGoogleTalkPlugin = true;
    firefox.enableAdobeFlash = true;
    packageOverrides = pkgs : rec {
      faust = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/faust/default.nix { }; 
      faust-compiler = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/faust-compiler/default.nix { }; 
      sselp = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/tools/X11/sselp{ };
      xrandr-invert-colors = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/misc/xrandr-invert-colors/default.nix { }; 
      #no-beep =  pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/misc/xrandr-invert-colors/default.nix { }; 
    };
  };

environment= {
    systemPackages = [
#system:
    unzip
    gnumake
    cmake
    gcc
    ncurses

    #pkgconfig
    rxvt_unicode
    zsh
    wicd
    htop
    iotop
    gitFull
    curl
    rubygems
    vim_configurable
    which
    nix-repl
    #makeWrapper
    #no-beep
  #vim
    vifm
    spaceFM
    #gvim
    pidgin
    xdg_utils
#windowmanager etc:
    wget
    i3
    i3status
    dmenu
    parcellite
#audio
    a2jmidid
    #beast
    jackaudio
    qjackctl
    ardour
    distrho
    flac
    fluidsynth
    #freewheeling
    guitarix
    hydrogen
    ingen
    #jack-oscrolloscope
    jackmeter
    #ladspa-plugins
    lame
    #mda-lv2
    puredata
    #setbfree
    #vimpc
    yoshimi
    zynaddsubfx
#desktop
    firefox
    meld
    freemind
    baobab
    zathura
    xbmc
#custom packages
    xrandr-invert-colors
    faust-compiler
    faust
    sselp
   ];
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = [
      pkgs.terminus_font
    ];
  };

   networking = {
    firewall.enable = false;
    hostName = "NIX";
    wireless.enable = false;
    interfaceMonitor.enable = false;
    wicd.enable =  true;
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.firefox.enableAdobeFlash = true;

  nixpkgs.config.packageOverrides = pkgs: { 
    faust = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/faust/default.nix { }; 
    faust-compiler = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/faust-compiler/default.nix { }; 
    sselp = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/tools/X11/sselp{ };
    xrandr-invert-colors = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/misc/xrandr-invert-colors/default.nix { }; 
    #no-beep =  pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/misc/xrandr-invert-colors/default.nix { }; 
  };

  powerManagement.cpuFreqGovernor = "performance";

  programs.zsh.enable = true;

  time.timeZone = "Europe/Amsterdam";

  users = {
    #defaultUserShell = "/var/run/current-system/sw/bin/zsh";
    extraUsers.bart = {
      name = "bart";
      group = "users";
      uid = 1000;
      createHome = true;
      home = "/home/bart";
      #extraGroups = [ "wheel" "audio" ];
      extraGroups = [ "audio" ];
      useDefaultShell = true;
      #shell = pkgs.zsh + "/usr/bin/zsh";
    };
  };
}
