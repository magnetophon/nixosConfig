
# https://discourse.nixos.org/t/nixos-without-a-display-manager/360/11

{pkgs, config, ...}: with pkgs;
{

  imports = [
    # ./vim.nix
    # ./spacemacs.nix
    ];
  #todo: mixos: https://wiki.archlinux.org/index.php/SSD

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

  hardware = {
    # enableAllFirmware = true;
    enableRedistributableFirmware = true;
    cpu = {
      amd.updateMicrocode = true;
      intel.updateMicrocode = true;
    };
  };
  # for skype
  # hardware.pulseaudio.enable = true;

  boot = {
    loader.systemd-boot = {
      enable = true;
      # consoleMode = "1";
      # memtest86.enable = true; # unfree
    };
    loader.efi.canTouchEfiVariables = true;
    # grub = {
    #  enable = true;
    #  version = 2;
    #  memtest86.enable = true;
    #     };
    cleanTmpDir = true;
    # no beep, no webcam
    blacklistedKernelModules = [ "snd_pcsp" "pcspkr" "uvcvideo" ];
  };

  nix = {
    useSandbox = true;
    sandboxPaths = ["/home/nixchroot"];
    requireSignedBinaryCaches = true;
    buildCores = 0;
    extraOptions = "
      gc-keep-outputs         = true   # Nice for developers
      gc-keep-derivations     = true   # Idem
      env-keep-derivations    = false
      # binary-caches         = https://nixos.org/binary-cache
      # trusted-binary-caches = https://nixos.org/binary-cache https://cache.nixos.org https://hydra.nixos.org
      auto-optimise-store     = true
    ";
  };

  # virtualisation.virtualbox =
  #   {
  #     host.enable = true;
  #     # guest.enable = true;
#   };

  # Copy the system configuration int to nix-store.
  # system.copySystemConfiguration = true;
# https://www.reddit.com/r/NixOS/comments/84ytiu/is_it_possible_to_access_the_current_systems/
  # The command provided creates a symbolic link of the current contents of /etc/nixos (copied into the Nix store) into the current Nix profile being generated. All of the configuration files are accessible at /var/run/current-system/full-config/
  system.extraSystemBuilderCmds = ''
    ln -s ${./.} $out/full-config
    # copy current system to ssd, replace it by a link to the copy
    # cp $out
  '';
    ## error: attribute 'nixos-version' missing
    # mkdir -p $out/full-config
    # cd ${pkgs.nixos-version}/bin/
    # ./nixos-version > $out/full-config/nixos-version

  # fileSystems= {

  #   "/mnt/radio" = {
  #     device = "//stor.adm/tank_radio";
  #     fsType = "cifs";
  #     # this line prevents hanging on network split

  #     options = [ "x-systemd.automount" "nounix" "noperm" "noauto" "x-systemd.idle-timeout=60" "x-systemd.device-timeout=5s" "x-systemd.mount-timeout=5s" ];
  #   };

  #  "/mnt/graphic_public" = {
  #     device = "//stor.adm/tank_graphic_public";
  #     fsType = "cifs";
  #     # this line prevents hanging on network split
  #     options = [ "x-systemd.automount" "nounix" "noperm" "noauto" "x-systemd.idle-timeout=60" "x-systemd.device-timeout=5s" "x-systemd.mount-timeout=5s"];

  #   };
  #  "/mnt/videos" = {
  #     device = "//stor.adm/tank_videos";
  #     fsType = "cifs";
  #     # this line prevents hanging on network split
  #     options = [ "x-systemd.automount" "nounix" "noperm"  "noauto" "x-systemd.idle-timeout=60" "x-systemd.device-timeout=5s" "x-systemd.mount-timeout=5s"];

  #   };
  #  "/mnt/torrent.adm" = {
  #     device = "//stor.adm/tank_torrent.adm";
  #     fsType = "cifs";
  #     # this line prevents hanging on network split
  #     options = [ "x-systemd.automount" "nounix" "noperm"  "noauto" "x-systemd.idle-timeout=60" "x-systemd.device-timeout=5s" "x-systemd.mount-timeout=5s"];

  #   };
  # };

  services = {
    # SMART.
    smartd = {
      enable = true;
      devices = [ { device = "/dev/sda"; } { device = "/dev/sdb"; } ];
      notifications.test = true;
      notifications.x11.enable = true;
    };
    fstrim.enable = true;
    nixosManual.showManual = false;
    printing = {
      enable = true;
      drivers = [ brlaser ];
      # drivers = [ brlaser hplipWithPlugin ]; # unfree
    };
    avahi= {
      enable = true;
      nssmdns = true;
      publish.userServices = true;
    };
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

      # displayManager.slim = {
      #   enable = true;
      #   defaultUser = "bart";
      #   autoLogin = true;
      #   # sessionstart_cmd    ${pkgs.xorg.sessreg}/bin/sessreg -a -l tty7 %user && ${pkgs.physlock}/bin/physlock -ds
      #   extraConfig = ''
      #     sessionstart_cmd    ${pkgs.xorg.sessreg}/bin/sessreg -a -l tty7 %user
      #     sessionstop_cmd     ${pkgs.xorg.sessreg}/bin/sessreg -d -l tty7 %user
      #   '';
      # };

      displayManager.lightdm = {
        enable = true;
        # autoLogin = {
        #   enable = true;
        #   user = "bart";
        # };
        # extraSeatDefaults = ''
        #   [Seat:*]
        #   greeter-setup-script=physlock
        # '';
      };

      #   extraConfig = ''
      #   #   sessionstart_cmd ${pkgs.physlock}/bin/physlock -ds
      #   # '';
      #   # sessionstart_cmd /run/current-system/sw/bin/touch ~/1234

      # displayManager.sddm = {
      #   enable = true;
      #   autoLogin = {
      #     enable = true;
      #     user = "bart";
      #   };
      #   # setupScript =  "{pkgs.physlock}/bin/physlock -ds";
      #   setupScript =  "physlock -ds";
      # };

      # displayManager.setupCommands = ''
      #   physlock -ds
      # '';

      # disable middle mouse buttons
      # to determine id:
      # xinput list | grep 'id='
      # lock screen

      # displayManager.sessionCommands = ''
      #     physlock -ds
      #   '';
      #     xinput set-button-map 10 1 0 3  &&
      #     xinput set-button-map 11 1 0 3  &&

      # physlock -ds

      # ^^ workaround for issue 33168
      # displayManager.sddm = {
      #   enable = true;
      #   autoLogin.enable = true;
      #   autoLogin.user = "bart";
      #   setupScript =  "{pkgs.physlock}/bin/physlock -ds";
      # };
      # Yes, this is a hack.
      # displayManager.setupCommands = "sudo ${pkgs.physlock}/bin/physlock -ds";
      # displayManager.setupCommands = "physlock -ds";

      displayManager.sessionCommands = ''
        (sleep 3; exec ${pkgs.yeshup}/bin/yeshup ${pkgs.go-upower-notify}/bin/upower-notify) &
      '';
      synaptics = import ./synaptics.nix;
      desktopManager.xterm.enable = false;
      # desktopManager.plasma5.enable = true;
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
      allowAnyUser = true;
      lockOn = {
        # suspend = true; # true is default
        # hibernate = true; # true is default
        # systemd[1]: Starting Physlock...
        # physlock-start[774]: physlock: Unable to detect user of tty1
        # extraTargets = ["graphical.target"];
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
    # dbus.socketActivated = true;
    # gnome3.gvfs.enable = true;
    usbmuxd.enable = true;

    dnsmasq = {
      enable = true;
      extraConfig = ''
        # cache-size=100000
        addn-hosts=/var/lib/hostsblock/hosts.block
     '';
    };
    upower.enable = true;
  };

  nixpkgs.config = {
    # allowUnfree = true;
    allowUnfree = false;
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

    # m32edit

    # for battery shutdown event:
    acpid
    acpi
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
    bat
    lf
    nnn
    ncdu # disk usage analyzer
    # dua # disk usage analyzer, doesn't understand symbolic links
    ts
    xdotool # for auto-type
    xorg.sessreg
    heimdall # for installing android etc
    coreutils
    ntfs3g
    cryptsetup
    openjdk
    stow
    tmux
    tealdeer
    mosh
    sshfsFuse
    rxvt_unicode
    termite
    termite.terminfo
    alacritty
    # e19.terminology
    zsh
    nix-zsh-completions
    nix-diff
    nix-serve
    nixops
    nix-du
    fish
    haskellPackages.ShellCheck
    fasd
    fzf
    blsd
    skim
    bfs
    broot
    hyperfine
    openssl
    physlock
    # i3lock
    asciinema
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
    gitAndTools.delta
    gitAndTools.grv
    gitAndTools.tig
    mercurial
    subversion
    curl
    nextcloud-client
    inetutils
    hostsblock
    # haskellPackages.ghc
    ruby
    # icedtea_web
    nixfmt
    nix-review
    font-manager
    xfontsel
    neovim
    (vim_configurable.customize {
      name = "vim";

      vimrcConfig.customRC = ''
        "use the light solarized theme:
        "colorscheme solarized
        let g:solarized_termcolors=256
        color solarized             " Load a colorscheme
        set background=light
        set number relativenumber
      '';
      vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
      vimrcConfig.vam.pluginDictionaries = [
        { names = [
            # "airline"
            "colors-solarized"
            # "ctrlp"
            # "fugitive"
            "nerdcommenter"
            # "nerdtree"
            # "rainbow_parentheses"
            # "Tabular"
            "undotree"
            "vim-addon-nix"
            "vim-sensible"
            "vim-sleuth"
            # "youcompleteme"
          ]; }
      ];
    })
    /*vim_configurable*/
    # vimHugeX
    #my_vim
    # emacs
    # (emacs.override { imagemagick = pkgs.imagemagickBig; } )
    # for emacs markdown-preview:
    # marked # node package
    pandoc
    haskellPackages.markdown
    mu
    # imagemagick
    dunst
    libnotify
    go-upower-notify
    # ctagsWrapped.ctagsWrapped
    which
    gnuplot
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
    i3status-rust
    wmfocus
    lm_sensors # for i3status-rust
    dmenu
    clipster
    rofi
    networkmanager_dmenu
    conky
    dzen2
    # xpra
#desktop
    #desktop-file-utils
    # firefox-esr
    # (firefox-esr.override { nameSuffix="-esr"; })
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
    sqlitebrowser
    python37Packages.pyperclip # for qutebrowser, https://github.com/LaurenceWarne/qute-code-hint
    chromium
    # chromiumBeta
    /*w3m*/
    (pkgs.w3m.override { graphicsSupport = true; })
    youtubeDL
    vlc
    # (mumble.override { jackSupport = true;})
    (mpv.override { jackaudioSupport = true; archiveSupport = true; vapoursynthSupport = true; })
    python36Packages.mps-youtube
    shotwell
    galculator
    transmission-gtk
    xrandr-invert-colors
    arandr
    xcalib
    sselp
    xclip
    pqiv
    feh
    gopass
    pass
    rofi-pass
    silver-searcher
    ripgrep
    fd  # rust fast find alternative
    exa # rust ls alternative
    trash-cli
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
    # mutt-with-sidebar
    # mutt-kz
    neomutt
    xfce.thunar
    alot
    thunderbird
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
    alsaUtils
    # kiwix
    meld
    freemind
    baobab
    recoll
    # https://github.com/NixOS/nixpkgs/issues/50001 :
    zathura
    # kodi
    (pkgs.pidgin-with-plugins.override { plugins = [ pidginotr ]; }) # pidgin + pidgin-otr
    # pidgin
    # weechat
    irssi
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
    # libreoffice-fresh
    libreoffice
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
        pkgs.zsh
      ];
# Set of files that have to be linked in /etc.
  # etc =
  #   { hosts =
  #       # hostsblock -f /home/bart/.config/hostsblock/hostsblock.conf -u
  #       { source = /home/bart/nixosConfig/hosts;
  #       };
  #   };

  variables.NIX_AUTO_RUN="!";

  # Speaking of i3, if you enable both services.xserver.desktopManager.plasma5.enable = true; and services.xserver.windowManager.i3.enable = true; (for example), you get a neat extra: a combo option to run plasma with i3 as a window manager. Additionally, you can set services.xserver.desktopManager.default = "plasma5"; AND services.xserver.windowManager.default = "i3"; to get that variant by default.

  # <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
  # <nixpkgs/nixos/modules/profiles/headless.nix>
  # <nixpkgs/nixos/modules/profiles/hardened.nix>

  # extraInit = ''
  # shellInit = ''
  #   if [ -n "$DISPLAY"  ]; then
  #     BROWSER=firefox
  #   else
  #     BROWSER=w3m
  #   fi
  # '';

};

  sound.enable = true;

  environment.sessionVariables = {
    BROWSER = "qutebrowser";
    PAGER = "less";
    LESS = "-isMR";
    NIX_PAGER = "cat";
    TERMCMD = "termite";
    NIXPKGS = "/home/bart/source/nixpkgs/";
    NIXPKGS_ALL = "/home/bart/source/nixpkgs/pkgs/top-level/all-packages.nix";
    GIT_SSL_CAINFO = "/etc/ssl/certs/ca-certificates.crt";
    XDG_DATA_HOME = "/home/bart/.local/share";
    TERMINFO_DIRS = "/run/current-system/sw/share/terminfo";
    RANGER_LOAD_DEFAULT_RC = "FALSE";
    FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git";
    FZF_DEFAULT_OPTS = ''
          \
          --exact \
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
          --preview='~/.local/bin/preview.sh {}' \
          --header 'alt-z:toggle-preview alt-w:toggle-preview-wrap alt-s:toggle-sort alt-a:toggle-all ctrl-a:select-all alt-y:yank path'
      '';
    _FZF_ZSH_PREVIEW_STRING =
    "echo {} | sed 's/ *[0-9]* *//' | highlight --syntax=zsh --out-format=ansi";

    FZF_CTRL_R_OPTS =
    "--preview $_FZF_ZSH_PREVIEW_STRING --preview-window down:10:wrap";

    FZF_ALT_C_COMMAND="bfs -color -type d";
    FZF_ALT_C_OPTS="--preview 'tree -L 4 -d -C --noreport -C {} | head -200'";
    # set locales for everything but LANG
    # TODO: nix specific: https://www.reddit.com/r/NixOS/comments/dck6o1/how_to_change_locale_settings/
    # See i18n.extraLocaleSettings. You can search for "locale" in man configuration.nix.
    # exceptions & info https://unix.stackexchange.com/questions/149111/what-should-i-set-my-locale-to-and-what-are-the-implications-of-doing-so
    # LANGUAGE = "en_US.UTF-8";
    # LC_ALL = "en_US.UTF-8";
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
          ExecStart = "${pkgs.udiskie}/bin/udiskie -2 -s";
          Restart="always";
        };

        wantedBy = [ "graphical-session.target" ];
  };

  systemd.user.services.clipster = {
    unitConfig = {
      Description = "clipster clipboard manager daemon";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
      pidfile = "/var/run/clipster/pid";
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
        alias  sw='nixos-rebuild boot -p rt -I nixos-config=/home/bart/nixosConfig/machines/$(hostname | cut -d"-" -f1)/rt.nix                     && nixos-rebuild switch'
        alias swn='nixos-rebuild switch -p rt -I nixos-config=/home/bart/nixosConfig/machines/$(hostname | cut -d"-" -f1)/rt.nix -I nixpkgs=$NIXPKGS && nixos-rebuild switch -I nixpkgs=$NIXPKGS'
      '';
    };

    command-not-found.enable = true;

    ssh = {
      startAgent = true;
      forwardX11 = true;
      askPassword = "";
    };

    gnupg.agent.enable = true;

    light.enable = true;
    # gtk search:
    plotinus.enable = true;
    # Android Debug Bridge
    adb.enable = true;

};
# Define fonts
fonts = {
  enableFontDir = true;
  fontconfig = {
    # penultimate.enable = true;
    useEmbeddedBitmaps = true; # pango doesn't support mixing bitmap fonts with ttf anymore, so we if we want terminus plus icons we need terminus_font_ttf for i3bar, which displays wonky without this
  };
  fonts = with pkgs; [
    terminus_font
    terminus_font_ttf
    nerdfonts
    emacs-all-the-icons-fonts
    google-fonts
  ];
};

console = {
  font = "Lat2-Terminus16";
  useXkbConfig = true;
};
i18n = {
  defaultLocale = "en_US.UTF-8";
};

   networking = {
     # firewall.enable = false;
     resolvconf.dnsExtensionMechanism = false; # workaround to fix “WiFi in de Trein”
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
        extraGroups = [ "wheel" "audio" "video" "usbmux" "networkmanager" "adbusers" ];
        shell = pkgs.zsh;
      };
    mutableUsers = true;
  };

  # tlp still asks for a password
  security.sudo.extraConfig = ''
    bart  ALL=(ALL) NOPASSWD: ${pkgs.iotop}/bin/iotop
    bart  ALL=(ALL) NOPASSWD: ${pkgs.tlp}/bin/tlp
  '';
  # bart  ALL=(ALL) NOPASSWD: ${pkgs.physlock}/bin/physlock

  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"   ; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio" ; type = "-"   ; value = "99"       ; }
    { domain = "@audio"; item = "nofile" ; type = "soft"; value = "99999"    ; }
    { domain = "@audio"; item = "nofile" ; type = "hard"; value = "99999"    ; }
  ];

}
