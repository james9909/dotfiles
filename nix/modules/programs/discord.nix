{ config, ... }:
let
  inherit (config.flake.modules) homeManager;
in
{
  flake.modules.nixos.discord = {
    home-manager.sharedModules = [ homeManager.discord ];
  };

  flake.modules.homeManager.discord =
    { pkgs, ... }:
    {
      programs.discord = {
        enable = true;
	package = pkgs.discord-canary;
      };
    };
}
