{ config, lib, pkgs, ... }:

with lib;

let
  wmCfg = config.services.xserver.windowManager;

  i3option = name: {
    enable = mkEnableOption name;
    configFile = mkOption {
      default = null;
      type = types.nullOr types.path;
      description = ''
        Path to the i3 configuration file.
        If left at the default value, $HOME/.i3/config will be used.
      '';
    };
    extraSessionCommands = mkOption {
      default = "";
      type = types.lines;
      description = ''
        Shell commands executed just before i3 is started.
      '';
    };
  };

  i3config = name: pkg: cfg: {
    services.xserver.windowManager.session = [{
      inherit name;
      start = ''
        ${cfg.extraSessionCommands}

        ${pkgs.openssh}/bin/ssh -Y 2.2.2.2 i3 ${optionalString (cfg.configFile != null)
          "-c \"${cfg.configFile}\""
        } &
        waitPID=$!
      '';
    }];
    environment.systemPackages = [ pkg ];
  };

in

{
  options.services.xserver.windowManager = {
    remote_i3 = i3option "remote_i3";
    # i3-gaps = i3option "i3-gaps";
  };

  config = mkMerge [
    (mkIf wmCfg.remote_i3.enable (i3config "remote_i3" pkgs.i3 wmCfg.remote_i3))
  ];
}
