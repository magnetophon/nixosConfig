{pkgs, config, ...}: with pkgs;
{

  imports = [
    ./vim.nix
    # ./spacemacs.nix
    ];
  #todo: mixos: https://wiki.archlinux.org/index.php/SSD

  hardware.cpu.intel.updateMicrocode = true;
  # for skype
  # hardware.pulseaudio.enable = true;

  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      memtest86.enable = true;
    };
    cleanTmpDir = true;
    # no beep, no webcam
    blacklistedKernelModules = [ "snd_pcsp" "pcspkr" "uvcvideo" ];
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
    fstrim.enable = true;
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
      displayManager.slim = {
        enable = true;
        defaultUser = "bart";
        autoLogin = true;
        extraConfig = ''
          sessionstart_cmd    ${pkgs.physlock}/bin/physlock -ds
        '';
      };
      # ^^ workaround for issue 33168
      # displayManager.lightdm = {
        # enable = true;
        # autoLogin.enable = true;
        # autoLogin.user = "bart";
        # };
      synaptics = import ./synaptics.nix;
      desktopManager.xterm.enable = false;
      xkbOptions = "caps:swapescape";
    /*bitlbee.enable*/
    /*Whether to run the BitlBee IRC to other chat network gateway. Running it allows you to access the MSN, Jabber, Yahoo! and ICQ chat networks via an IRC client. */

    };
    unclutter-xfixes.enable = true;
    unclutter-xfixes.extraOptions = [ "ignore-scrolling" ];
    # autofs =
    # {
      # enable = true;
      # autoMaster =
    # };
    emacs = {
      enable = true;
      defaultEditor = true;
      package = (emacs.override { imagemagick = pkgs.imagemagickBig; } );
      };
    physlock = {
      enable = true;
      lockOn = {
        suspend = true;
        hibernate = true;
        # systemd[1]: Starting Physlock...
        # physlock-start[774]: physlock: Unable to detect user of tty1
        # extraTargets = ["display-manager.service"];
      };
    };
    logind.extraConfig =
    ''
      HandleSuspendKey=hibernate
    '';
    # doesn't do anything
      # HandlePowerKey=hibernate

    # By default, udisks2 mounts removable drives under the ACL controlled directory /run/media/$USER/. If you wish to mount to /media instead, use this rule:
    udev.extraRules = ''
        # UDISKS_FILESYSTEM_SHARED
        # ==1: mount filesystem to a shared directory (/media/VolumeName)
        # ==0: mount filesystem to a private directory (/run/media/$USER/VolumeName)
        # See udisks(8)
        ENV{ID_FS_USAGE}=="filesystem|other|crypto", ENV{UDISKS_FILESYSTEM_SHARED}="1"
    '';
    dbus.socketActivated = true;
  };

  nixpkgs.config = {
    # allowUnfree = true;
    #firefox.enableAdobeFlash = true;
    # firefox.enableMplayer = true;
    # packageOverrides = pkgs : rec {
    # };
    # pulseaudio = false;


    packageOverrides = pkgs: {
    };
  };


environment= {
    systemPackages = [

    # for battery shutdown event:
    acpid
    geany
#system:
    unzip
    zip
    p7zip
    dtrx
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
    rxvt_unicode
    termite
    # e19.terminology
    zsh
    nix-zsh-completions
    fish
    haskellPackages.ShellCheck
    fasd
    fzf
    blsd
    openssl
    physlock
    # i3lock
    asciinema
    bench
    neofetch
    rtv
    tree
    htop
    iotop
    powertop
    sysstat
    iptraf
    nethogs
    iftop
    hdparm
    testdisk
    udiskie
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
    gitAndTools.diff-so-fancy
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
    # emacs
    # (emacs.override { imagemagick = pkgs.imagemagickBig; } )
    mu
    # imagemagick
    dunst
    libnotify
    # ctagsWrapped.ctagsWrapped
    which
    gnuplot
    nix-repl
    nixpkgs-lint
    nix-prefetch-scripts
    nix-index
    nox
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
    firefox-esr
  #for vimeo:
      gstreamer
      gst_plugins_base
      gst_plugins_good
      gst_plugins_bad
      gst_plugins_ugly
    torbrowser
    i2pd
    qutebrowser
    chromium
    #chromiumBeta
    /*w3m*/
    (pkgs.w3m.override { graphicsSupport = true; })
    youtubeDL
    vlc
    # (pkgs.vlc.override { jackSupport = true;})
    (mpv.override { vaapiSupport = true; jackaudioSupport = true; rubberbandSupport = true; })
    shotwell
    galculator
    xrandr-invert-colors
    arandr
    xcalib
    sselp
    xclip
    pqiv
    silver-searcher
    ripgrep
    fd  # rust fast find alternative
    exa # rust ls alternative
    ranger
      # for ranger previews:
      atool
      highlight
      file
      libcaca
      odt2txt
      perlPackages.ImageExifTool
      ffmpegthumbnailer
      poppler_utils # for pdftotext
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
    handbrake
    kiwix
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

  shells = [
      # "/run/current-system/sw/bin/zsh"
        pkgs.zsh
      ];
#Set of files that have to be linked in /etc.
  etc =
    { hosts =
    # https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/gambling-social/hosts
    # replace $0 by 0
      { source = "/home/bart/nixosConfig/hosts";
      };
    };


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
    BROWSER = "firefox";
    PAGER = "less";
    LESS = "-isMR";
    NIX_PAGER = "cat";
    TERMCMD = "termite";
    NIXPKGS = "/home/bart/source/nixpkgs/";
    NIXPKGS_ALL = "/home/bart/source/nixpkgs/pkgs/top-level/all-packages.nix";
    GIT_SSL_CAINFO = "/etc/ssl/certs/ca-certificates.crt";
    XDG_DATA_HOME = "/home/bart/.local/share";
    TERMINFO_DIRS = "/run/current-system/sw/share/terminfo";
    # NO_AT_BRIDGE = "1"; # for clipster, see: https://github.com/NixOS/nixpkgs/issues/16327#issuecomment-227218371
    RANGER_LOAD_DEFAULT_RC = "FALSE";
    FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git";
    FZF_DEFAULT_OPTS=''\
    --exact
    --reverse \
    --cycle \
    --multi \
    --select-1 \
    --exit-0 \
    --no-height \
    --ansi \
    --bind=alt-z:toggle-preview \
    --bind=alt-w:toggle-preview-wrap \
    --bind=alt-s:toggle-sort \
    --bind=alt-a:toggle-all \
    --bind=ctrl-a:select-all \
    --bind 'alt-y:execute:realpath {} | xclip' \
    --preview='~/.local/bin/preview.sh {}'
    '';
    _FZF_ZSH_PREVIEW_STRING="echo {} | sed 's/ *[0-9]* *//' | highlight --syntax=zsh --out-format=ansi";

    FZF_CTRL_R_OPTS="--preview $_FZF_ZSH_PREVIEW_STRING --preview-window down:10:wrap";

    FZF_ALT_C_COMMAND="blsd";
    FZF_ALT_C_OPTS="--preview 'tree -L 4 -d -C --noreport -C {} | head -200'";
    # set locales for everything but LANG
    # exceptions & info https://unix.stackexchange.com/questions/149111/what-should-i-set-my-locale-to-and-what-are-the-implications-of-doing-so
    # LC_CTYPE="nl_NL.UTF-8";
    # LC_NUMERIC="nl_NL.UTF-8";
    LC_TIME="nl_NL.UTF-8";
    # LC_COLLATE="nl_NL.UTF-8";
    LC_MONETARY="nl_NL.UTF-8";
    # LC_MESSAGES="nl_NL.UTF-8";
    LC_PAPER="nl_NL.UTF-8";
    LC_NAME="nl_NL.UTF-8";
    LC_ADDRESS="nl_NL.UTF-8";
    LC_TELEPHONE="nl_NL.UTF-8";
    LC_MEASUREMENT="nl_NL.UTF-8";
    LC_IDENTIFICATION="nl_NL.UTF-8";
  };


  # shellAliases = { ll = "ls -l"; };

    #alias vim="stty stop ''' -ixoff; vim"
  systemd.user.services.udiskie = {
        unitConfig = {
          Description = "udiskie mount daemon";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
        };

        serviceConfig = {
          ExecStart = "${pkgs.pythonPackages.udiskie}/bin/udiskie -2 -s";
          Restart="always";
        };

        wantedBy = [ "graphical-session.target" ];
  };

   systemd.user.services.clipster = {
        unitConfig = {
          Description = "clipster clipboard manager daemon";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        serviceConfig = {
          ExecStart = "${pkgs.clipster}/bin/clipster -d";
          Restart="always";
        };
        wantedBy = [ "graphical-session.target" ];
  };

   systemd.user.services.dunst = {
        unitConfig = {
          Description = "dunst notification daemon";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        serviceConfig = {
          ExecStart = "${pkgs.dunst}/bin/dunst";
          Restart="always";
        };
        wantedBy = [ "graphical-session.target" ];
  };


   # systemd.user.services.backlightSave = {
        # unitConfig = {
          # Description = "save the backlight on sleep or shutdown";
          # Before = [ "poweroff.target" "halt.target" "reboot.target" "sleep.target" ];
          # PartOf = [ "poweroff.target" "halt.target" "reboot.target" "sleep.target" ];
        # };
        # serviceConfig = {
          # ExecStartPre = "${pkgs.light}/bin/light -O";
        # };
        # wantedBy = [ "poweroff.target" "halt.target" "reboot.target" "sleep.target" ];
  # };


   # systemd.user.services.backlightRestore = {
        # unitConfig = {
          # Description = "restore the backlight on startup or wakeup";
          # After = [ "sysinit.target" "sleep.target"  ];
          # PartOf = [ "sysinit.target" "sleep.target" ];
        # };
        # serviceConfig = {
          # ExecStartPost = "${pkgs.light}/bin/light -I";
          # ExecStopPost= "${pkgs.light}/bin/light -I";
        # };
        # wantedBy = [ "sysinit.target" "sleep.target" ];
  # };

powerManagement.powerDownCommands = "${pkgs.light}/bin/light -O";
powerManagement.powerUpCommands   = "${pkgs.light}/bin/light -I";

programs = {
  # zsh has an annoying default config which I don't want
  # so to make it work well I have to turn it off first.
    zsh = {
      enable = true;
      shellInit = "";
      shellAliases = {};
      promptInit = "";
      loginShellInit = "";
      interactiveShellInit = ''
        alias  up='nixos-rebuild test --upgrade '
        function upn {
          cd $NIXPKGS &&
          if [[ $(git status --porcelain ) == "" ]];
          then
            echo "checking out commit " $(nixos-version --hash) " under branch name " $(nixos-version | cut -d" " -f1)
            git fetch upstream && git checkout $(nixos-version --hash) -b $(nixos-version | cut -d" " -f1)
          else
            git status
          fi
          }
        alias gcn='cd $NIXPKGS && git checkout $(nixos-version | cut -d" " -f1)'
        alias  te='nixos-rebuild test   -p rt -I nixos-config=/home/bart/nixosConfig/machines/$(hostname | cut -d"-" -f1)/rt.nix                     && nixos-rebuild test'
        alias ten='nixos-rebuild test   -p rt -I nixos-config=/home/bart/nixosConfig/machines/$(hostname | cut -d"-" -f1)/rt.nix -I nixpkgs=$NIXPKGS && nixos-rebuild test   -I nixpkgs=$NIXPKGS'
        alias  sw='nixos-rebuild switch -p rt -I nixos-config=/home/bart/nixosConfig/machines/$(hostname | cut -d"-" -f1)/rt.nix                     && nixos-rebuild switch'
        alias swn='nixos-rebuild switch -p rt -I nixos-config=/home/bart/nixosConfig/machines/$(hostname | cut -d"-" -f1)/rt.nix -I nixpkgs=$NIXPKGS && nixos-rebuild switch -I nixpkgs=$NIXPKGS'
      '';
      enableCompletion = false;
    };

    command-not-found.enable = true;

    ssh = {
      startAgent = true;
      forwardX11 = true;
      askPassword = "";
    };

    light.enable = true;

  };

  fonts = {
    fonts = [
      pkgs.terminus_font
      pkgs.dina-font
      pkgs.nerdfonts
    ];
    fontconfig.ultimate = {
      enable = true;
    };
  };

  i18n = {
     consoleFont = "Lat2-Terminus16";
     consoleUseXkbConfig = true;
     defaultLocale = "en_US.UTF-8";
  };

   networking = {
    firewall.enable = false;
  };

    time.timeZone = "Europe/Amsterdam";

    users = {
      defaultUserShell = pkgs.zsh;
      extraUsers.bart = {
        name = "bart";
        group = "users";
        uid = 1000;
        createHome = false;
        home = "/home/bart";
        extraGroups = [ "wheel" "audio" "video" "usbmux" "networkmanager" ];
      shell = pkgs.zsh;
      };
    mutableUsers = true;
  };

  security.sudo.extraConfig = ''
    bart  ALL=(ALL) NOPASSWD: ${pkgs.iotop}/bin/iotop
    bart  ALL=(ALL) NOPASSWD: ${pkgs.physlock}/bin/physlock
  '';
}
