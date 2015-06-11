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
  rtirq.enable = true;
  # machine specific:
  /*soundcardPciId = "00:1b.0";*/
  /*rtirq.nameList = "rtc0 hpet snd snd_hda_intel";*/
  rtirq.highList = "snd_hrtimer";
  rtirq.nonThreaded = "rtc0 snd";
};

#for running alsa trough jack
boot.kernelModules = [ "snd-aloop" ];

nixpkgs.config.packageOverrides = pkgs : rec {
   guitarix = pkgs.guitarix.override { optimizationSupport = true; };
   puredata-with-plugins = pkgs.callPackage /home/bart/source/nixpkgs/pkgs/applications/audio/puredata/wrapper.nix {  plugins = [ helmholtz timbreid maxlib puremapping zexy cyclone mrpeach ]; };
   #pd-with-plugins = pkgs.puredata-with-plugins.override { plugins = [ helmholtz timbreid maxlib puremapping zexy cyclone mrpeach ]; };
};

environment= {
  systemPackages = [
    audacity
    a2jmidid
    ams-lv2
    #beast
    bristol
    caps
    calf
    drumkv1
    drumgizmo
    jack2
    jack_capture
    qjackctl
    #distrho
    flac
    fluidsynth
    freewheeling
    gigedit
    guitarix
    hydrogen
    ingen
    #jack-oscrolloscope
    jackmeter
    jalv
    lilv-svn
    liblo
    linuxsampler
    ladspaH
    #ladspaPlugins
    ladspaPlugins-git
    lame
    mda_lv2
    petrifoo
    #pkgs.puredata-with-plugins.override { plugins = [ helmholtz timbreid maxlib puremapping zexy cyclone mrpeach ]; }
    qsampler
    qsynth
    samplv1
    swh_lv2
    synthv1
    setbfree
    supercollider
    #vimpc  #A vi/vim inspired client for the Music Player Daemon (mpd)
    vlc
    vmpk
    yoshimi
    zynaddsubfx
#custom packages
    faust
    faust2alqt
    faust2alsa
    faust2firefox
    faust2jack
    faust2jaqt
    faust2lv2
    #temp broken by lib
    #jaaa
    #zita-dpl1
    sooperlooper
    nova-filters
    zam-plugins-git
    ardour3
    ardour4
    ir.lv2
    distrho
    sorcer
    guitarix
    artyFX
    x42-plugins
    fomp
    plugin-torture
    ladspa-sdk
    sooperlooper
    QmidiNet
    eq10q
    #SynthSinger
  ];
};
}
