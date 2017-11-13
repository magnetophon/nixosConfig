{pkgs, config, ...}: with pkgs;
{

  imports = [
    ./vim.nix
    # ./spacemacs.nix
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
    kernelPackages = pkgs.linuxPackages_latest;
    cleanTmpDir = true;
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
      # binary-caches = https://nixos.org/binary-cache
      # trusted-binary-caches = https://nixos.org/binary-cache https://cache.nixos.org https://hydra.nixos.org
      auto-optimise-store = false
    ";
  };

  # virtualisation.virtualbox =
  #   {
  #     host.enable = true;
  #     # guest.enable = true;
  #   };

  # Copy the system configuration int to nix-store.
  # system.copySystemConfiguration = true;

  services = {

    # SMART.
    smartd = {
      enable = true;
      devices = [ { device = "/dev/sda"; } ];
      notifications.test = true;
      notifications.x11.enable = true;
    };
    nixosManual.showManual = false;
    printing.enable = true;
    # acpid.enable = true;
    cron.enable =false;
    #avahi.enable = true;
    #locate.enable = true;
    # journald.extraConfig = ''
    #   [Journal]
    #   SystemMaxUse=50M
    #   SystemMaxFileSize=10M
    # '';
    openssh = {
      enable = true;
      ports = [ 22 ];
      forwardX11 = true;
      permitRootLogin = "without-password";
      # permitRootLogin = "yes";
      };
    xserver = {
      enable = true;
      enableCtrlAltBackspace = true;
      displayManager.lightdm.enable = true;
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
    unclutter-xfixes.enable = true;
    unclutter-xfixes.extraOptions = [ "ignore-scrolling" ];
    emacs = {
      enable = true;
      defaultEditor = true;
      };
    physlock = {
      enable = true;
      lockOn = {
        suspend = true;
        hibernate = true;
      };
    };
    # mpd = {
    #   enable = true;
    #   musicDirectory = "/home/bart/Music";
    #   user = "bart";
    # };
    logind.extraConfig =
    ''
      HandleSuspendKey=hibernate
    '';
  };

  nixpkgs.config = {
    # allowUnfree = true;
    #firefox.enableAdobeFlash = true;
    # firefox.enableMplayer = true;
    # packageOverrides = pkgs : rec {
    # };
    # pulseaudio = false;
  };





environment= {
    systemPackages = [

    # for battery shutdown event:
    acpid
    geany
    mpd
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
    linuxPackages.cpupower
    lsof
    psmisc
    gitFull
    gitAndTools.hub # GitHub extension to git
    gitAndTools.gitAnnex
    mercurial
    subversion
    curl
    inetutils
    # haskellPackages.ghc
    ruby
    # icedtea_web
    /*vim_configurable*/
    /*vimHugeX*/
    #my_vim
    emacs
    # ctagsWrapped.ctagsWrapped
    which
    gnuplot
    nix-repl
    nixpkgs-lint
    nix-prefetch-scripts
    nox
    # xlaunch
    xlibs.xkill
    xlibs.xinit
    ltrace
    # obnam # backup
    # borgbackup
    storeBackup
    # syncthing
    # python27Packages.syncthing-gtk
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
    networkmanager_dmenu
    conky
    dzen2
    # xpra
    # winswitch
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
    # qutebrowser
    #chromium
    #chromiumBeta
    /*w3m*/
    (pkgs.w3m.override { graphicsSupport = true; })
    youtubeDL
    vlc
    # (pkgs.vlc.override { jackSupport = true;})
    (mpv.override { vaapiSupport = true; jackaudioSupport = true; rubberbandSupport = true; })
    galculator
    xrandr-invert-colors
    arandr
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
      odt2txt
      perlPackages.ImageExifTool
      ffmpegthumbnailer
      poppler_utils
      transmission
      lynx
      mediainfo
    #mutt-with-sidebar
    # mutt-kz
    alot
    neomutt
    isync
    # taskwarrior
    paperkey
    gpa
    urlview
    # offlineimap replaced by isync
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
    blender
    kdenlive
    ffmpeg-full
    simplescreenrecorder
    scrot
    # handbrake
    evopedia
    meld
    freemind
    baobab
    recoll
    zathura
    # kodi
    # (pkgs.pidgin-with-plugins.override { plugins = [ pidginotr ]; }) # pidgin + pidgin-otr
    pidgin
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
    aspell
    aspellDicts.en
    aspellDicts.nl
    aspellDicts.de
    libreoffice-fresh
    k3b
# iDevice stuff:
# /pkgs/development/libraries/libplist/default.nix
# has knownVulnerabilities
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
    # https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/gambling-social/hosts
    # replace $0 by 0
      { source = "/home/bart/nixosConfig/hosts";
      };
    };

  shells = [
      # "/run/current-system/sw/bin/zsh"
        pkgs.zsh
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
    RANGER_LOAD_DEFAULT_RC = "FALSE";
  };

  # services.xserver.displayManager.sessionCommands = "clipster -d";

  # shellAliases = { ll = "ls -l"; };

    #alias vim="stty stop ''' -ixoff; vim"

  programs = {

    zsh.enable = true;
    command-not-found.enable = true;

    ssh = {
      startAgent = false; #not needed with gpg-agent
      forwardX11 = true;
      askPassword = "";
    };

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
        extraGroups = [ "wheel" "audio" "video" "usbmux" "networkmanager" ];
      shell = "${pkgs.zsh}/bin/zsh";
      };
    mutableUsers = true;
  };

  security.sudo.extraConfig = ''
    bart  ALL=(ALL) NOPASSWD: ${pkgs.iotop}/bin/iotop
    bart  ALL=(ALL) NOPASSWD: ${pkgs.physlock}/bin/physlock
  '';
}
