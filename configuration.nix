{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.kernelModules = [ "snd-seq" "snd-rawmidi" ];
  # Disable annoying beep!
  boot.blacklistedKernelModules = [ "snd_pcsp" "pcspkr" ]; 

environment= with pkgs; {
    systemPackages = [
#system:
    unzip
    gnumake
    cmake
    gcc
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
    faust = pkgs.callPackage /home/bart/soujagajagarce/nixpkgs/pkgs/applications/audio/faust/default.nix { }; 
    faust-compiler = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/faust-compiler/default.nix { }; 
    sselp = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/tools/X11/sselp{ };
    xrandr-invert-colors = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/misc/xrandr-invert-colors/default.nix { }; 
  };

  powerManagement.cpuFreqGovernor = "performance";

  programs.zsh.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
#    passwordAuthentication = false;
  };

  /*services.transmission = {*/
    /*enable = true;*/
  /*};*/

#  services.logind.extraConfig = "HandleLidSwitch=ignore";

  time.timeZone = "Europe/Amsterdam";

    services.udev = {
      #packages = [ pkgs.ffado ]; # If you have a FireWire audio interface
      extraRules = ''
        KERNEL=="rtc0", GROUP="audio"
        KERNEL=="hpet", GROUP="audio"
      '';
    };

  # Enable CUPS to print documents.
  # printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";

  services.xserver.synaptics.enable = true;
  services.xserver.synaptics.twoFingerScroll = true;

  # Enable the KDE Desktop Environment.
  # xserver.displayManager.kdm.enable = true;
  # xserver.desktopManager.kde4.enable = true;

  # Enable the i3 window manager
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.default = "i3" ;
 # services.xserver.windowManager.i3.configFile = $HOME/.config/i3/config;








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
