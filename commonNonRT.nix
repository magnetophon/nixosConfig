{ config, lib, pkgs, ... }:

{

  # Remove sound.enable or turn it off if you had it set previously, it seems to cause conflicts with pipewire
  sound.enable = false;
  # pipewire
  security.rtkit.enable = true; # rtkit is optional but recommended for PipeWire
  services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
      socketActivation = true;
      # config.pipewire = {
      # "context.properties" = {
      # "link.max-buffers" = 16; # version < 3 clients can't handle more than this
      # "log.level" = 2; # https://docs.pipewire.org/#Logging
      # "default.clock.rate" = 48000;
      # "default.clock.allowed-rates" = [ 44100 48000 88200 96000 ];
      # "default.clock.quantum" = 1024;
      # "default.clock.min-quantum" = 32;
      # "default.clock.max-quantum" = 8192;
      # };
      # };
      # wireplumber.enable = true; // default
  };
  # virtualisation.virtualbox =
  # {
  # host.enable = true;
  # host.enableExtensionPack = true;
  # };

  # virtualisation.libvirtd.enable = true;


  # Minimal configuration for NFS support with Vagrant.
  # services.nfs.server.enable = true;

  # Add firewall exception for VirtualBox provider
  # networking.firewall.extraCommands = ''
  # ip46tables -I INPUT 1 -i vboxnet+ -p tcp -m tcp --dport 2049 -j ACCEPT
  # '';

  # Add firewall exception for libvirt provider when using NFSv4
  # networking.firewall.interfaces."virbr1" = {
  # allowedTCPPorts = [ 2049 ];
  # allowedUDPPorts = [ 2049 ];
  # };

}
