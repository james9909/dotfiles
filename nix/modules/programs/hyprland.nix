{ config, ... }:
let
  inherit (config.flake.modules) nixos homeManager;
in
{
  flake.modules.nixos.hyprland =
    { pkgs, ... }:
    {
      imports = [
        nixos.kitty
        nixos.noctalia
	nixos.noctalia-greeter
      ];

      programs.hyprland = {
        enable = true;
        withUWSM = true;
      };

      environment.sessionVariables.NIXOS_OZONE_WL = "1";
    };
}
