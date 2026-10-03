{
  flake.modules.homeManager.rofi =
    { pkgs, ... }:
    {
      programs.rofi.enable = true;
    };
}
