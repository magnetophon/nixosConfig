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
      config.pipewire = {
          "context.properties" = {
              #"link.max-buffers" = 64;
              "link.max-buffers" = 16; # version < 3 clients can't handle more than this
              "log.level" = 2; # https://docs.pipewire.org/#Logging
              # "default.clock.rate" = 44100;
              "default.clock.rate" = 48000;
              "default.clock.allowed-rates" = [ 44100 48000 88200 96000 ];
              "default.clock.quantum" = 1024;
              "default.clock.min-quantum" = 32;
              "default.clock.max-quantum" = 8192;
          };
      };
      # wireplumber.enable = true; // default
  };
  virtualisation.virtualbox =
    {
      # host.enable = true;
      # host.enableExtensionPack = true;
    };

}
