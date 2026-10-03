{
  flake.modules.nixos.kitty =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        kitty
      ];
    };
}
