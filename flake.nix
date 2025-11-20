{
  description = "Deployment for my server";

  # For accessing `deploy-rs`'s utility Nix functions
  inputs.deploy-rs.url = "github:serokell/deploy-rs";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  # inputs.nixpkgs.url = "path:/home/bart/source/nixpkgs";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware";
  inputs.musnix.url = "github:musnix/musnix";
  inputs.nur = {
    url = "github:nix-community/NUR";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.bandithedoge = {
    url = "github:bandithedoge/nur-packages";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, deploy-rs, nixos-hardware, musnix, nur, bandithedoge }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.nixframe = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./machines/nixframe/default.nix
          nixos-hardware.nixosModules.framework-12th-gen-intel
          musnix.nixosModules.musnix
          ({ pkgs, ... }: {
            nixpkgs.overlays = [ nur.overlay ];
          })
        ];
        specialArgs = {
          inherit bandithedoge;
        };
      };

      nixosConfigurations.nixframe-rt = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./machines/nixframe/rt.nix
          nixos-hardware.nixosModules.framework-12th-gen-intel
          musnix.nixosModules.musnix
          ({ pkgs, ... }: {
            nixpkgs.overlays = [ nur.overlay ];
          })
        ];
        specialArgs = {
          inherit bandithedoge;
        };
      };
      
      nixosConfigurations.pronix = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./machines/pronix/configuration.nix
        ];
      };

      deploy.nodes.pronix = {
        hostname = "81.206.32.45"; # or your pronix's real hostname or IP
        sshUser = "bart";
        user = "root";
        # Whether to enable interactive sudo (password based sudo). Useful when using non-root sshUsers.
        # This defaults to `false`
        interactiveSudo = true;
        # This is an optional list of arguments that will be passed to SSH.
        sshOpts = [ "-p" "511" ];
        remoteBuild = true;
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.pronix;
        };
      };

      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
