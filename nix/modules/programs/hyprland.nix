{ config, ... }:
let
  inherit (config.flake.modules) nixos homeManager;
in
{
  flake.modules.nixos.hyprland =
    { pkgs, ... }:
    {
      imports = [
        nixos.imv
        nixos.kitty
	nixos.nautilus
        nixos.noctalia
	nixos.noctalia-greeter
	nixos.removable-media
      ];

      programs.hyprland = {
        enable = true;
        withUWSM = true;
      };

      environment.sessionVariables.NIXOS_OZONE_WL = "1";
    };
}
