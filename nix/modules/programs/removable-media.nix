{
  flake.modules.nixos.removable-media = 
  { pkgs, ... }:
  {
    services.udisks2.enable = true;
    services.gvfs.enable = true;
    programs.gphoto2.enable = true;

    environment.systemPackages = [ pkgs.glib ];
    environment.sessionVariables.GIO_EXTRA_MODULES = [
      "${pkgs.gvfs}/lib/gio/modules"
      "${pkgs.dconf.lib}/lib/gio/modules"
    ];
  };

  flake.modules.homeManager.removable-media = {
    services.udiskie = {
      enable = true;
      tray = "never";
    };
  };
}
