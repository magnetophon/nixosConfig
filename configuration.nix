#{pkgs, ...}: with pkgs;
{pkgs, config, ...}: with pkgs;
{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      # Include musnix: a meta-module for realtime audio.
      #/home/bart/source/musnix/
    ];

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
      kernelPackages = let
        rtKernel = pkgs.linuxPackagesFor (pkgs.linux.override {
          extraConfig = ''
            PREEMPT_RT_FULL? y
            PREEMPT y
            IOSCHED_DEADLINE y
            DEFAULT_DEADLINE y
            DEFAULT_IOSCHED "deadline"
            HPET_TIMER y
            CPU_FREQ n
            TREE_RCU_TRACE n
          '';
        }) pkgs.linuxPackages;
      in rtKernel;
      #in mkIf cfg.enableRealtimeKernel rtKernel;


      #kernelPackages = pkgs.linuxPackages_3_14_rt;

      kernelModules = [ "snd-seq" "snd-rawmidi" ];
      blacklistedKernelModules = [ "snd_pcsp" "pcspkr" ];
      kernel.sysctl = { "vm.swappiness" = 10; };
      kernelParams = [ "threadirq" ];

      postBootCommands = ''
      echo 2048 > /sys/class/rtc/rtc0/max_user_freq
      echo 2048 > /proc/sys/dev/hpet/max-user-freq
      setpci -v -d *:* latency_timer=b0
      setpci -v -s $00:1b.0 latency_timer=ff
      '';
      /*The SOUND_CARD_PCI_ID can be obtained like so:*/
      /*$ lspci ¦ grep -i audio*/
    };

  fileSystems =
  {
	"/" = { options = "noatime errors=remount-ro"; };

  };

security = {
  pam.loginLimits =
  [
      { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
      { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
      { domain = "@audio"; item = "nofile"; type = "soft"; value = "99999"; }
      { domain = "@audio"; item = "nofile"; type = "hard"; value = "99999"; }
   ];
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
      autorun = false;
      displayManager.slim.enable = true;
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
    udev = {
      #packages = [ pkgs.ffado ]; # If you have a FireWire audio interface
      extraRules = ''
        KERNEL=="rtc0", GROUP="audio"
        KERNEL=="hpet", GROUP="audio"
      '';
    };
    #rtirq.enable = true;
  /*transmission.enable = true;*/
  };

  nixpkgs.config = {
    allowUnfree = true;
    firefox.enableAdobeFlash = true;
    packageOverrides = pkgs : rec {
      faust = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/faust/default.nix { }; 
      faust-compiler = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/faust-compiler/default.nix { }; 
      sselp = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/tools/X11/sselp{ };
      xrandr-invert-colors = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/misc/xrandr-invert-colors/default.nix { }; 
      #no-beep =  pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/misc/xrandr-invert-colors/default.nix { }; 
      #rtirq = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/tools/audio/rtirq  { };
      spideroak = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/networking/spideroak  { };
    };
  };

environment= {
    systemPackages = [
#system:
    hibernate
    unzip
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
    curl
    rubygems
    vim_configurable
    ctags
    which
    nix-repl
    nixpkgs-lint
    xlaunch
    obnam # backup
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
    #desktop-file-utils
    #firefox
    #firefoxWrapper
    w3m
    youtubeDL
    #gitit or ikiwiki
    #icecat3
    feh
    imagemagickBig
    evopedia
    meld
    freemind
    baobab
    recoll
    zathura
    xbmc
    pidgin
    aspellDicts.nl
    libreoffice
    #spideroak
#custom packages
    #xrandr-invert-colors
    #faust-compiler
    #faust
    #sselp
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

  shellInit = ''
    export VST_PATH=/nix/var/nix/profiles/default/lib/vst:/var/run/current-system/sw/lib/vst:~/.vst
    export LXVST_PATH=/nix/var/nix/profiles/default/lib/lxvst:/var/run/current-system/sw/lib/lxvst:~/.lxvst
    export LADSPA_PATH=/nix/var/nix/profiles/default/lib/ladspa:/var/run/current-system/sw/lib/ladspa:~/.ladspa
    export LV2_PATH=/nix/var/nix/profiles/default/lib/lv2:/var/run/current-system/sw/lib/lv2:~/.lv2
    export DSSI_PATH=/nix/var/nix/profiles/default/lib/dssi:/var/run/current-system/sw/lib/dssi:~/.dssi
  '';
};

  programs.zsh = {
    enable = true;
    interactiveShellInit = ''
      export EDITOR="vim"
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


  powerManagement.cpuFreqGovernor = "performance";


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
