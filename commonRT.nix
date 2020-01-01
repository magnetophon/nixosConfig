{ config, lib, pkgs, ... }:

{

  services.tlp.enable = false;

  # boot.kernelPackages = pkgs.linux_rt.linux_4_19_rt;
  # boot.kernelPackages = pkgs.linux_rt.linux_5_0_rt;

  musnix = {
    enable = true;
    # kernel.packages = pkgs.linuxPackages_latest_rt;
    kernel.packages = pkgs.linuxPackages_4_19_rt;
    kernel.optimize = true;
    kernel.realtime = true;
    rtirq.enable = true;
    das_watchdog.enable = true;
  };

  services = {
    jack.jackd = {
      enable = true;
      # extraOptions =
    };
  };
}
