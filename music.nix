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
  kernel.optimize = true;
  kernel.realtime = true;
  #kernel.packages = pkgs.linuxPackages_4_1_rt;
  #kernel.latencytop = true;
  rtirq.enable = true;
  # machine specific:
  /*soundcardPciId = "00:1b.0";*/
  /*rtirq.nameList = "rtc0 hpet snd snd_hda_intel";*/
  rtirq.highList = "snd_hrtimer";
  rtirq.nonThreaded = "rtc0 snd";
};

services.das_watchdog.enable = true;

#for running alsa trough jack
boot.kernelModules = [ "snd-aloop" ];

nixpkgs.config.packageOverrides = pkgs : rec {
   guitarix = pkgs.guitarix.override { optimizationSupport = true; };
   #puredata-with-plugins = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/puredata/wrapper.nix {  plugins = [ helmholtz timbreid maxlib puremapping zexy cyclone mrpeach ]; };
   #pd-with-plugins = pkgs.puredata-with-plugins.override { plugins = [ helmholtz timbreid maxlib puremapping zexy cyclone mrpeach ]; };
   plugins = [ helmholtz timbreid maxlib puremapping zexy cyclone mrpeach ];
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
    eq10q
    #jack2
    jack_capture
    qjackctl
    distrho
    flac
    fluidsynth
    foo-yc20
    freewheeling
    gigedit
    guitarix
    hydrogen
    ingen
    jack_oscrolloscope
    jackmeter
    jalv
    lilv-svn
    liblo
    #linuxsampler
    ladspaH
    ladspaPlugins
    #ladspaPlugins-git
    lame
    #latencytop
    LazyLimiter
    MBdistortion
    mda_lv2
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
    #supercollider
    #vimpc  #A vi/vim inspired client for the Music Player Daemon (mpd)
    tetraproc
    vlc
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
    jaaa
    sooperlooper
    nova-filters
    ardour3
    ardour4
    ir.lv2
    distrho
    sorcer
    guitarix
    artyFX
    x42-plugins
    fomp
    ladspa-sdk
    sooperlooper
    QmidiNet
#custom packages
    zam-plugins-git
    zita-dpl1
    plugin-torture
  ];
};
}
