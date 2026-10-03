{ config, inputs, lib, ... }:

{
  flake.nixosConfigurations.phoenix = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      config.flake.modules.nixos."hosts/phoenix"
    ];
  };
}
