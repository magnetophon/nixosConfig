{ config, lib, pkgs, ... }:

{

  services.tlp.enable = false;
  # services.pipewire.config.client-rt
  # boot.kernelPackages = pkgs.linux_rt.linux_4_19_rt;
  # boot.kernelPackages = pkgs.linuxPackages-rt_5_4;
  # boot.kernelPackages = pkgs.linuxPackages-rt_5_10;
  # boot.kernelPackages = pkgs.linuxPackages_rt_5_15 ;
  # boot.kernelPackages = pkgs.linuxPackages-rt_6_1;
  # boot.kernelPackages = pkgs.linuxPackages-rt;
  boot.kernelPackages = pkgs.linuxPackages-rt_latest;

  sound.enable = true;

  musnix = {
    enable = true;
    # kernel.packages = pkgs.linuxPackages_5_15_rt;
    # kernel.packages = pkgs.linuxPackages_6_1_rt;
    # kernel.packages = pkgs.linuxPackages_latest_rt;
    # kernel.realtime = true;
    rtirq.enable = true;
    das_watchdog.enable = true;
  };


  hardware.pulseaudio.enable = false;

  services = {
    pipewire.enable = false;
    # alsa.enable = true;
    jack = {
      jackd = {
        # enable = true;
        # per device:
        # extraOptions = [
        # "-v" "-P71" "-p1024" "-dalsa" "-dhw:PCH" "-r48000" "-p2048" "-n2" "-P"
        # ];
        session = "a2jmidid -e";
      };
      # support ALSA only programs via ALSA JACK PCM pluginor loopback
      alsa.enable = true;
      # loopback = {
      # enable = true;
      # config = "";
      # };
    };
  };
}
