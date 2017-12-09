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
  rtirq.enable = true;
  rtirq.highList = "snd_hrtimer";
  rtirq.resetAll = 1;
  rtirq.prioLow = 0;
  das_watchdog.enable = true;
  kernel.packages = pkgs.linuxPackages_latest_rt;
  alsaSeq.enable = false;
};

nixpkgs.config.packageOverrides = pkgs : rec {
   guitarix = pkgs.guitarix.override { optimizationSupport = true; };
   #puredata-with-plugins = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/puredata/wrapper.nix {  plugins = [ helmholtz timbreid maxlib puremapping zexy cyclone mrpeach ]; };
   #pd-with-plugins = pkgs.puredata-with-plugins.override { plugins = [ helmholtz timbreid maxlib puremapping zexy cyclone mrpeach ]; };
   # todo: puremapping has xhanges hash
   plugins = [ helmholtz timbreid maxlib zexy puremapping cyclone mrpeach ];
   # plugins = [ helmholtz timbreid maxlib zexy cyclone mrpeach ];
   fullPD = puredata-with-plugins plugins;
   qjackctl = pkgs.stdenv.lib.overrideDerivation pkgs.qjackctl (oldAttrs: {
     configureFlags = "--enable-jack-version --disable-xunique"; # fix bug for remote running
   });
   # jack2Full = libjack2Unstable;
   # libjack2 = libjack2Unstable;
   # faust = faust2unstable;
};

environment= {
  systemPackages = [
    AMB-plugins
    audacity
    a2jmidid
    ams-lv2
    # airwave # VST bridge
    aeolus
    #beast
    bitmeter
    bristol
    caps
    calf
    drumkv1
    padthv1
    drumgizmo
    dfasma
    cuetools
    eq10q
    jack2Full
    /*jack1*/
    jack_capture
    qjackctl
    flac
    fluidsynth
    fmsynth
    # foo-yc20 https://github.com/sampov2/foo-yc20/issues/7
    freewheeling
    gigedit
    guitarix
    hydrogen
    helm
    # ingen
    jack_oscrolloscope
    jackmeter
    jalv
    lilv
    liblo
    #unfree:
    #linuxsampler
    ladspaH
    ladspaPlugins
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
    mixxx
    mod-distortion
    petrifoo
    #pkgs.puredata-with-plugins.override { plugins = [ helmholtz timbreid maxlib puremapping zexy cyclone mrpeach ]; }
    fullPD
    qsampler
    qsynth
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
    # ardour3
    # ardour4
    ardour
    ir.lv2
    # https://github.com/DISTRHO/DISTRHO-Ports/issues/17
    distrho
    sorcer
    sox
    shntool
    artyFX
    x42-plugins
    fomp
    ladspa-sdk
    QmidiNet
    rkrlv2
#custom packages
    #zam-plugins-git
    zam-plugins
    #zita-dpl1
    plugin-torture
  ];
};
}
