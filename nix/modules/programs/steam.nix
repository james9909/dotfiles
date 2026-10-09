{
  flake.modules.nixos.steam =
    { pkgs, ... }:
    {
      programs.steam.enable = true;
    };
}
