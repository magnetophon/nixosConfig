#{pkgs, ...}: with pkgs;
{pkgs, config, ...}: with pkgs;
{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      # Include musnix: a meta-module for realtime audio.
      /home/bart/source/musnix/default.nix
    ];


  musnix = {
    enable = true;
    kernel.optimize = true;
  };

  hardware.cpu.intel.updateMicrocode = true;

    boot = {
      loader.grub.enable = true;
      loader.grub.version = 2;
      loader.grub.device = "/dev/sda";
      loader.grub.extraEntries = ''
        menuentry 'Debian GNU/Linux, with Linux 3.2.0-4-rt-686-pae' --class debian --class gnu-linux --class gnu --class os {
          load_video
          insmod gzio
          insmod part_msdos
          insmod ext2
          set root='(hd0,msdos1)'
          search --no-floppy --fs-uuid --set=root 6a2a2731-147e-49f9-866f-70cbf61d234c
          echo	'Loading Linux 3.2.0-4-rt-686-pae ...'
          linux	/boot/vmlinuz-3.2.0-4-rt-686-pae root=UUID=6a2a2731-147e-49f9-866f-70cbf61d234c ro  quiet
          echo	'Loading initial ramdisk ...'
          initrd	/boot/initrd.img-3.2.0-4-rt-686-pae
        }
        menuentry 'Debian GNU/Linux, with Linux 3.2.0-4-rt-686-pae (recovery mode)' --class debian --class gnu-linux --class gnu --class os {
          load_video
          insmod gzio
          insmod part_msdos
          insmod ext2
          set root='(hd0,msdos1)'
          search --no-floppy --fs-uuid --set=root 6a2a2731-147e-49f9-866f-70cbf61d234c
          echo	'Loading Linux 3.2.0-4-rt-686-pae ...'
          linux	/boot/vmlinuz-3.2.0-4-rt-686-pae root=UUID=6a2a2731-147e-49f9-866f-70cbf61d234c ro single
          echo	'Loading initial ramdisk ...'
          initrd	/boot/initrd.img-3.2.0-4-rt-686-pae
        }
        '';

      loader.grub.memtest86.enable = true;

      #kernelPackages = pkgs.linuxPackages_3_14_rt;

      blacklistedKernelModules = [ "snd_pcsp" "pcspkr" ];
    };

  fileSystems =
  {
	"/" = { options = "noatime errors=remount-ro"; };

  };

security = {
   setuidPrograms = [
    "xlaunch"
    ];
  };

nix = {
    useChroot = true;
    chrootDirs = ["/home/nixchroot"];

    extraOptions = "
    gc-keep-outputs = true       # Nice for developers
    gc-keep-derivations = true   # Idem
    env-keep-derivations = false

    binary-caches = https://nixos.org/binary-cache http://cache.nixos.org
    trusted-binary-caches = https://nixos.org/binary-cache https://cache.nixos.org https://hydra.nixos.org http://hydra.nixos.org
    ";
};


  services = {
    nixosManual.showManual = true;
    #dbus.packages = [ pkgs.gnome.GConf ];
    acpid.enable = true;
    cron.enable =false;
    #avahi.enable = true;
    #locate.enable = true;
    openssh = {enable = true; ports = [ 22 ];};
    xserver = {
      enable = true;
      #autorun = false;
      displayManager.lightdm.enable = true;
      synaptics = import ./synaptics.nix;
      #todo: horizontal edge scroll
      #startGnuPGAgent = true;

      # Enable the i3 window manager
      windowManager.default = "i3" ;
      windowManager.i3.enable = true;
      #windowManager.i3.configFile = $HOME/.config/i3/config;
      desktopManager.xterm.enable = false;
      xkbOptions = "caps:swapescape";
    };
    #rtirq.enable = true;
  /*transmission.enable = true;*/
  };

  nixpkgs.config = {
    allowUnfree = true;
    firefox.enableAdobeFlash = true;
    packageOverrides = pkgs : rec {
      #faust = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/faust/default.nix { }; 
      #faust-compiler = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/faust-compiler/default.nix { }; 
      #sselp = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/tools/X11/sselp{ };
      #xrandr-invert-colors = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/misc/xrandr-invert-colors/default.nix { }; 
      #no-beep =  pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/misc/xrandr-invert-colors/default.nix { }; 
      #rtirq = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/tools/audio/rtirq  { };
      #spideroak = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/networking/spideroak  { };
    };
  };

environment= {
    systemPackages = [
#system:
    hibernate
    unzip
    zip
    unrar
    gnumake
    cmake
    gcc
    ncurses
    stow
    tmux
    #pkgconfig
    rxvt_unicode
    zsh
    fasd
    #wicd
    htop
    iotop
    latencytop
    gitFull
    mercurial
    curl
    rubygems
    vim_configurable
    #vimHugeXWrapper
    ctags
    which
    nix-repl
    nixpkgs-lint
    xlaunch
    obnam # backup
    gparted
    #makeWrapper
    #no-beep
  #vim
    vifm
    #spaceFM
    #gvim
    xdg_utils
#windowmanager etc:
    wget
    i3
    i3status
    dmenu
    parcellite
#audio
    audacity
    a2jmidid
    #beast
    jack2
    jack_capture
    qjackctl
    ardour
    distrho
    flac
    fluidsynth
    freewheeling
    guitarix
    hydrogen
    ingen
    #jack-oscrolloscope
    jackmeter
    #ladspa-plugins
    lame
    #mda-lv2
    puredata
    setbfree
    #vimpc  #A vi/vim inspired client for the Music Player Daemon (mpd)
    vlc
    yoshimi
    zynaddsubfx
#desktop
    #desktop-file-utils
    #firefox
    firefoxWrapper
    w3m
    youtubeDL
    #gitit or ikiwiki
    feh
    ranger
    imagemagickBig
    evopedia
    meld
    freemind
    baobab
    recoll
    zathura
    xbmc
    pidgin
    #pidginotr   #see https://otr.cypherpunks.ca/
    #toxprpl
    aspellDicts.nl
    libreoffice
# iDevice stuff:
    usbmuxd
    libimobiledevice
    spideroak
#custom packages
    xrandr-invert-colors
    faust-compiler
    faust
    sselp
   ];
/*applist = [*/
	/*{mimetypes = ["text/plain" "text/css"]; applicationExec = "${pkgs.sublime3}/bin/sublime";}*/
	/*{mimetypes = ["text/html"]; applicationExec = "${pkgs.firefox}/bin/firefox";}*/
	/*];*/
	
	/*xdg_default_apps = import /home/matej/workarea/helper_scripts/nixes/defaultapps.nix { inherit pkgs; inherit applist; };*/
	
/*environment.etc*/

    /*Set of files that have to be linked in /etc.*/

    /*Default: { }*/

    /*Example:*/

    /*{ hosts =*/
        /*{ source = "/nix/store/.../etc/dir/file.conf.example";*/
          /*mode = "0440";*/
        /*};*/
      /*"default/useradd".text = "GROUP=100 ...";*/
    /*}*/
/*networking.extraHosts*/
/*networking.interfaces*/

    /*The configuration for each network interface. If networking.useDHCP is true, then every interface not listed here will be configured using DHCP.*/

    /*Default: { }*/

    /*Example: { eth0 = { ipAddress = "131.211.84.78"; subnetMask = "255.255.255.128"; } ; } */

/*services.bitlbee.enable*/

    /*Whether to run the BitlBee IRC to other chat network gateway. Running it allows you to access the MSN, Jabber, Yahoo! and ICQ chat networks via an IRC client. */

  shells = [
      "${pkgs.zsh}/bin/zsh"
      ];

};

  programs.zsh = {
    enable = true;
    interactiveShellInit = ''
      export EDITOR="vim"
      export VISUAL="vim"
      bindkey "^[[A" history-beginning-search-backward
      bindkey "^[[B" history-beginning-search-forward
    '';
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = [
      pkgs.terminus_font
    ];
  };

  i18n.consoleFont = "Lat2-Terminus16";

   networking = {
    firewall.enable = false;
    hostName = "NIX";
    connman.enable = true;
    #wireless.enable = true;
    #interfaceMonitor.enable = true;
    #wicd.enable =  true;
  };


  time.timeZone = "Europe/Amsterdam";

  users = {
    defaultUserShell = "/var/run/current-system/sw/bin/zsh";
    extraUsers.bart = {
      name = "bart";
      group = "users";
      uid = 1000;
      createHome = true;
      home = "/home/bart";
      extraGroups = [ "wheel" "audio" ];
      #todo = make user actually be in audio
      #extraGroups = [ "audio" ];
      #useDefaultShell = true;
      #shell = pkgs.zsh + "/usr/bin/zsh";
      #shell = "/run/current-system/sw/bin/zsh";
      shell = "${pkgs.zsh}/bin/zsh";
    };
    mutableUsers = true;
  };
}
