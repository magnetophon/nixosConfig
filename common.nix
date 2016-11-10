{pkgs, config, ...}: with pkgs;
{

  imports = [
    ./vim.nix
    ./spacemacs.nix
    ];
  #todo: mixos: https://wiki.archlinux.org/index.php/SSD

  hardware.cpu.intel.updateMicrocode = true;
  # for skype
  #hardware.pulseaudio.enable = true;

  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      memtest86.enable = true;
    };
    blacklistedKernelModules = [ "snd_pcsp" "pcspkr" ];
  };

  nix = {
    useSandbox = true;
    sandboxPaths = ["/home/nixchroot"];
    requireSignedBinaryCaches = true;
    extraOptions = "
      gc-keep-outputs = true       # Nice for developers
      gc-keep-derivations = true   # Idem
      env-keep-derivations = false
      binary-caches = https://nixos.org/binary-cache
      trusted-binary-caches = https://nixos.org/binary-cache https://cache.nixos.org https://hydra.nixos.org
      auto-optimise-store = false
    ";
  };

  # Copy the system configuration int to nix-store.
  # system.copySystemConfiguration = true;

  services = {
    nixosManual.showManual = false;
    # printing.enable = true;
    # acpid.enable = true;
    cron.enable =false;
    #avahi.enable = true;
    #locate.enable = true;
    journald.extraConfig = ''
      [Journal]
      SystemMaxUse=50M
      SystemMaxFileSize=10M
    '';
    openssh = {
      enable = true;
      ports = [ 22 ];
      forwardX11 = true;
      };
    xserver = {
      enable = true;
      enableCtrlAltBackspace = true;
      displayManager.lightdm.enable = true;
      # displayManager.kdm = {
      #   enable = true;
      #   enableXDMCP = true;
      #   extraConfig =
      #   ''
      #     [Xdmcp]
      #     Xaccess=${pkgs.writeText "Xaccess" "*"}
      #   '';
      # };
      synaptics = import ./synaptics.nix;
      desktopManager.xterm.enable = false;
      xkbOptions = "caps:swapescape";
    /*bitlbee.enable*/
    /*Whether to run the BitlBee IRC to other chat network gateway. Running it allows you to access the MSN, Jabber, Yahoo! and ICQ chat networks via an IRC client. */
    # autofs.enable = true;

    };
    /*psd = {*/
      /*enable = true;*/
      /*users = [ "bart" ];      # At least one is required*/
      /*browsers = [ "firefox" ];    # Leave blank to enable all*/
      /*# only available from kernel 3.18*/
      /*#useOverlayFS = false; # set to true to enable overlayfs or set to false to use the default sync mode*/
    /*};*/
    # unclutter.enable = true;
    emacs = {
      enable = true;
      defaultEditor = true;
      };
    physlock = {
      enable = true;
      user = "bart";
      lockOn = {
        suspend = true;
        hibernate = true;
      };
    };
  };

  nixpkgs.config = {
    # allowUnfree = true;
    #firefox.enableAdobeFlash = true;
    # firefox.enableMplayer = true;
    packageOverrides = pkgs : rec {
      /*faust = pkgs.callPackage /home/bart/source/nix-faust/nixpkgs/pkgs/applications/audio/faust/default.nix { }; */
      /*faust2alqt = pkgs.callPackage /home/bart/source/nix-faust/nixpkgs/pkgs/applications/audio/faust/faust2alqt.nix  { }; */
      /*faust2alsa = pkgs.callPackage /home/bart/source/nix-faust/nixpkgs/pkgs/applications/audio/faust/faust2alsa.nix  { }; */
      /*faust2firefox = pkgs.callPackage /home/bart/source/nix-faust/nixpkgs/pkgs/applications/audio/faust/faust2firefox.nix  { }; */
      /*faust2jack = pkgs.callPackage /home/bart/source/nix-faust/nixpkgs/pkgs/applications/audio/faust/faust2jack.nix  { }; */
      /*faust2jaqt = pkgs.callPackage /home/bart/source/nix-faust/nixpkgs/pkgs/applications/audio/faust/faust2jaqt.nix  { }; */
      /*faust2lv2 = pkgs.callPackage /home/bart/source/nix-faust/nixpkgs/pkgs/applications/audio/faust/faust2lv2.nix  { }; */
      /*#faust-compiler = pkgs.callPackage /home/bart/source/nix-faust/nixpkgs/pkgs/applications/audio/faust-compiler/default.nix { }; */
        /*sooperlooper = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/sooperlooper/default.nix { }; */
      /*#rtirq = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/tools/audio/rtirq  { };*/
      /*#jack2 = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/misc/jackaudio/default.nix { };*/
      /*#puredata-with-plugins = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/puredata/wrapper.nix { inherit plugins; };*/
      /*pd-extended = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/pd-extended/default.nix { };*/
      /*pd-extended-with-plugins = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/pd-extended/wrapper.nix { inherit plugins; };*/
      /*#helmholtz = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/pd-plugins/helmholtz/default.nix { };*/
      /*timbreid = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/pd-plugins/timbreid/default.nix { };*/
      /*maxlib = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/pd-plugins/maxlib/default.nix { };*/
      /*puremapping = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/pd-plugins/puremapping/default.nix { };*/
      /*zexy = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/pd-plugins/zexy/default.nix { };*/
      /*cyclone = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/pd-plugins/cyclone/default.nix { };*/
      /*osc = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/pd-plugins/osc/default.nix { };*/
      /*#mrpeach = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/pd-plugins/mrpeach/default.nix { };*/
      /*SynthSinger = pkgs.callPackage /home/bart/faust/SynthSinger/SynthSinger.nix { };*/
      /*#PitchTracker = (pkgs.puredata-with-plugins.override { plugins = [ helmholtz timbreid mrpeach ]; });*/
      /*nl_wa2014 = pkgs.callPackage /home/bart/nixpkgs/pkgs/applications/taxes/nl_wa2014 {};*/
      rofi = lib.overrideDerivation pkgs.rofi (attrs: rec {
        name = "rofi-unstable";
        src = pkgs.fetchgit {
          url = https://github.com/DaveDavenport/rofi.git;
          deepClone = true;
          rev = "545be58e40562b71dae98a6e7dfccdfe2a8dbf7d";
          sha256 = "069lmrlm068jwxxagzyb9li193rr1wlgf2r3fipkrzg5hfvn8i80";
        };
      });
    };
  };





environment= {
    systemPackages = [

#system:
    unzip
    zip
    p7zip
    gnumake
    cmake
    gcc
    gdb
    ncurses
    coreutils
    ntfs3g
    # openjdk
    stow
    tmux
    sshfsFuse
    acpi
    #rxvt_unicode_with-plugins
    rxvt_unicode
    termite
    # e19.terminology
    zsh
    fish
    fasd
    fzf
    openssl
    physlock
    # i3lock
    htop
    iotop
    powertop
    sysstat
    iptraf
    nethogs
    iftop
    hdparm
    testdisk
    glxinfo
    usbutils
    pciutils
    latencytop
    lsof
    psmisc
    gitFull
    mercurial
    subversion
    curl
    inetutils
    haskellPackages.ghc
    ruby
    ruby
    # icedtea_web
    /*vim_configurable*/
    /*vimHugeX*/
    #my_vim
    ctagsWrapped.ctagsWrapped
    emacs
    which
    gnuplot
    nix-repl
    nixpkgs-lint
    nix-prefetch-scripts
    nox
    xlaunch
    xlibs.xkill
    xlibs.xinit
    ltrace
    # obnam # backup
    # borgbackup
    storeBackup
    syncthing
    python27Packages.syncthing-gtk
    # khard
    # khal
    # vdirsyncer
    # pypyPackages.keyring
    python
    gparted
    parted
    smartmontools
    unetbootin
    makeWrapper
  #vim
    vifm
    # ( pkgs.xdg_utils.override { mimiSupport = true; })
    xdg_utils
    perlPackages.MIMETypes
    gnupg
#windowmanager etc:
    wget
    i3
    i3status
    dmenu
    clipster
    rofi
    conky
    dzen2
    xpra
    winswitch
#desktop
    #desktop-file-utils
    # firefoxWrapper
    firefox
  #for vimeo:
      gstreamer
      gst_plugins_base
      gst_plugins_good
      gst_plugins_bad
      gst_plugins_ugly
    torbrowser
    i2pd
    qutebrowser
    #chromium
    #chromiumBeta
    /*w3m*/
    (pkgs.w3m.override { graphicsSupport = true; })
    youtubeDL
    (pkgs.vlc.override { jackSupport = true;})
    galculator
    xrandr-invert-colors
    xcalib
    sselp
    xclip
    sxiv
    silver-searcher
    ranger
      # for ranger previews:
      atool
      highlight
      file
      libcaca
      perlPackages.ImageExifTool
      ffmpegthumbnailer
      poppler_utils
      transmission
      lynx
      mediainfo
    #mutt-with-sidebar
    # mutt-kz
    neomutt
    # taskwarrior
    paperkey
    gpa
    urlview
    offlineimap
    notmuch
    # remind    #calendar
    # wyrd      # front end for remind
    #pypyPackages.alot
    #python27Packages.alot
    filezilla
    imagemagickBig
    gimp
    inkscape
    # (pkgs.blender.override { jackaudioSupport = true; })
    # blender
    kde4.kdenlive
    ffmpeg-full
    simplescreenrecorder
    scrot
    handbrake
    evopedia
    meld
    freemind
    baobab
    recoll
    zathura
    # xbmc
    (pkgs.pidgin-with-plugins.override { plugins = [ pidginotr ]; }) # pidgin + pidgin-otr
    # weechat
    # irssi
    # gajim
# non-free:
    #skype
    #spideroak
    # unrar
    # calibre

    #toxprpl
    gtypist
    aspellDicts.en
    aspellDicts.nl
    aspellDicts.de
    # libreoffice
    kde4.k3b
# iDevice stuff:
    usbmuxd
    libimobiledevice
    ifuse
    sqlite
# see http://linuxsleuthing.blogspot.nl/2012/10/addressing-ios6-address-book-and-sqlite.html
# https://gist.github.com/laacz/1180765
#custom packages
    #nl_wa2014
   ];

  /*applist = [*/
    /*{mimetypes = ["text/plain" "text/css"]; applicationExec = "${pkgs.vim_configurable}/bin/vim";}*/
    /*{mimetypes = ["text/html"]; applicationExec = "${pkgs.firefox}/bin/firefox";}*/
    /*];*/

  /*xdg_default_apps = import /home/matej/workarea/helper_scripts/nixes/defaultapps.nix { inherit pkgs; inherit applist; };*/

#Set of files that have to be linked in /etc.
  etc =
    { hosts =
      { source = "/home/bart/nixosConfig/hosts";
      };
    };

  shells = [
      "/run/current-system/sw/bin/zsh"
      ];

      # extraInit = ''
  # shellInit = ''
  #   if [ -n "$DISPLAY"  ]; then
  #     BROWSER=firefox
  #   else
  #     BROWSER=w3m
  #   fi
  # '';

};
  environment.sessionVariables = {
    # EDITOR = "emacseditor";
    # VISUAL = "emacseditor";
    BROWSER = "firefox";
    LESS = "-X";
    NIXPKGS = "/home/bart/source/nixpkgs/";
    NIXPKGS_ALL = "/home/bart/source/nixpkgs/pkgs/top-level/all-packages.nix";
    GIT_SSL_CAINFO = "/etc/ssl/certs/ca-certificates.crt";
    XDG_DATA_HOME = "/home/bart/.local/share";
    TERMINFO_DIRS = "/run/current-system/sw/share/terminfo";
    NO_AT_BRIDGE = "1"; # for clipster, see: https://github.com/NixOS/nixpkgs/issues/16327#issuecomment-227218371
  };

  # services.xserver.displayManager.sessionCommands = "clipster -d";

  # shellAliases = { ll = "ls -l"; };

    #alias vim="stty stop ''' -ixoff; vim"

  programs.zsh = {
    enable = true;
};

  programs.ssh = {
    startAgent = false; #not needed with gpg-agent
    forwardX11 = true;
    askPassword = "";
  };

      #export LESS=-X so that less doesn't clear the screen after quit
  fonts = {
    enableFontDir = true;
    # enableGhostscriptFonts = true;
    fonts = [
      pkgs.terminus_font
      pkgs.dina-font
    ];
  };

  i18n.consoleFont = "Lat2-Terminus16";

   networking = {
    firewall.enable = false;
  };

    time.timeZone = "Europe/Amsterdam";

    users = {
      defaultUserShell = "${pkgs.zsh}/bin/zsh";
      extraUsers.bart = {
        name = "bart";
        group = "users";
        uid = 1000;
        createHome = false;
        home = "/home/bart";
        extraGroups = [ "wheel" "audio" "video" "usbmux" ];
      shell = "${pkgs.zsh}/bin/zsh";
      };
    mutableUsers = true;
  };

  security.sudo.extraConfig = ''
    bart  ALL=(ALL) NOPASSWD: /run/current-system/sw/bin/iotop
  '';
}
