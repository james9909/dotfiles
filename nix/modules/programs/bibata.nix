{ config, ... }:
let
  inherit (config.flake.modules) homeManager;
in
{
  flake.modules.nixos.bibata = {
    home-manager.sharedModules = [ homeManager.bibata ];
  };

  flake.modules.homeManager.bibata =
    { pkgs, ... }:
    {
      home.pointerCursor = {
        enable = true;
	package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
	size = 24;

        gtk.enable = true;
	x11.enable = true;
      };

      gtk.enable = true;
    };
}
