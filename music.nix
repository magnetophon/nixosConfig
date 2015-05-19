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
  soundcardPciId = "00:1b.0";
  rtirq.enable = true;
  rtirq.nameList = "rtc0 hpet snd snd_hda_intel";
  rtirq.highList = "snd_hrtimer";
  rtirq.nonThreaded = "rtc0 snd";
};

#for running alsa trough jack
boot.kernelModules = [ "snd-aloop" ];

nixpkgs.config.packageOverrides = pkgs : rec {
   guitarix = pkgs.guitarix.override { optimizationSupport = true; };
};

environment= {
  systemPackages = [
    audacity
    a2jmidid
    #beast
    caps
    calf
    jack2
    jack_capture
    qjackctl
    ardour
    #distrho
    flac
    fluidsynth
    freewheeling
    guitarix
    hydrogen
    ingen
    #jack-oscrolloscope
    jackmeter
    liblo
    ladspaH
    #ladspaPlugins
    lame
    #mda-lv2
    #puredata
    #(pkgs.puredata-with-plugins.override { plugins = [ helmholtz timbreid maxlib puremapping zexy cyclone mrpeach ]; })
    setbfree
    supercollider
    #vimpc  #A vi/vim inspired client for the Music Player Daemon (mpd)
    vlc
    yoshimi
    zynaddsubfx
#custom packages
    faust
    faust2alqt
    faust2alsa
    faust2firefox
    faust2jack
    faust2jaqt
    jaaa
    sooperlooper
    zita-dpl1
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
 faust2lv2
    plugin-torture
    ladspa-sdk
    sooperlooper
    #SynthSinger
  ];
};
}
