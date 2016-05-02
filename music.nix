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
    CharacterCompressor
    CompBus
    constant-detune-chorus
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
    foo-yc20
    freewheeling
    gigedit
    guitarix
    hydrogen
    helm
    ingen
    jack_oscrolloscope
    jackmeter
    jalv
    lilv-svn
    liblo
    #unfree:
    #linuxsampler
    ladspaH
    #ladspaPlugins
    ladspaPlugins-git
    lame
    #latencytop
    LazyLimiter
    MBdistortion
    mda_lv2
    mixxx
    mod-distortion
    petrifoo
    #pkgs.puredata-with-plugins.override { plugins = [ helmholtz timbreid maxlib puremapping zexy cyclone mrpeach ]; }
    fullPD
    qsampler
    qsynth
    RhythmDelay
    samplv1
    swh_lv2
    synthv1
    setbfree
    # supercollider
    #vimpc  #A vi/vim inspired client for the Music Player Daemon (mpd)
    tetraproc
    vmpk
    VoiceOfFaust
    yoshimi
    zynaddsubfx
    faust
    faust2alqt
    faust2alsa
    faust2firefox
    faust2jack
    faust2jaqt
    faust2lv2
    ( pkgs.fmit.override { jackSupport = true; })
    jaaa
    sooperlooper
    nova-filters
    ardour3
    ardour4
    ir.lv2
    # needs ladspa-sdk, which has a corrupted download
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
