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
}
