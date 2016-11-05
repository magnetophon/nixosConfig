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
  enable = true;
  #kernel.packages = pkgs.linuxPackages_4_1_rt;
  kernel.packages = pkgs.linuxPackages_latest_rt;
  #kernel.latencytop = true;
  rtirq.enable = true;
  # machine specific:
  /*soundcardPciId = "00:1b.0";*/
  /*rtirq.nameList = "rtc0 hpet snd snd_hda_intel";*/
  rtirq.highList = "snd_hrtimer";
  /*rtirq.nonThreaded = "rtc0 snd";*/
  rtirq.resetAll = 1;
};

# is default on in musnix
#services.das_watchdog.enable = true;


nixpkgs.config.packageOverrides = pkgs : rec {
   guitarix = pkgs.guitarix.override { optimizationSupport = true; };
   #puredata-with-plugins = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/puredata/wrapper.nix {  plugins = [ helmholtz timbreid maxlib puremapping zexy cyclone mrpeach ]; };
   #pd-with-plugins = pkgs.puredata-with-plugins.override { plugins = [ helmholtz timbreid maxlib puremapping zexy cyclone mrpeach ]; };
   # todo: puremapping has xhanges hash
   plugins = [ helmholtz timbreid maxlib zexy cyclone mrpeach ];
   /*plugins = [ helmholtz timbreid maxlib puremapping zexy cyclone mrpeach ];*/
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
    #beast
    bitmeter
    bristol
    caps
    calf
    drumkv1
    drumgizmo
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
    # mod-distortion https://github.com/moddevices/mod-distortion/issues/5
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
    sooperlooper
    nova-filters
    # ardour3
    # ardour4
    ardour5
    ir.lv2
    distrho
    sorcer
    sox
    shntool
    artyFX
    x42-plugins
    fomp
    ladspa-sdk
    QmidiNet
#custom packages
    #zam-plugins-git
    zam-plugins
    #zita-dpl1
    plugin-torture
  ];
};
}
