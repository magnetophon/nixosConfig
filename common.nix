# https://discourse.nixos.org/t/nixos-without-a-display-manager/360/11

{ pkgs, config, ... }:
with pkgs;
let
  my-python-packages = python-packages:
    with python-packages; [
      # pandas
      # requests
      pyperclip
      ueberzug
      # other python packages you want
    ];
  python-with-my-packages = python3.withPackages my-python-packages;
in {

  imports = [
    # ./vim.nix
  ];
  #todo: mixos: https://wiki.archlinux.org/index.php/SSD

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

  hardware = {
    enableAllFirmware = true;
    # enableRedistributableFirmware = true;
    cpu = {
      amd.updateMicrocode = true;
      intel.updateMicrocode = true;
    };
    bluetooth.enable = true;
  };
  # for skype
  # hardware.pulseaudio = {
  # enable = true;
  # package = pkgs.pulseaudio.override { jackaudioSupport = true; };
  # };

  # rtkit is optional but recommended
  security.rtkit.enable = true;

  # done in jack module:
  # systemd.user.services.pulseaudio.environment = {
  # JACK_PROMISCUOUS_SERVER = "jackaudio";
  # };

  boot = {
    loader.systemd-boot = {
      enable = true;
      # consoleMode = "max";
      # memtest86.enable = true; # unfree
    };
    loader.efi.canTouchEfiVariables = true;
    cleanTmpDir = true;
    # no beep, no webcam
    blacklistedKernelModules = [ "snd_pcsp" "pcspkr" "uvcvideo" ];
    kernel.sysctl = { "net.ipv4.ip_forward" = 1; }; # for network in VM
    kernelModules = [ "kvm-intel" "kvm-amd" "tun" "virtio" ];
  };

  nix = {
    # distributedBuilds = true;
    # buildMachines = [
    # { hostName = "nxb-4";
    # system = "x86_64-linux";
    # maxJobs = 100;
    # supportedFeatures = [ "benchmark" ];
    # }
    # { hostName = "nxb-16";
    # system = "x86_64-linux";
    # maxJobs = 100;
    # supportedFeatures = [ "benchmark" ];
    # mandatoryFeatures = [ "big-parallel" ];
    # }
    # ];

    settings = {
      sandbox = true;
      extra-sandbox-paths = [ "/home/nixchroot" ];
      require-sigs = true;
    };
    # useSandbox = true;
    # sandboxPaths = [ "/home/nixchroot" ];
    # requireSignedBinaryCaches = true;

    extraOptions = lib.optionalString (config.nix.package == nixVersions.stable) ''
      gc-keep-outputs         = true   # Nice for developers
      gc-keep-derivations     = true   # Idem
      env-keep-derivations    = false
      # binary-caches         = https://nixos.org/binary-cache
      # trusted-binary-caches = https://nixos.org/binary-cache https://cache.nixos.org https://hydra.nixos.org
      auto-optimise-store     = true
      experimental-features = nix-command flakes
    '';
    package = nixVersions.stable;
  };

  # Copy the system configuration int to nix-store.
  # system.copySystemConfiguration = true;
  # https://www.reddit.com/r/NixOS/comments/84ytiu/is_it_possible_to_access_the_current_systems/
  # The command provided creates a symbolic link of the current contents of /etc/nixos (copied into the Nix store) into the current Nix profile being generated. All of the configuration files are accessible at /var/run/current-system/full-config/
  #
  # todo; more elaborate version: https://git.ophanim.de/derped/nixos/src/branch/master/options/copySysConf.nix
  system.extraSystemBuilderCmds = ''
    ln -s ${./.} $out/full-config
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
    fstrim.enable = true;

    fwupd.enable = true;

    # nixosManual.showManual = false;
    printing = {
      enable = true;
      drivers = [ brlaser ];
      # drivers = [ brlaser hplipWithPlugin ]; # unfree
    };
    # avahi = {
    # enable = true;
    # nssmdns = true;
    # publish.userServices = true;
    # };
    acpid.enable = true;
    cron.enable = false;
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
      passwordAuthentication = false;
      startWhenNeeded = true;

    };

    # mingetty.autologinUser = "bart";

    xserver = {
      enable = true;
      enableCtrlAltBackspace = true;

      displayManager = {
        # startx.enable = true;
        lightdm = {
          enable = true;
          # greeter.enable = false;
          # autoLogin = {
          # enable = true;
          # user = "bart";
        };
        # extraSeatDefaults = ''
        #   [Seat:*]
        #   greeter-setup-script=physlock
        # '';
        # };
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
      # displayManager.setupCommands = "${pkgs.physlock}/bin/physlock -ds";
      # displayManager.setupCommands = "physlock -ds";

      displayManager.sessionCommands = ''
        (sleep 3; exec ${pkgs.yeshup}/bin/yeshup ${pkgs.go-upower-notify}/bin/upower-notify) &
      '';
      # sudo -u bart ${pkgs.physlock}/bin/physlock -ds
      # synaptics = import ./synaptics.nix;
      libinput = {
        enable = true;
        touchpad = {
          middleEmulation = false;
          accelSpeed = "0.1";
        };
      };
      config = ''
        Section "InputClass"
          Identifier     "Enable libinput for TrackPoint"
          MatchIsPointer "on"
          Driver         "libinput"
        EndSection
      '';
      desktopManager.xterm.enable = false;
      # desktopManager.plasma5.enable = true;
      xkbOptions = "caps:swapescape";
      xkbVariant = "altgr-intl";
      # bitlbee.enable
      # Whether to run the BitlBee IRC to other chat network gateway. Running it allows you to access the MSN, Jabber, Yahoo! and ICQ chat networks via an IRC client.

    };

    unclutter-xfixes = {
      enable = true;
      threshold = 2;
      extraOptions = [ "ignore-scrolling" ];
    };
    # autofs =
    # {
    # enable = true;
    # autoMaster =
    # };
    emacs = {
      enable = true;
      defaultEditor = true;
      # package = (emacs.override { imagemagick = pkgs.imagemagickBig; });
      # package =
      # ((emacsPackagesFor emacs26).emacsWithPackages (epkgs: [  # emacs 27 is default, but breaks faust for now
      # epkgs.vterm
      # ]));
      # ((emacsPackagesFor ((emacs.override { imagemagick = nixpkgs.imagemagickBig; srcRepo = true; }).overrideAttrs )).emacsWithPackages (epkgs: [
      # epkgs.emacs-libvterm
      # ]));

      # package = pkgs.emacs.override {
      # nativeComp = true;
      # };
      package = ((emacsPackagesFor emacsNativeComp).emacsWithPackages
        (epkgs: [ epkgs.vterm ]));
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
    logind.lidSwitch = "suspend-then-hibernate";
    # logind.lidSwitch = "hibernate";
    # logind.extraConfig = ''
    # HandleSuspendKey=hibernate
    # '';
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
    # gvfs.enable = true; # for url handling of pqiv, see https://github.com/phillipberndt/pqiv/issues/114   doesn't work yet on nixos
    # gvfs.package = pkgs.gnome3.gvfs;
    # plug-n-play tethering for iPhones:
    # disabled because of https://github.com/NixOS/nixpkgs/issues/77189
    # usbmuxd.enable = true;

    dnsmasq = {
      enable = true;
      extraConfig = ''
        cache-size=100000
        addn-hosts=/var/lib/hostsblock/hosts.block
      '';
    };
    upower = {
      enable = true;
      # noPollBatteries = true;
      # percentageLow = 15;
      # percentageCritical = 10;
      # percentageAction = 5;
    };
    # bluetooth gui:
    blueman.enable = true;
  };

  # documentation.nixos.includeAllModules = true;

  nixpkgs.config = {
    allowUnfree = true;
    # allowUnfree = false;
    #firefox.enableAdobeFlash = true;
    # firefox.enableMplayer = true;
    # packageOverrides = pkgs : rec {
    # };
    # pulseaudio = false;

    packageOverrides = pkgs: { };
  };

  environment = {
    systemPackages = [

      # m32edit

      # for battery shutdown event:
      acpid
      acpi
      geany
      #system:
      unzip
      zip
      p7zip # insecure: https://github.com/NixOS/nixpkgs/commit/aa80b4780d849a00d86c28d6b3c78a777dd02e9a
      unar
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
      gdu
      lfs
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
      tealdeer # tldr
      navi # An interactive cheatsheet tool for the command-line
      languagetool
      mosh
      sshfs-fuse
      gnutls # for doom emacs irc
      nodejs # for doom lsp mode
      rust-analyzer # for doom rust
      rustup # for doom rust
      rxvt-unicode-unwrapped
      # termite          # https://github.com/thestinger/termite/issues/760
      # termite.terminfo # https://github.com/thestinger/termite/issues/760
      alacritty
      # kitty
      picom # compton fork
      # e19.terminology
      zsh
      nixos-option
      nix-zsh-completions
      nix-diff # marked as broken, refusing to evaluate
      nixfmt # marked as broken, refusing to evaluate
      nix-serve
      # nixops
      nix-du
      nix-tree
      nixpkgs-review
      nixpkgs-lint
      nix-prefetch-scripts
      nix-prefetch-git
      nix-index
      nixpkgs-review
      rnix-lsp
      manix
      nox
      fish
      haskellPackages.ShellCheck
      fasd
      zoxide
      fzf
      skim
      bfs
      broot
      hyperfine # benchmarker
      stress # cpu stress
      grex # create regex from example
      rdfind
      openssl
      physlock
      asciinema
      neofetch
      # rtv
      tuir
      tree
      htop
      bottom
      s-tui
      iotop
      powertop
      sysstat
      # virt-manager
      # iptraf # broken
      nethogs
      iftop
      hdparm
      testdisk
      udiskie
      glxinfo
      libva-utils # collection of utilities and examples to exercise VA-API
      usbutils
      pciutils
      latencytop
      linuxPackages.cpupower
      lsof
      psmisc
      gitFull
      gitAndTools.hub # GitHub extension to git
      # gitAndTools.gitAnnex
      gitAndTools.diff-so-fancy
      gitAndTools.delta
      # gitAndTools.grv # build failed
      gitAndTools.tig
      gitAndTools.gitui
      gist # upload to git.github.com
      bfg-repo-cleaner # https://rtyley.github.io/bfg-repo-cleaner/
      mercurial
      subversion
      curl
      nextcloud-client
      inetutils
      hostsblock
      haskellPackages.ghc
      ruby
      # icedtea_web
      font-manager
      xfontsel
      neovim
      (vim_configurable.customize {
        name = "vim";

        vimrcConfig.customRC = ''
          set clipboard=unnamedplus
          "use the light solarized theme:
          "colorscheme solarized
          let g:solarized_termcolors=256
          color solarized             " Load a colorscheme
          set background=light
          set number relativenumber
          "let g:airline#extensions#tabline#enabled = 1
        '';
        # vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
        # vimrcConfig.vam.pluginDictionaries = [{
        # names =
        # vimrcConfig.packages.myVimPackage = with pkgs.vimPlugins; {
        #   # loaded on launch:
        #   start = [
        #     # "airline"
        #     "colors-solarized"
        #     # "ctrlp"
        #     # "fugitive"
        #     # "fzf-vim"
        #     # "nerdcommenter"
        #     # "nerdtree"
        #     # "rainbow_parentheses"
        #     # "Tabular"
        #     # "undotree"
        #     # "vim-addon-nix"
        #     # "vim-gitgutter"
        #     "vim-nix"
        #     "vim-sensible"
        #     # "vim-sleuth" # Heuristically set buffer options
        #     # "youcompleteme"
        #   ];
        #   # manually loadable by calling `:packadd $plugin-name`
        #   # opt = [ phpCompletion elm-vim ];
        #   # To automatically load a plugin when opening a filetype, add vimrc lines like:
        #   # autocmd FileType php :packadd phpCompletion
        # };
      })

      # vim_configurable
      # vimHugeX
      #my_vim
      # emacs
      # (emacs.override { imagemagick = pkgs.imagemagickBig; } )
      # (pkgs.emacsPackagesGen pkgs.emacsGcc).emacsWithPackages (epkgs: ([epkgs.vterm]))
      texlive.combined.scheme-medium # :lang org -- for latex previews
      wordnet # for offline dictionary and thesaurus support
      # for emacs markdown-preview:
      # marked # node package
      pandoc
      haskellPackages.markdown
      # (mu.override { withMug = true; }) # mug got removed upstream
      mu
      editorconfig-core-c # per-project style config
      gnutls # for TLS connectivity
      imagemagickBig # for image-dired
      pinentry-emacs # in-emacs gnupg prompts
      zstd # for undo-tree compression

      dunst
      #(dunst.override { dunstify = true; })  # dunstify is installed by default
      libnotify
      go-upower-notify
      # ctagsWrapped.ctagsWrapped
      which
      gnuplot
      xorg.xkill
      xorg.xinit
      ltrace
      borgbackup
      restic
      storeBackup
      syncthing
      # syncthing-gtk # broken: https://github.com/NixOS/nixpkgs/commit/330ac8b3dcf1fbd76c21e05d4d88826799327d9c
      khard
      # khal
      vdirsyncer
      # https://github.com/NixOS/nixpkgs/issues/103026
      # pypyPackages.keyring
      python3
      python-with-my-packages
      gparted
      parted
      smartmontools
      unetbootin # has p7zip
      makeWrapper
      #vim
      # ( pkgs.xdg_utils.override { mimiSupport = true; })
      xdg-utils
      shared-mime-info
      perlPackages.MIMETypes
      gnupg
      #windowmanager etc:
      wget
      i3
      polybarFull
      jq
      i3status
      i3-layout-manager
      i3-resurrect
      wmfocus
      xorg.xprop # get window props like class and insctance
      xorg.xev # get the name of a key or key-combo
      # busybox # for usleep: short sleep,used in /home/bart/.dot/common/.local/bin/brightness.sh to flash out of 0
      (busybox.overrideAttrs (oldAttrs: {
        postFixup = ''
          mkdir -p /tmp/xxxxxqqqqqyyyyy
          cp $out/bin/usleep /tmp/xxxxxqqqqqyyyyy
          cp $out/bin/busybox /tmp/xxxxxqqqqqyyyyy
          rm $out/bin/*
          cp /tmp/xxxxxqqqqqyyyyy/usleep $out/bin/
          cp /tmp/xxxxxqqqqqyyyyy/busybox $out/bin/
        '';
      }))
      lm_sensors # for i3status-rust
      dmenu
      clipster
      rofi
      rofi-systemd
      rofimoji

      networkmanager_dmenu
      conky
      dzen2
      xpra
      #desktop
      #desktop-file-utils
      # firefox-esr
      # (firefox-esr.override { nameSuffix="-esr"; })
      firefox
      #for vimeo:
      # gstreamer
      # gst_plugins_base
      # gst_plugins_good
      # gst_plugins_bad
      # gst_plugins_ugly
      tor-browser-bundle-bin
      i2pd
      qutebrowser
      sqlitebrowser
      python3Packages.pyperclip # for qutebrowser, https://github.com/LaurenceWarne/qute-code-hint
      nyxt
      ungoogled-chromium
      # chromium
      # chromiumBeta
      # w3m
      (pkgs.w3m.override { graphicsSupport = true; })
      # youtubeDL
      yt-dlp
      freetube
      vlc
      mumble
      jitsi-meet-electron
      # zoom-us # unfree
      (mumble.override { jackSupport = true; })
      (mpv-unwrapped.override {
        jackaudioSupport = true;
        archiveSupport = true;
        vapoursynthSupport = true;
      })
      mps-youtube
      shotwell # gst-plugins-base == broken
      galculator
      qalculate-gtk
      libqalculate
      bc
      calc
      units
      rink # Unit conversion tool and library written in rust
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
      (ripgrep.override { withPCRE2 = true; })
      ripgrep-all # also search in PDFs, E-Books, Office documents, zip, tar.gz, etc.
      fd # rust fast find alternative
      exa # rust ls alternative
      inotify-tools # notify when a file changes
      trash-cli
      joshuto
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
      lynx
      mediainfo
      fontforge
      python3Packages.ueberzug
      # mutt-with-sidebar
      # mutt-kz
      neomutt
      xfce.thunar
      thunderbird
      isync
      # taskwarrior
      paperkey
      gpa
      urlview
      # offlineimap replaced by isync
      notmuch
      alot
      # remind    #calendar
      # wyrd      # front end for remind
      #pypyPackages.alot
      #python27Packages.alot
      filezilla
      kcolorchooser
      gimp
      inkscape
      (pkgs.blender.override { jackaudioSupport = true; })
      # blender
      openscad
      kdenlive
      # olive-editor
      ffmpeg-full
      simplescreenrecorder
      scrot
      flameshot
      handbrake # gst-plugins-base == broken
      alsa-utils
      meld
      freemind
      arduino
      baobab
      recoll
      # https://github.com/NixOS/nixpkgs/issues/50001 :
      zathura
      evince
      diff-pdf
      xournalpp # anotate pdf's
      kodi
      # (pkgs.pidgin-with-plugins.override {
      # plugins = [ pidginotr ];
      # }) # pidgin + pidgin-otr
      # pidgin
      hexchat
      signal-desktop
      tdesktop
      weechat
      irssi
      gajim

      # non-free:
      # skypeforlinux
      #spideroak
      # unrar
      # calibre

      #toxprpl
      gtypist
      aspell
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.en-science # doesn't build:   https://github.com/NixOS/nixpkgs/issues/101184
      aspellDicts.nl
      aspellDicts.de
      hunspellDicts.en_US-large
      hunspellDicts.nl_NL
      hunspellDicts.de_DE
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

    # applist = [
    # {mimetypes = ["text/plain" "text/css"]; applicationExec = "${pkgs.vim_configurable}/bin/vim";}
    # {mimetypes = ["text/html"]; applicationExec = "${pkgs.firefox}/bin/firefox";}
    # ];

    # xdg_default_apps = import /home/matej/workarea/helper_scripts/nixes/defaultapps.nix { inherit pkgs; inherit applist; };

    shells = [ pkgs.zsh ];
    # Set of files that have to be linked in /etc.
    # etc =
    #   { hosts =
    #       # hostsblock -f /home/bart/.config/hostsblock/hostsblock.conf -u
    #       { source = /home/bart/nixosConfig/hosts;
    #       };
    #   };

    # variables.NIX_AUTO_RUN = "!";

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

  environment.sessionVariables = {
    # EDITOR = "edit";
    BROWSER = "qutebrowser";
    PAGER = "less";
    LESS = "-isMR";
    NIX_PAGER = "cat";
    TERMCMD = "alacritty";
    NIXPKGS = "/home/bart/source/nixpkgs/";
    NIXPKGS_ALL = "/home/bart/source/nixpkgs/pkgs/top-level/all-packages.nix";
    GIT_SSL_CAINFO =
      "/etc/ssl/certs/ca-certificates.crt"; # TODO still needed? https://github.com/NixOS/nixpkgs/pull/96763
    XDG_DATA_HOME = "/home/bart/.local/share";
    TERMINFO_DIRS = "/run/current-system/sw/share/terminfo";
    RANGER_LOAD_DEFAULT_RC = "FALSE";
    FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git";
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

    FZF_ALT_C_COMMAND = "bfs -color -type d";
    FZF_ALT_C_OPTS = "--preview 'tree -L 4 -d -C --noreport -C {} | head -200'";
    # set locales for everything but LANG
    # TODO: nix specific: https://www.reddit.com/r/NixOS/comments/dck6o1/how_to_change_locale_settings/
    # See i18n.extraLocaleSettings. You can search for "locale" in man configuration.nix.
    # exceptions & info https://unix.stackexchange.com/questions/149111/what-should-i-set-my-locale-to-and-what-are-the-implications-of-doing-so
    LANGUAGE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "nl_NL.UTF-8";
    # LC_NUMERIC="nl_NL.UTF-8";
    # LC_TIME = "nl_NL.UTF-8";
    # LC_COLLATE="nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    # LC_MESSAGES="nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
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
      ExecStart = "${pkgs.udiskie}/bin/udiskie -t";
      Restart = "always";
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
      Restart = "always";
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
      Restart = "always";
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
  powerManagement.powerUpCommands = "${pkgs.light}/bin/light -I";

  programs = {
    # zsh has an annoying default config which I don't want
    # so to make it work well I have to turn it off first.
    zsh = {
      enable = true;
      shellInit = "";
      shellAliases = { };
      promptInit = "";
      loginShellInit = "";
      # debug with:
      # nix-instantiate --eval '<nixpkgs/nixos>' -A config.programs.zsh.interactiveShellInit --json | jq -r | bat
      interactiveShellInit = ''
                  #####################################################################
                  # shell independent prompts #########################################
                  #####################################################################

                  # Read a single char from /dev/tty, prompting with "$*"
                  # Note: pressing enter will return a null string. Perhaps a version terminated with X and then remove it in caller?
                  # See https://unix.stackexchange.com/a/367880/143394 for dealing with multi-byte, etc.
                  function get_keypress {
                    local REPLY IFS=
                    >/dev/tty printf '%s' "$*"
                    [[ $ZSH_VERSION ]] && read -rk1  # Use -u0 to read from STDIN
                    # See https://unix.stackexchange.com/q/383197/143394 regarding '\n' -> '''
                    [[ $BASH_VERSION ]] && </dev/tty read -rn1
                    printf '%s' "$REPLY"
                  }

                  # Get a y/n from the user, return yes=0, no=1 enter=$2
                  # Prompt using $1.
                  # If set, return $2 on pressing enter, useful for cancel or defualting
                  function get_yes_keypress {
                    local prompt="''${1:-Are you sure [y/n]? }"
                    local enter_return=$2
                    local REPLY
                    # [[ ! $prompt ]] && prompt="[y/n]? "
                    while REPLY=$(get_keypress "$prompt"); do
                      [[ $REPLY ]] && printf '\n' # $REPLY blank if user presses enter
                      case "$REPLY" in
                        Y|y)  return 0;;
                        N|n)  return 1;;
                        ''')   [[ $enter_return ]] && return "$enter_return"
                      esac
                    done
                  }

                  # Credit: http://unix.stackexchange.com/a/14444/143394
                  # Prompt to confirm, defaulting to NO on <enter>
                  # Usage: confirm "Dangerous. Are you sure?" && rm *
                  function confirm {
                    local prompt="''${*:-Are you sure} [y/N]? "
                    get_yes_keypress "$prompt" 1
                  }

                  # Prompt to confirm, defaulting to YES on <enter>
                  function confirm_yes {
                    local prompt="''${*:-Are you sure} [Y/n]? "
                    get_yes_keypress "$prompt" 0
                  }
                  #####################################################################
                  #####################################################################
                  #####################################################################

                alias  up='nixos-rebuild test --upgrade '
                alias no=nixos-option
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
                alias  te='nixos-rebuild build   -p rt -I nixos-config=/home/bart/nixosConfig/machines/$(hostname | cut -d"-" -f1)/rt.nix                     && nixos-rebuild test'
                alias ten='nixos-rebuild build   -p rt -I nixos-config=/home/bart/nixosConfig/machines/$(hostname | cut -d"-" -f1)/rt.nix -I nixpkgs=$NIXPKGS && nixos-rebuild test   -I nixpkgs=$NIXPKGS'
                alias  sw='nixos-rebuild boot -p rt -I nixos-config=/home/bart/nixosConfig/machines/$(hostname | cut -d"-" -f1)/rt.nix                     && nixos-rebuild switch'
                alias swn='nixos-rebuild boot -p rt -I nixos-config=/home/bart/nixosConfig/machines/$(hostname | cut -d"-" -f1)/rt.nix -I nixpkgs=$NIXPKGS && nixos-rebuild switch -I nixpkgs=$NIXPKGS'

                nga() {
                  if confirm "Delete all generations and vacuum the systemd journal?"; then
                    nix-collect-garbage -d && journalctl --vacuum-time=2d
                  else
                    echo "\nOK, we'll keep it all"
                  fi
                }

                ngd() {
                  if [[ -n "$1" ]] && [[ "$1" =~ ^-?[0-9]+$ ]]; then
                    if confirm "Delete all generations and vacuum the systemd journal except for the last $1 days?"; then
                      nix-collect-garbage --delete-older-than $1d && journalctl --vacuum-time=$1d
                    else
                      echo "\nOK, we'll keep it all."
                    fi
                  else
                    echo "\nYou need to give the number of days you want to keep!"
                  fi
                }

                lg() {
                  echo "System generations\n"
                  nix-env -p /nix/var/nix/profiles/system --list-generations
                  echo "\n\nRT generations:\n"
                  nix-env -p /nix/var/nix/profiles/system-profiles/rt --list-generations
                }

                lgs() {
                  echo "System generations\n"
                  nix-env -p /nix/var/nix/profiles/system --list-generations
                }

                lgr() {
                  echo "RT generations:\n"
                  nix-env -p /nix/var/nix/profiles/system-profiles/rt --list-generations
                }

                dgs() {
                  if [[ -n "$@" ]]
                    for i in "$@"
                    do
                      if [[ "$i" =~ ^-?[0-9]+$ ]]; then

                      else
                        echo "\nYou need to tell me which generations to delete!"
                        kill -INT $$
                      fi
                    done
                    confirm "Delete system generations $@" &&
                    nix-env -p /nix/var/nix/profiles/system --delete-generations $@
                }

                dgr() {
                  if [[ -n "$@" ]]
                    for i in "$@"
                    do
                      if [[ "$i" =~ ^-?[0-9]+$ ]]; then

                      else
                        echo "\nYou need to tell me which generations to delete!"
                        kill -INT $$
                      fi
                    done
                    confirm "Delete realtime generations $@" &&
                    nix-env -p /nix/var/nix/profiles/system-profiles/rt --delete-generations $@
                }

                alias ns='nix-shell --command zsh $NIXPKGS'
                alias nsn='nix-shell -I nixpkgs=$NIXPKGS --command zsh'
         # this will leave the build directory behind for you to inspect:
                # alias nb='nix-build -K -A $1 $(pwd)'
        # doesn't work, this one does:
        # nix-build -K -E "with import <nixpkgs> {}; callPackage ./default.nix {}"

                vi() {emacseditor --create-frame --quiet --no-wait "$@"}
                # export EDITOR="vi"

      '';
    };

    command-not-found.enable = true;

    ssh = {
      startAgent = true;
      forwardX11 = true;
      askPassword = "";
      extraConfig = ''
        Host beta.nixbuild.net nxb-*
          Port 22
          StrictHostKeyChecking no
          UserKnownHostsFile /dev/null
          PubkeyAcceptedKeyTypes ssh-ed25519
          IdentityFile /home/bart/.ssh/id_ed25519

        Host nxb-4
          HostName beta.nixbuild.net
          SetEnv CPU=4

        Host nxb-16
          HostName beta.nixbuild.net
          SetEnv CPU=16
      '';
    };

    gnupg.agent.enable = true;

    chromium = {
      enable = true;
      # Imperatively installed extensions will seamlessly merge with these.
      # Removing extensions here will remove them from chromium, no matter how
      # they were installed.
      defaultSearchProviderSearchURL =
        "https://duckduckgo.com/?q={searchTerms}";
      extensions = [
        # "naepdomgkenhinolocfifgehidddafch" # browserpass-ce
        # "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
        "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # privacy badger
        "gcbommkclmclpchllfjekcdonpmejbdp" # https everywhere
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
        "ldpochfccmkkmhdbclfhpagapcfdljkj" # Decentraleyes
        # "cmedhionkhpnakcndndgjdbohmhepckk" # Adblock for Youtube™
        # "gfbliohnnapiefjpjlpjnehglfpaknnc" # Surfingkeys
        # "ignpacbgnbnkaiooknalneoeladjnfgb" # Url in title
        "poahndpaaanbpbeafbkploiobpiiieko" # Display anchors
        "klbibkeccnjlkjkiokjodocebajanakg" # the great suspender
        # "kajibbejlbohfaggdiogboambcijhkke" # mailvelope
      ];
      extraOpts = {
        DefaultSearchProviderEnabled = true;
        DefaultSearchProviderName = "DuckDuckGo";
        PasswordManagerEnabled = false;
        BrowserSignin = 0;
        AudioCaptureAllowed = false;
        RestoreOnStartup = 5;
        NetworkPredictionOptions = 2;
        SafeBrowsingEnabled = true;
        SafeBrowsingExtendedReportingEnabled = false;
        SearchSuggestEnabled = false;
      };
    };
    light.enable = true;
    # gtk search:
    plotinus.enable = true;
    # Android Debug Bridge
    adb.enable = true;
    # for zrythm, see: https://github.com/NixOS/nixpkgs/issues/85546
    dconf.enable = true;
    # dconf.profiles.user = pkgs.writeText "dconf-user-profile" ''
    # user-db:user
    # system-db:local
    # '';
  };
  # Define fonts
  fonts = {
    # fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "IBM Plex Mono" ];
        sansSerif = [ "IBM Plex Sans" ];
        serif = [ "IBM Plex Serif" ];
      };
      # penultimate.enable = true;
      # allowType1 = true;
      useEmbeddedBitmaps =
        true; # pango doesn't support mixing bitmap fonts with ttf anymore, so we if we want terminus plus icons we need terminus_font_ttf for i3bar, which displays wonky without this
    };
    fonts = with pkgs; [
      terminus_font
      siji # bitmap icons
      tewi-font # bitmap icons + letters
      terminus_font_ttf
      nerdfonts
      emacs-all-the-icons-fonts
      google-fonts
      liberation_ttf
      ibm-plex
      # core-fonts
    ];
  };

  console = {
    packages = [ pkgs.terminus_font ];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v12n.psf.gz";
    useXkbConfig = true;
    # solarized light
    colors = [
      "eee8d5"
      "dc322f"
      "859900"
      "b58900"
      "268bd2"
      "d33682"
      "2aa198"
      "073642"
      "002b36"
      "cb4b16"
      "586e75"
      "839496"
      "657b83"
      "6c71c4"
      "586e75"
      "002b36"
    ];
    # solarized dark
    # colors = [ "839496" "93a1a1" "eee8d5" "2aa198" "fdf6e3" "859900" "d33682" "dc322f" "657b83" "586e75" "cb4b16" "073642" "268bd2" "b58900" "002b36" "6c71c4" ];
    # setup pretty console ASAP (in initrd).
    earlySetup = true;
  };
  i18n = { defaultLocale = "en_US.UTF-8"; };

  networking = {
    # firewall.enable = false;
    # resolvconf.dnsExtensionMechanism =
    # false; # workaround to fix “WiFi in de Trein”
    # resolvconf.dnsExtensionMechanism = false;
  };

  time.timeZone = "Europe/Amsterdam";

  users = {
    defaultUserShell = pkgs.zsh;
    users.bart = {
      name = "bart";
      group = "users";
      uid = 1000;
      createHome = false;
      home = "/home/bart";
      extraGroups = [
        "wheel"
        "audio"
        "jackaudio"
        "video"
        "usbmux"
        "networkmanager"
        "adbusers"
        "libvirtd"
        "camera"
      ];
      shell = pkgs.zsh;
      isNormalUser = true;
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
    {
      domain = "@audio";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
    {
      domain = "@audio";
      item = "rtprio";
      type = "-";
      value = "99";
    }
    {
      domain = "@audio";
      item = "nofile";
      type = "soft";
      value = "99999";
    }
    {
      domain = "@audio";
      item = "nofile";
      type = "hard";
      value = "99999";
    }
  ];

}
