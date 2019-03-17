{ config, pkgs, ... }: with pkgs;
{

  # make sure you do:
  # users.extraUsers.bart.extraGroups = [ "wheel" "audio" ];
  # set:
  # soundcardPciId
  # rtirq.nameList


imports =
  [  # Include musnix: a meta-module for realtime audio.
    # todo: make submodule
    /home/bart/source/musnix/default.nix
  ];

musnix = {
  # enable = true;
  rtirq.highList = "snd_hrtimer";
    rtirq.resetAll = 1;
    rtirq.prioLow = 0;
    alsaSeq.enable = false;
};

nixpkgs.config.packageOverrides = pkgs : rec {
   guitarix = pkgs.guitarix.override { optimizationSupport = true; };
   plugins = [ helmholtz timbreid maxlib zexy puremapping cyclone mrpeach ];
   # plugins = [ helmholtz timbreid maxlib zexy cyclone mrpeach ];
   fullPD = puredata-with-plugins plugins;
   qjackctl = pkgs.stdenv.lib.overrideDerivation pkgs.qjackctl (oldAttrs: {
     configureFlags = "--enable-jack-version --disable-xunique"; # fix bug for remote running
   });
};

environment= {
  systemPackages = [
    AMB-plugins
    audacity
    a2jmidid
    ams-lv2
    # airwave # VST bridge
    # airwindows
    aeolus
    #beast
    bitmeter
    bristol
    caps
    calf
    drumkv1
    padthv1
    drumgizmo
    avldrums-lv2
    dfasma
    cuetools
    eq10q
    jack2Full
    /*jack1*/
    jack_capture
    qjackctl
    cadence
    flac
    fluidsynth
    fmsynth
    # foo-yc20 https://github.com/sampov2/foo-yc20/issues/7
    freewheeling
    # gigedit
    guitarix
    gxplugins-lv2
    lsp-plugins
    hydrogen
    helm
    ingen
    jack_oscrolloscope
    jackmeter
    jalv
    lilv
    liblo
    #unfree:
    #linuxsampler
    ladspaH
    ladspaPlugins
    infamousPlugins
    FIL-plugins
    lame
    #latencytop
    magnetophonDSP.CharacterCompressor
    magnetophonDSP.CompBus
    magnetophonDSP.LazyLimiter
    magnetophonDSP.MBdistortion
    magnetophonDSP.RhythmDelay
    magnetophonDSP.VoiceOfFaust
    magnetophonDSP.ConstantDetuneChorus
    magnetophonDSP.faustCompressors
    magnetophonDSP.shelfMultiBand
    magnetophonDSP.pluginUtils
    mda_lv2
    csa
    mixxx
    mod-distortion
    petrifoo
    #pkgs.puredata-with-plugins.override { plugins = [ helmholtz timbreid maxlib puremapping zexy cyclone mrpeach ]; }
    fullPD
    qsampler
    # qsynth
    samplv1
    swh_lv2
    synthv1
    setbfree
    supercollider_scel
    #vimpc  #A vi/vim inspired client for the Music Player Daemon (mpd)
    tetraproc
    vmpk
    yoshimi
    zynaddsubfx
    faust
    faust2alqt
    faust2alsa
    faust2firefox
    faust2jack
    faust2jaqt
    faust2lv2
    graphviz
    leiningen
    ( pkgs.fmit.override { jackSupport = true; })
    jaaa
    japa
    sooperlooper
    squishyball
    nova-filters
    wolf-shaper
    # ardour3
    # ardour4
    ardour
    ir.lv2
    # https://github.com/DISTRHO/DISTRHO-Ports/issues/17
    distrho
    dragonfly-reverb
    sorcer
    sox
    shntool
    artyFX
    x42-plugins
    fomp
    ladspa-sdk
    QmidiNet
    rkrlv2
    # i-score
#custom packages
    #zam-plugins-git
    zam-plugins
    #zita-dpl1
    plugin-torture
    # m32edit
  ];
};

  systemd.services = {
  #   jack = {
  #     after = [ "sound.target" ];
  #     description = "Jack audio server";
  #     wantedBy = [ "multi-user.target" ];
  #     serviceConfig = {
  #       LimitRTPRIO = "infinity";
  #       LimitMEMLOCK = "infinity";
  #       Environment="JACK_NO_AUDIO_RESERVATION=1";
  #       ExecStart = ''
  #         ${pkgs.jack2}/bin/jackd -P71 -p1024 -dalsa -dhw:0 -r44100 -n2
  #       '';
  #       User = "bart";
  #       Group = "audio";
  #       KillSignal="SIGKILL";
  #       Restart="always";
  #       # ExecStartPre="${pkgs.pulseaudio}/bin/pulseaudio -k";
  #     };
  #   };

    # papillon = {
    #   after = [ "network-online.target" "jack.service" ];
    #   description = "Papillon liquidsoap stream";
    #   # wantedBy = [ "multi-user.target" ];
    #   path = [ pkgs.wget ];
    #   preStart = ''
    #     mkdir -p /var/log/liquidsoap
    #     chown bart -R /var/log/liquidsoap
    #   '';
    #   serviceConfig = {
    #     LimitRTPRIO = "infinity";
    #     LimitMEMLOCK = "infinity";
    #     PermissionsStartOnly="true";
    #     ExecStart = "${pkgs.liquidsoap}/bin/liquidsoap /home/bart/source/nixradio/papillon.liq";
    #     User = "bart";
    #     Group = "audio";
    #     KillSignal="SIGKILL";
    #     Restart="always";
    #   };
    # };

    # tunnel = {
    #   after = [ "network.target" ];
    #   description = "Creates a public reverse tunnel from a server to a port of this computer.";
    #   wantedBy = [ "multi-user.target" ];
    #   serviceConfig = {
    #     Environment="AUTOSSH_GATETIME=0";
    #     ExecStart = ''
    #       ${pkgs.autossh}/bin/autossh -M 0 -oStrictHostKeyChecking=no -oServerAliveInterval=60 -oServerAliveCountMax=3 -oExitOnForwardFailure=yes -N -R :666:localhost:666 magnetophon@81.7.19.118
    #     '';
    #     # Restart="always";
    #   };
    # };
  };

    security.sudo.extraConfig = ''
    bart  ALL=(ALL) NOPASSWD: ${pkgs.systemd}/bin/systemctl
  '';

}
