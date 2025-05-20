{
  description = "NixOS flake for magnetophon/nixosConfig with nixframe host";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05"; # or another channel you prefer

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.nixframe = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./machines/nixframe/default.nix
        ];
      };
    };
}}
