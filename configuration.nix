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
    kernel.realtime = true;
    soundcardPciId = "00:1b.0";
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
      #resumeDevice = "/dev/sda5";
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
    auto-optimise-store = true
    ";
};


  services = {
    nixosManual.showManual = true;
    #dbus.packages = [ pkgs.gnome.GConf ];
    #dbus.packages = lib.mkAfter (lib.singleton /home/bart/source/nixpkgs/pkgs/misc/jackaudio/default.nix);
    acpid.enable = true;
    cron.enable =false;
    #avahi.enable = true;
    #locate.enable = true;
    openssh = {enable = true; ports = [ 22 ];};
    xserver = {
      enable = true;
      #autorun = false;
      #vaapiDrivers = [ pkgs.vaapiIntel ];
      displayManager.lightdm.enable = true;
      synaptics = import ./synaptics.nix;
      #todo: horizontal edge scroll
      startGnuPGAgent = true;

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
      faust = pkgs.callPackage /home/bart/source/nix-faust/nixpkgs/pkgs/applications/audio/faust/default.nix { }; 
      faust2alqt = pkgs.callPackage /home/bart/source/nix-faust/nixpkgs/pkgs/applications/audio/faust/faust2alqt.nix  { }; 
      faust2alsa = pkgs.callPackage /home/bart/source/nix-faust/nixpkgs/pkgs/applications/audio/faust/faust2alsa.nix  { }; 
      faust2firefox = pkgs.callPackage /home/bart/source/nix-faust/nixpkgs/pkgs/applications/audio/faust/faust2firefox.nix  { }; 
      faust2jack = pkgs.callPackage /home/bart/source/nix-faust/nixpkgs/pkgs/applications/audio/faust/faust2jack.nix  { }; 
      faust2jaqt = pkgs.callPackage /home/bart/source/nix-faust/nixpkgs/pkgs/applications/audio/faust/faust2jaqt.nix  { }; 
      faust2lv2 = pkgs.callPackage /home/bart/source/nix-faust/nixpkgs/pkgs/applications/audio/faust/faust2lv2.nix  { }; 
      #faust-compiler = pkgs.callPackage /home/bart/source/nix-faust/nixpkgs/pkgs/applications/audio/faust-compiler/default.nix { }; 
        sooperlooper = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/sooperlooper/default.nix { }; 
      #rtirq = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/tools/audio/rtirq  { };
      #jack2 = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/misc/jackaudio/default.nix { };
      puredata-with-plugins = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/puredata/wrapper.nix { inherit plugins; };
      pd-extended = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/pd-extended/default.nix { };
      pd-extended-with-plugins = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/pd-extended/wrapper.nix { inherit plugins; };
      helmholtz = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/pd-plugins/helmholtz/default.nix { };
      timbreid = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/pd-plugins/timbreid/default.nix { };
      maxlib = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/pd-plugins/maxlib/default.nix { };
      puremapping = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/pd-plugins/puremapping/default.nix { };
      zexy = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/pd-plugins/zexy/default.nix { };
      cyclone = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/pd-plugins/cyclone/default.nix { };
      osc = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/pd-plugins/osc/default.nix { };
      mrpeach = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/pd-plugins/mrpeach/default.nix { };
    };
  };

environment= {
    systemPackages = [
#system:
    #hibernate
    unzip
    zip
    unrar
    p7zip
    gnumake
    cmake
    gcc
    ncurses
    stow
    tmux
    #pkgconfig
    #rxvt_unicode_with-plugins
    rxvt_unicode
    termite
    #terminology
    zsh
    fish
    fasd
    vlock
    #wicd
    htop
    iotop
    latencytop
    gitFull
    mercurial
    curl
    inetutils
    rubygems
    ruby
    icedtea7_jre
    vim_configurable
    #vimHugeXWrapper
    ctagsWrapped.ctagsWrapped
    which
    nix-repl
    nixpkgs-lint
    nix-prefetch-scripts
    nox
    xlaunch
    obnam # backup
    python
    gparted
    unetbootin
    #makeWrapper
    #no-beep
    xlibs.xinit
  #vim
    vifm
    #spaceFM
    #gvim
    xdg_utils
    gnupg
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
    caps
    calf
    jack2
    jack_capture
    qjackctl
    ardour
    #distrho
    flac
    fluidsynth
    freewheeling
    guitarix
    hydrogen
    ingen
    #jack-oscrolloscope
    jackmeter
    liblo
    ladspaH
    ladspaPlugins
    #ladspa-plugins
    lame
    #mda-lv2
    #puredata
    (pkgs.puredata-with-plugins.override { plugins = [ helmholtz timbreid maxlib puremapping zexy cyclone mrpeach ]; })
    #(pkgs.pd-extended-with-plugins.override { plugins = [ helmholtz timbreid ]; })
    setbfree
    supercollider
    #vimpc  #A vi/vim inspired client for the Music Player Daemon (mpd)
    vlc
    yoshimi
    zynaddsubfx
#desktop
    #desktop-file-utils
    #firefox
    firefoxWrapper
    #chromium
    #chromiumBeta
    w3m
    youtubeDL
    galculator
    #gitit or ikiwiki
    feh
    xrandr-invert-colors
    sselp
    ranger
      # for ranger previews:
      atool
      highlight
      file
      libcaca
      perlPackages.ImageExifTool
      poppler
      transmission
    #mutt-with-sidebar
    urlview
    offlineimap
    notmuch
    #remind    #calendar
    #wyrd      # front end for remind
    #pypyPackages.alot
    #python27Packages.alot
    filezilla
    imagemagickBig
    evopedia
    meld
    freemind
    baobab
    recoll
    zathura
    xbmc
    #pidgin
    (pkgs.pidgin-with-plugins.override { plugins = [ pidginotr ]; }) # pidgin + pidgin-otr
    skype
    #toxprpl
    aspellDicts.en
    aspellDicts.nl
    aspellDicts.de
    libreoffice
# iDevice stuff:
    usbmuxd
    libimobiledevice
    spideroak
#custom packages
    #faust-compiler
    faust
    faust2alqt
    faust2alsa
    faust2firefox
    faust2jack
    faust2jaqt
    faust2lv2
    #sooperlooper
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
      export LESS=-X
      export NIXPKGS=/home/bart/source/nixpkgs/
      export NIXPKGS_ALL=/home/bart/source/nixpkgs/pkgs/top-level/all-packages.nix
      bindkey "^[[A" history-beginning-search-backward
      bindkey "^[[B" history-beginning-search-forward
    '';
  };

  programs.ssh.startAgent = false; #not needed with gpg-agent

      #export LESS=-X so that less doesn't clear the screen after quit
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
