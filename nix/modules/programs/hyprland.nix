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
      ];

      programs.hyprland.enable = true;

      environment.sessionVariables.NIXOS_OZONE_WL = "1";
    };
}
