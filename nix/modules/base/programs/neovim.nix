{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      programs.neovim.enable = true;
    };
}
