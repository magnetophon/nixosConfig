#{pkgs, ...}: with pkgs;
{pkgs, config, ...}: with pkgs;
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
      kernel.sysctl = { "vm.swappiness" = 10; "fs.inotify.max_user_watches" = 524288; };
      kernelParams = [ "threadirq" ];
    };

  fileSystems =
  {
	"/" = {	options = "noatime errors=remount-ro";};

  };

security.pam.loginLimits =
 [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
    { domain = "@audio"; item = "nofile"; type = "soft"; value = "99999"; }
    { domain = "@audio"; item = "nofile"; type = "hard"; value = "99999"; }
  ];



/*todo:*/
/*postBootCommands = "${pkgs.procps}/sbin/sysctl -w vm.swappiness=10";*/
/*echo 2048 > /sys/class/rtc/rtc0/max_user_freq*/
/*echo 2048 > /proc/sys/dev/hpet/max-user-freq*/
/*setpci -v -d *:* latency_timer=b0*/
/*setpci -v -s $SOUND_CARD_PCI_ID latency_timer=ff # eg. SOUND_CARD_PCI_ID=03:00.0 (see below)*/
/*The SOUND_CARD_PCI_ID can be obtained like so:*/

/*$ lspci ¦ grep -i audio*/

  services = {
    #dbus.packages = [ pkgs.gnome.GConf ];
    acpid.enable = true;
    #avahi.enable = true;
    #locate.enable = true;
    openssh = {enable = true; ports = [ 22 ];};
    xserver = {
      enable = true;
      displayManager.slim.enable = true;
      synaptics = import ./synaptics.nix;
      #todo: horizontal edge scroll
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
  nixpkgs.config = {
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

  shellInit = ''
    export LV2_PATH=/nix/var/nix/profiles/default/lib/lv2:/var/run/current-system/sw/lib/lv2
    export VST_PATH=/nix/var/nix/profiles/default/lib/vst:/var/run/current-system/sw/lib/vst:~/.vst
    export LXVST_PATH=/nix/var/nix/profiles/default/lib/lxvst:/var/run/current-system/sw/lib/lxvst:~/.lxvst
    export LADSPA_PATH=/nix/var/nix/profiles/default/lib/ladspa:/var/run/current-system/sw/lib/ladspa:~/.ladspa
    export LV2_PATH=/nix/var/nix/profiles/default/lib/lv2:/var/run/current-system/sw/lib/lv2:~/.lv2
    export DSSI_PATH=/nix/var/nix/profiles/default/lib/dssi:/var/run/current-system/sw/lib/dssi:~/.dssi
  '';




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
      extraGroups = [ "wheel" "audio" ];
      #todo = make user actually be in audio
      #extraGroups = [ "audio" ];
      useDefaultShell = true;
      #shell = pkgs.zsh + "/usr/bin/zsh";
    };
  };
}
