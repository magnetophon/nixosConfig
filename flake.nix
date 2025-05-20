{
  description = "NixOS flake for magnetophon/nixosConfig with nixframe host";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; 
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware";
  inputs.musnix.url = "github:musnix/musnix";

  outputs = { self, nixpkgs, nixos-hardware, musnix, ... }:
    let
      system = "x86_64-linux";
    in {

      nixosConfigurations.nixframe = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./machines/nixframe/default.nix
          nixos-hardware.nixosModules.framework-12-13th-gen-intel
          musnix.nixosModules.musnix
        ];
      };

    nixosConfigurations.pronix = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./machines/pronix/configuration.nix
        ];
      };

    };
}
