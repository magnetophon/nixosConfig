{ config, lib, pkgs, ... }:

{

  # Remove sound.enable or turn it off if you had it set previously, it seems to cause conflicts with pipewire
  sound.enable = false;
  # pipewire
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
        "default.clock.rate" = 44100;
        # "default.clock.rate" = 48000;
        "default.clock.allowed-rates" = [ 44100 48000 88200 96000 ];
        #"default.clock.quantum" = 1024;
        #"default.clock.min-quantum" = 32;
        #"default.clock.max-quantum" = 8192;
      };
    };
    # config.pipewire = {
    #   "properties" = {
    #     #"link.max-buffers" = 64;
	  #     "link.max-buffers" = 16; # version < 3 clients can't handle more than this
	  #     "log.level" = 2;
    #     "default.clock.rate" = 48000;
    #     "default.clock.quantum" = 1024;
    #     "default.clock.min-quantum" = 128;
    #     "default.clock.max-quantum" = 4096;
    #   };
    #   "context.objects" = [
    #     {
    #       # A default dummy driver. This handles nodes marked with the "node.always-driver"
    #       # properyty when no other driver is currently active. JACK clients need this.
    #       factory = "spa-node-factory";
    #       args = {
    #         "factory.name"     = "support.node.driver";
    #         "node.name"        = "Dummy-Driver";
    #         "node.group"       = "pipewire.dummy";
    #         "priority.driver"  = 20000;
    #       };
    #     }
    #     {
    #       # Freewheeling driver. This is used e.g. by Ardour for exporting projects faster than realtime.
    #       factory = "spa-node-factory";
    #       args = {
    #         "factory.name"     = "support.node.driver";
    #         "node.name"        = "Freewheel-Driver";
    #         "node.group"       = "pipewire.freewheel";
    #         "node.freewheel"   = true;
    #         "priority.driver"  = 19000;
    #       };
    #     }
    #   ];
    # };
  };
}
