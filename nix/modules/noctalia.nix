{ config, ... }:
{
  flake.modules.nixos.noctalia =
    { pkgs, ... }:
    {
      programs.noctalia = {
        enable = true;

        recommendedServices.enable = true;
      };
    };
}
